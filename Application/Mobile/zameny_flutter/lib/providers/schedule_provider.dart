import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'package:zameny_flutter/config/enums/schedule_view_mode_enum.dart';
import 'package:zameny_flutter/config/enums/schedule_view_modes_enum.dart';
import 'package:zameny_flutter/config/extensions/color_extension.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/paras/paras_model.dart';
import 'package:zameny_flutter/platform/sharing/sharing.dart';
import 'package:zameny_flutter/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/providers/groups_provider.dart';
import 'package:zameny_flutter/providers/navigation_date_provider.dart';
import 'package:zameny_flutter/providers/schedule_tiles_builder.dart';
import 'package:zameny_flutter/providers/timings_provider.dart';

final scheduleSettingsProvider = ChangeNotifierProvider<ScheduleSettingsNotifier>((final ref) {
  return ScheduleSettingsNotifier(ref: ref);
});

class ScheduleSettingsNotifier extends ChangeNotifier {
  Ref ref;
  ScreenshotController screenShotController = ScreenshotController();
  ScheduleViewModes viewmode = ScheduleViewModes.auto;
  ScheduleViewMode sheduleViewMode = ScheduleViewMode.schedule;
  bool obed = false;

  ScheduleSettingsNotifier({required this.ref});

  Future<void> exportExcel({
    required final SearchItem searchItem,
    required final ThemeData theme,
  }) async {
    final List<LessonTimings>? timings = ref.watch(timingsProvider).value;
    DateTime startdate = ref.watch(navigationDateProvider);
    startdate = startdate.subtract(Duration(days: startdate.weekday - 1));
    final DateTime endDate = startdate.add(const Duration(days: 6));

    if(timings == null) {
      return;
    }

    List<DaySchedule>? schedule;
    List<List<List<TileData>>> tiles = [];

    if (searchItem is Group) {
      schedule = await ref.watch(dayScheduleProvider).groupSchedule(
        timings: timings,
        startdate: startdate,
        searchItem: searchItem,
        endDate: endDate
      );

      tiles = schedule.map((final DaySchedule sched) {
        if (sched.holidays.isNotEmpty && sheduleViewMode == ScheduleViewMode.schedule) {
          return List<List<TileData>>.of([]);
        }

        return sched.paras.map((final Paras para) {
          return ref.watch(scheduleTileDataBuilderProvider).buildGroupTiles(
            zamenaFull: sched.zamenaFull,
            viewMode: sheduleViewMode,
            isSaturday: false,
            para: para,
            obed: obed
          );
        }).toList();
      }).toList();
    } else if (searchItem is Teacher) {
      schedule = await ref.watch(dayScheduleProvider).teacherSchedule(
        timings: timings,
        startdate: startdate,
        searchItem: searchItem,
        endDate: endDate
      );

      tiles = schedule.map((final DaySchedule sched) {
        if (sched.holidays.isNotEmpty && sheduleViewMode == ScheduleViewMode.schedule) {
          return List<List<TileData>>.of([]);
        }
        
        return sched.paras.map((final Paras para) {
          return ref.watch(scheduleTileDataBuilderProvider).buildTeacherTiles(
            teacherId: searchItem.id,
            viewMode: sheduleViewMode,
            isSaturday: false,
            para: para,
            obed: obed
          );
        }).toList();
      }).toList();
    }

    if (schedule == null) {
      return;
    }

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Расписание ${searchItem.name}');
    final Range a = sheet.getRangeByName('A1:F1');
    a.cellStyle.hAlign = HAlignType.center;
    a.cellStyle.vAlign = VAlignType.center;
    a.merge();

    sheet.setRowHeightInPixels(1, 35);
    sheet.setColumnWidthInPixels(6, 35);
    sheet.setColumnWidthInPixels(5, 150);
    sheet.setColumnWidthInPixels(4, 25);
    sheet.setColumnWidthInPixels(1, 25);
    sheet.setColumnWidthInPixels(2, 150);
    sheet.setColumnWidthInPixels(3, 35);

    int offset = 2;
    offset += _buildRow(
      offset: offset,
      sheet: sheet,
      theme: theme,
      schedule: tiles,
      leftIndex: 0,
      rightIndex: 3,
      searchItem: searchItem
    );

    offset += _buildRow(
      offset: offset,
      sheet: sheet,
      theme: theme,
      schedule: tiles,
      leftIndex: 1,
      rightIndex: 4,
      searchItem: searchItem
    );

    offset += _buildRow(
      offset: offset,
      sheet: sheet,
      theme: theme,
      schedule: tiles,
      leftIndex: 2,
      rightIndex: 5,
      searchItem: searchItem
    );

    sheet.getRangeByName('A2:F${offset - 1}').cellStyle.borders.all.color = Colors.black.hexCode;
    sheet.getRangeByName('A2:F${offset - 1}').cellStyle.borders.all.lineStyle = LineStyle.thin;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    
    ref.read(sharingProvier).shareFile(text: 'Расписание ${searchItem.name}', files: [Uint8List.fromList(bytes)], format: 'xlsx');
  }

  int _buildRow({
    required final int offset,
    required final Worksheet sheet,
    required final ThemeData theme,
    required final List<List<List<TileData>>> schedule,
    required final int leftIndex,
    required final int rightIndex,
    required final SearchItem searchItem,
  }) {
    final List<String> weekdays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'];
    String primary = theme.colorScheme.primary.getShadeColor().colorToHex();
    String surface = theme.colorScheme.primary.getShadeColor(shadeValue: 20).colorToHex();

    final mondayTitleCell = sheet.getRangeByName('A$offset');
    mondayTitleCell.setText(weekdays[leftIndex]);
    mondayTitleCell.cellStyle.hAlign = HAlignType.center;
    mondayTitleCell.cellStyle.italic = true;
    mondayTitleCell.cellStyle.backColor = primary;
    sheet.getRangeByName('A$offset:C$offset').merge();

    final thursdayTitleCell = sheet.getRangeByName('D$offset');
    thursdayTitleCell.setText(weekdays[rightIndex]);
    thursdayTitleCell.cellStyle.hAlign = HAlignType.center;
    thursdayTitleCell.cellStyle.italic = true;
    thursdayTitleCell.cellStyle.backColor = primary;
    sheet.getRangeByName('D$offset:F$offset').merge();

    final List<List<TileData>> mondayLessons = schedule[leftIndex];
    final List<List<TileData>> thursdayLessons = schedule[rightIndex];

    int minimal = 1;
    final int? leftMinimal = mondayLessons.expand((final a) => a).firstOrNull?.lesson.number;
    final int? rightMinimal = thursdayLessons.expand((final a) => a).firstOrNull?.lesson.number;
    
    if (leftMinimal != null && rightMinimal != null) {
      minimal = math.min(leftMinimal, rightMinimal);
    } else if (leftMinimal != null && rightMinimal == null) {
      minimal = leftMinimal;
    } else if (leftMinimal == null && rightMinimal != null) {
      minimal = rightMinimal;
    } else {
      minimal = 0;
    }

    final int? leftMaximal = mondayLessons.expand((final a) => a).lastOrNull?.lesson.number;
    final int? rightMaximal = thursdayLessons.expand((final a) => a).lastOrNull?.lesson.number;

    int maximal = 7;
    if (leftMaximal != null && rightMaximal != null) {
      maximal = math.max(leftMaximal, rightMaximal);
    } else if (leftMaximal != null && rightMaximal == null) {
      maximal = leftMaximal;
    } else if (leftMaximal == null && rightMaximal != null) {
      maximal = rightMaximal;
    } else {
      maximal = 0;
    }

    int j = 0;
    for (int i = minimal; i <= maximal; i++) {
      j++;
      final TileData? para = mondayLessons.where((final List<TileData> para) => para.firstOrNull?.lesson.number == i).firstOrNull?.firstOrNull;
      final TileData? paraS = thursdayLessons.where((final List<TileData> para) => para.firstOrNull?.lesson.number == i).firstOrNull?.firstOrNull;

      if (para != null) {
        _place(
          sheet: sheet,
          para: para,
          cell: '${offset + j}',
          column: 0,
          searchItem: searchItem,
        );
      }

      if (paraS != null) {
        _place(
          searchItem: searchItem,
          sheet: sheet,
          para: paraS,
          cell: '${offset + j}',
          column: 3,
        );
      }

      sheet.getRangeByName('A${offset + j}').cellStyle.backColor = surface;
      sheet.getRangeByName('D${offset + j}').cellStyle.backColor = surface;
    }

    return j + 1;
  }

  void _place({
    required final SearchItem searchItem,
    required final Worksheet sheet,
    required final TileData para,
    required final String cell,
    required final int column,
  }) {
    final List<String> columns = ['A', 'B', 'C', 'D', 'E', 'F'];

    Lesson? lesson;
    if (para is TileZamenaOnLesson) {
      lesson = para.zamena;
    } else {
      lesson = para.lesson;
    }

    final Course? course = ref.watch(courseProvider(lesson.course));
    final Cabinet? cabinet = ref.watch(cabinetProvider(lesson.cabinet));
    final Teacher? teacher = ref.watch(teacherProvider(lesson.teacher));
    final Group? group = ref.watch(groupProvider(lesson.group));

    sheet.getRangeByName('${columns[column]}$cell').setText(para.lesson.number.toString());
    sheet.getRangeByName('${columns[column]}$cell').type = CellType.blank;
    sheet.getRangeByName('${columns[column]}$cell').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('${columns[column]}$cell').cellStyle.vAlign = VAlignType.center;

    if (searchItem is Teacher) {
      sheet.getRangeByName('${columns[column + 1]}$cell').setText("${course?.name.toString()} (${group?.name})");
    } else if (searchItem is Group) {
      sheet.getRangeByName('${columns[column + 1]}$cell').setText("${course?.name.toString()} (${teacher?.name})");
    } else if (searchItem is Cabinet) {
      sheet.getRangeByName('${columns[column + 1]}$cell').setText("${course?.name.toString()} (${teacher?.name}) (${group?.name})");
    }
    sheet.getRangeByName('${columns[column + 1]}$cell').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('${columns[column + 1]}$cell').cellStyle.wrapText = true;

    if (para is TileRemovedLessonData) {
      sheet.getRangeByName('${columns[column + 1]}$cell').cellStyle.fontColor = Colors.grey.hexCode;
    } else if (para is TileWithZamenaData) {
      sheet.getRangeByName('${columns[column + 1]}$cell').cellStyle.fontColor = Colors.red.hexCode;
    } else if (para is TileZamenaOnLesson) {  
      sheet.getRangeByName('${columns[column + 1]}$cell').cellStyle.fontColor = Colors.red.hexCode;
    }

    sheet.getRangeByName('${columns[column + 2]}$cell').setText(cabinet?.name.toString());
    sheet.getRangeByName('${columns[column + 2]}$cell').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('${columns[column + 2]}$cell').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('${columns[column + 2]}$cell').cellStyle.wrapText = true;
  }

  Future<void> export({
    required final SearchItem searchItem,
  }) async {
    final Uint8List? image = await screenShotController.capture();

    if (image == null) {
      return;
    }

    ref.read(sharingProvier).shareFile(text: 'Расписание ${searchItem.name}', files: [image], format: 'png');
  }

  void notify() {
    notifyListeners();
  }
}
