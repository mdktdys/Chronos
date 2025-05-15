import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/color_extension.dart';
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
import 'package:zameny_flutter/shared/tools.dart';
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
    null,
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
    showModalBottomSheet(
      barrierColor: Colors.black.withValues(alpha: 0.3),
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (final context) => ExportTeacherStatsBottomSheet(teacher: teacher)
    );

    // await _exportTeacherStats(
    //   theme: Theme.of(context),
    //   teacher: teacher
    // );
  }

  Future<void> _exportTeacherStats({
    required final Teacher teacher,
    required final ThemeData theme,
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final List<LessonTimings> timings = ref.watch(timingsProvider).value!;
    final TeacherStatsData stats = await ref.watch(teacherStatsProvider).getStats(
      startDate: startDate.toStartOfDay(),
      endDate: endDate.toEndOfDay(),
      item: teacher
    );

    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Часы';
    final String primary = theme.colorScheme.primary.getShadeColor().colorToHex();
    final String surface = theme.colorScheme.primary.getShadeColor(shadeValue: 20).colorToHex();

    sheet.getRangeByName('A1').setText('Часы преподавателя ${teacher.name}');
    
    DateTime currentMonth = DateTime(startDate.year, startDate.month);
    int index = 1;
    while (currentMonth.isBefore(DateTime(endDate.year, endDate.month + 1))) {
      final List<DayData> monthDayDatas = stats.schedule.where((final DayData dayData) => dayData.date.month == currentMonth.month && dayData.date.year == currentMonth.year).toList();
      workbook.worksheets.addWithName(currentMonth.toMonth());
      final excel.Worksheet monthSheet = workbook.worksheets[index];
      monthSheet.getRangeByName('A1').setText('Дата');
      monthSheet.getRangeByName('A1').cellStyle.backColor = primary;

      sheet.getRangeByName('A${index + 2}').setText(currentMonth.toMonth());
      sheet.getRangeByName('A${index + 2}').cellStyle.backColor = surface;

      for (var i = 0; i < timings.length; i++) {
        final LessonTimings timing = timings[i];  
        monthSheet.getRangeByName('A${2 + i}').setText(timing.number.toString());
        monthSheet.getRangeByName('A${2 + i}').cellStyle.backColor = surface;
      }

      monthSheet.getRangeByIndex(1, 1, 8, 1 + monthDayDatas.length).cellStyle.borders.all.lineStyle = excel.LineStyle.thin;
      monthSheet.getRangeByIndex(1, 1, 8, 1 + monthDayDatas.length).cellStyle.borders.all.color = Colors.black.hexCode;

      for (var i = 0; i < monthDayDatas.length; i++) {
        final DayData data = monthDayDatas[i];

        _buildDay(
          rowOffset: 2,
          offset: i + 2,
          sheet: monthSheet,
          data: data,
          primary: primary,
        );
      }
      
      int year = currentMonth.year;
      int month = currentMonth.month + 1;
      if (month > 12) {
        month = 1;
        year++;
        
      }
      currentMonth = DateTime(year, month);
      index ++;
    }

    final int lenght = _buildStats(
      endDate: endDate,
      startDate: startDate,
      rowOffset: 2,
      stats: stats,
      sheet: sheet,
      monthLenght: index,
      primary: primary
    );

    sheet.getRangeByName('A${index + 2}').setText('Итого');
    sheet.getRangeByName('A${index + 2}').cellStyle.backColor = primary;

    sheet.getRangeByName('A2').setText('Группа / Месяц');
    sheet.getRangeByName('A2').cellStyle.backColor = primary;
    sheet.getRangeByName('A2').cellStyle.hAlign = excel.HAlignType.center;
    sheet.getRangeByName('A2').cellStyle.vAlign = excel.VAlignType.center;
    sheet.getRangeByName('A2').cellStyle.wrapText = true;

    sheet.getRangeByIndex(1, 1, index + 2, 1 + lenght).cellStyle.borders.all.lineStyle = excel.LineStyle.thin;
    sheet.getRangeByIndex(1, 1, index + 2, 1 + lenght).cellStyle.borders.all.color = Colors.black.hexCode;
    sheet.getRangeByIndex(1, 1, 1, 1 + lenght).merge();
    sheet.getRangeByIndex(1, 1, 1, 1 + lenght).cellStyle.backColor = primary;
    sheet.getRangeByIndex(1, 1, 1, 1 + lenght).cellStyle.hAlign = excel.HAlignType.center;

    sheet.autoFitColumn(1);

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    
    ref.read(sharingProvier).shareFile(text: 'Часы ${teacher.name}', files: [Uint8List.fromList(bytes)], format: 'xlsx');
  }

  int _buildStats({
    required final int rowOffset,
    required final DateTime startDate,
    required final DateTime endDate,
    required final TeacherStatsData stats,
    required final excel.Worksheet sheet,
    required final int monthLenght,
    required final String primary
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

    List<(Group, Course, int, List<int>)> mapped = [];
    for (var x = 0; x < groups.length; x++) {
      for (var y = 0; y < courses.length; y++) {
        final Group group = groups[x];
        final Course course = courses[y];
        final List<int> hours = stats.schedule.expand((final day) => day.paras).expand((final para) => para)
          .where((final lessonSlot) => lessonSlot.lesson.group == group.id && lessonSlot.lesson.course == course.id)
          .map((final lessonSlot) => lessonSlot.cost)
          .toList();

        final int sum = hours.fold(0, (final total, final current) => total + current);
        
        DateTime currentMonth = DateTime(startDate.year, startDate.month);
        final List<int> monthsHours = [];
        while (currentMonth.isBefore(DateTime(endDate.year, endDate.month + 1))) {
          final List<int> hours = stats.schedule.where((final DayData a) => a.date.month == currentMonth.month && a.date.year == currentMonth.year).expand((final day) => day.paras).expand((final para) => para)
          .where((final lessonSlot) => lessonSlot.lesson.group == group.id && lessonSlot.lesson.course == course.id)
          .map((final lessonSlot) => lessonSlot.cost)
          .toList();

          final int sum = hours.fold(0, (final total, final current) => total + current);
          monthsHours.add(sum);

          int year = currentMonth.year;
          int month = currentMonth.month + 1;
          if (month > 12) {
            month = 1;
            year++;
            
          }
          currentMonth = DateTime(year, month);
        }


        if (sum != 0) {
          mapped.add((
            group,
            course,
            sum,
            monthsHours
          ));
        }
      }
    }

    mapped.sort((final a, final b) => a.$1.name.compareTo(b.$1.name));

    for (var i = 0; i < mapped.length; i++) {
      final (Group, Course, int, List<int>) item = mapped[i];
      sheet.getRangeByIndex(2, rowOffset + i).setText('${item.$1.name}\n${item.$2.name}');
      sheet.getRangeByIndex(2, rowOffset + i).cellStyle.backColor = getColorForText(item.$1.name).getShadeColor(shadeValue: 30).hexCode;
      sheet.getRangeByIndex(monthLenght + 2, rowOffset + i).setText('${item.$3}');
      sheet.getRangeByIndex(monthLenght + 2, rowOffset + i).cellStyle.backColor = primary;
      sheet.getRangeByIndex(monthLenght + 2, rowOffset + i).cellStyle.hAlign = excel.HAlignType.center;

      for (var j = 0; j < monthLenght - 1; j++) {
        sheet.getRangeByIndex(3 + j, rowOffset + i).setText(item.$4[j].toString());
        sheet.getRangeByIndex(3 + j, rowOffset + i).cellStyle.hAlign = excel.HAlignType.center;
      }

      sheet.setColumnWidthInPixels(rowOffset + i, 100);
    }

    return mapped.length;
  }

  void _buildDay ({
    required final int offset,
    required final DayData data,
    required final int rowOffset,
    required final excel.Worksheet sheet,
    required final String primary
  }) {
    // sheet.getRangeByIndex(rowOffset - 2, offset).setText(data.zamenaLink);
    sheet.getRangeByIndex(rowOffset - 1, offset).setText(data.date.toddMM().toString());
    sheet.getRangeByIndex(rowOffset - 1, offset).cellStyle.backColor = primary;

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

class ExportTeacherStatsBottomSheet extends ConsumerStatefulWidget {
  final Teacher teacher;

  const ExportTeacherStatsBottomSheet({
    required this.teacher,
    super.key
  });

  @override
  ConsumerState<ExportTeacherStatsBottomSheet> createState() => _ExportTeacherStatsBottomSheetState();
}

class _ExportTeacherStatsBottomSheetState extends ConsumerState<ExportTeacherStatsBottomSheet> {
  PickerDateRange selectedDate = PickerDateRange(Constants.septemberFirst, DateTime.now().add(const Duration(days: 1)));

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
              'Экспорт часов преподавателя',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuPrimaryBold20,
            ),
            AnimatedSwitcher(
              duration: Delays.morphDuration,
              child: Text(
                key: ValueKey(selectedDate),
                selectedDate.endDate != null && selectedDate.startDate != null
                ? 'Готово! Жми скачать'
                : 'Выбери даты для экспорта',
                textAlign: TextAlign.center,
                style: context.styles.ubuntuInverseSurface40014,
              ),
            ),
            Flexible(
              child: AspectRatio(
                aspectRatio: 1/1,
                child: SfDateRangePicker(
                  headerStyle: const DateRangePickerHeaderStyle(backgroundColor: Colors.transparent),
                  backgroundColor: Colors.transparent,
                  initialSelectedRange: PickerDateRange(Constants.septemberFirst, DateTime.now().add(const Duration(days: 1))),
                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  selectionMode: DateRangePickerSelectionMode.range,
                  monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.monday),
                  maxDate: DateTime.now().add(const Duration(days: 1)),
                  onSelectionChanged: (final dateRangePickerSelectionChangedArgs) {
                    selectedDate = dateRangePickerSelectionChangedArgs.value;
                    setState(() {});
                  },
                ),
              ),
            ),
            Button.primary(
              context: context,
              onClicked: () {
                if (selectedDate.endDate == null || selectedDate.startDate == null) {
                  return;
                }
                ref.read(scheduleExportProvider)._exportTeacherStats(
                  startDate: selectedDate.startDate!,
                  endDate: selectedDate.endDate!.add(const Duration(days: 1)),
                  theme: Theme.of(context),
                  teacher: widget.teacher,
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
