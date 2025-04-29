import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/teacher_stats_provider.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/new/sharing/sharing.dart';
import 'package:zameny_flutter/widgets/button.dart';

part 'export_schedule_provider.g.dart';

enum ExportScheduleType {
  current(
    'Как тут',
    null,
    Images.export,
  ),
  excel(
    'Excel',
    'Будет отображено расписание без замен',
    Images.excel,
  );

  final String title;
  final String? description;
  final String image;

  const ExportScheduleType(
    this.title,
    this.description,
    this.image,
  );
}

@Riverpod()
ScheduleExport scheduleExport (final Ref ref) {
  return ScheduleExport(ref: ref);
}

class ScheduleExport {
  final Ref ref;

  ScheduleExport({required this.ref});

  Future<void> exportSchedule ({
    required final BuildContext context
  }) async {

    showModalBottomSheet(
      barrierColor: Colors.black.withValues(alpha: 0.3),
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (final context) => const ExportScheduleBottomSheet()
    );
  }

  Future<void> export({
    required final ExportScheduleType type,
    required final BuildContext context,
  }) async {
    final SearchItem searchItem = ref.read(searchItemProvider)!;
    if (type == ExportScheduleType.current) {
      await ref.read(scheduleSettingsProvider).export(
        searchItem: searchItem,
      );
    } else if (type == ExportScheduleType.excel) {
      await ref.read(scheduleSettingsProvider).exportExcel(
        theme: Theme.of(context),
        searchItem: searchItem,
      );
    }
    return;
  }

  Future<void> exportTeacherStats({
    required final BuildContext context,
    required final Teacher teacher,
  }) async {
    await _exportTeacherStats(
      theme: Theme.of(context),
      teacher: teacher
    );
  }

  Future<void> _exportTeacherStats({
    required final Teacher teacher,
    required final ThemeData theme,
  }) async {
    final List<LessonTimings> timings = ref.watch(timingsProvider).value!;
    final startDate = Constants.septemberFirst.toStartOfDay();
    final endDate = DateTime.now().add(const Duration(days: 1)).toEndOfDay();

    final TeacherStatsData stats = await ref.watch(teacherStatsProvider).getStats(
      startDate: startDate,
      endDate: endDate,
      item: teacher
    );

    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText('Пары преподавателя ${teacher.name} за ${startDate.toyyyymmdd()} - ${endDate.toyyyymmdd()}');
    sheet.getRangeByName('A3').setText('Замены');
    sheet.getRangeByName('A4').setText('Дата');

    for (var i = 0; i < timings.length; i++) {
      final LessonTimings timing = timings[i];

       sheet.getRangeByName('A${5 + i}').setText(timing.number.toString());
    }

    for (var i = 0; i < stats.schedule.length; i++) {
      final DayData data = stats.schedule[i];
      _buildDay(
        rowOffset: 5,
        offset: i + 2,
        sheet: sheet,
        data: data,
      );
    }

    _buildStats(
      rowOffset: 15,
      stats: stats,
      sheet: sheet
    );

    sheet.getRangeByIndex(3, 1, 11, 1 + stats.schedule.length).cellStyle.borders.all.lineStyle = excel.LineStyle.thin;
    sheet.getRangeByIndex(3, 1, 11, 1 + stats.schedule.length).cellStyle.borders.all.color = Colors.black.hexCode;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    
    ref.read(sharingProvier).shareFile(text: 'Расписание ${teacher.name}', files: [Uint8List.fromList(bytes)], format: 'xlsx');
  }

  void _buildStats({
    required final int rowOffset,
    required final TeacherStatsData stats,
    required final excel.Worksheet sheet
  }) {
    final Set<int> groupsIds = stats.schedule
    .expand((final a) => a.paras)
    .expand((final b) => b)
    .map((final c) => c.lesson.group)
    .toSet();

    final Set<int> coursesIds = stats.schedule
    .expand((final a) => a.paras)
    .expand((final b) => b)
    .map((final c) => c.lesson.course)
    .toSet();

    final List<Group> groups = groupsIds.map((final id) => ref.watch(groupProvider(id))!).toList();
    final List<Course> courses = coursesIds.map((final id) => ref.watch(courseProvider(id))!).toList();
    
    // for (var i = 0; i < courses.length; i++) {
    //   final Course course = courses[i];

    //   sheet.getRangeByIndex(rowOffset + i, 1).setText(course.name);
    //   sheet.getRangeByIndex(rowOffset + i, 1).cellStyle.wrapText = true;
    //   sheet.setColumnWidthInPixels(1, 150);
    // }

    // for (var i = 0; i < groups.length; i++) {
    //   final Group group = groups[i];

    //   sheet.getRangeByIndex(rowOffset - 1, 2 + i).setText(group.name);
    //   sheet.getRangeByIndex(rowOffset - 1, 2 + i).cellStyle.wrapText = true;
    // }

    List<(Group, Course, int)> mapped = [];
    for (var x = 0; x < groups.length; x++) {
      for (var y = 0; y < courses.length; y++) {
        final Group group = groups[x];
        final Course course = courses[y];
        final List<int> hours = stats.schedule.expand((final day) => day.paras).expand((final para) => para)
          .where((final lessonSlot) => lessonSlot.lesson.group == group.id && lessonSlot.lesson.course == course.id)
          .map((final lessonSlot) => lessonSlot.cost)
          .toList();

        final int sum = hours.fold(0, (final total, final current) => total + current);

        if (sum != 0) {
          mapped.add((
            group,
            course,
            sum
          ));
        }

        // sheet.getRangeByIndex(rowOffset + y, 2 + x).setText(sum.toString());
      }
    }

    for (var i = 0; i < mapped.length; i++) {
      final (Group, Course, int) item = mapped[i];
      sheet.getRangeByIndex(rowOffset + i, 2).setText('${item.$1.name}\n${item.$2.name}');
      sheet.getRangeByIndex(rowOffset + i, 3).setText('${item.$3}');
    }
  }

  void _buildDay ({
    required final int offset,
    required final DayData data,
    required final int rowOffset,
    required final excel.Worksheet sheet
  }) {
    // Помогите, она хочет еще один выходной документ...
    sheet.getRangeByIndex(rowOffset - 2, offset).setText(data.zamenaLink);
    sheet.getRangeByIndex(rowOffset - 1, offset).setText(data.date.toddMM().toString());

    for (var i = 0; i < data.paras.length; i++) {
      final List<ParaData> paraData = data.paras[i];

      final ParaData? text = paraData.firstOrNull;

      if (text == null) {
        continue;
      }

      final Group group = ref.read(groupProvider(text.lesson.group))!;
      final Course course = ref.read(courseProvider(text.lesson.course))!;

      sheet.getRangeByIndex(rowOffset + i, offset).setText("(${group.name.toString()}) ${course.name}");
      sheet.getRangeByIndex(rowOffset + i, offset).cellStyle.wrapText = true;
      sheet.setColumnWidthInPixels(offset, 120);
      sheet.setRowHeightInPixels(rowOffset + i, 60);
      if (text.isZamena) {
        sheet.getRangeByIndex(rowOffset + i, offset).cellStyle.fontColor = '#C67878';
      }
    }
  }
}

class ExportScheduleBottomSheet extends ConsumerStatefulWidget {
  const ExportScheduleBottomSheet({super.key});

  @override
  ConsumerState<ExportScheduleBottomSheet> createState() => _ExportScheduleBottomSheetState();
}

class _ExportScheduleBottomSheetState extends ConsumerState<ExportScheduleBottomSheet> {
  ExportScheduleType selectedType = ExportScheduleType.current;

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              'Экспорт расписания',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuPrimaryBold20,
            ),
            Row(
              spacing: 8,
              children: List.generate(ExportScheduleType.values.length, (final int index) {
                final ExportScheduleType type = ExportScheduleType.values[index];
                return Expanded(
                  child: Bounceable(
                    onTap: () {
                      selectedType = type;
                      setState(() {
                        
                      });
                    },
                    child: ExportTile(
                      selected: selectedType == type,
                      type: type,
                    ),
                  ),
                );
              }).toList()
            ),
            AnimatedSwitcher(
              duration: Delays.morphDuration,
              child: Text(
                key: ValueKey(selectedType),
                selectedType.description ?? '',
                textAlign: TextAlign.center,
                style: context.styles.ubuntuInverseSurface40014,
              ),
            ),
            Button.primary(
              context: context,
              onClicked: () {
                ref.read(scheduleExportProvider).export(
                  type: selectedType,
                  context: context,
                );
              },
              text: 'Скачать'
            )
          ],
        ),
      ),
    );
  }
}

class ExportTile extends StatelessWidget {
  final bool selected;
  final ExportScheduleType type;

  const ExportTile({
    required this.type,
    required this.selected,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: selected ? 1 : 0.6,
      duration: Delays.morphDuration,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary)
        ),
        child: Column(
          spacing: 8,
          children: [
            SvgPicture.asset(
              type.image,
              colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
            Text(
              type.title,
              style: context.styles.ubuntuInverseSurface16,
            )
          ],
        ),
      ),
    );
  }
}
