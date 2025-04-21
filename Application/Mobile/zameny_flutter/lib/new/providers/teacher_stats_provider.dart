import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';

part 'teacher_stats_provider.g.dart';

@Riverpod()
TeacherStats teacherStats (final Ref ref) {
  return TeacherStats(ref: ref);
}

class TeacherStats {
  final Ref ref;

  TeacherStats({
    required this.ref
  });

  Future<TeacherStatsData> getStats({
    required final DateTime startDate,
    required final DateTime endDate,
    required final Teacher item,
  }) async {
    final daySchedulesProvider = ref.watch(dayScheduleProvider);
    final List<LessonTimings> timings = ref.watch(timingsProvider).value!;

    final List<DaySchedule> schedule = await daySchedulesProvider.teacherSchedule(
      timings: timings,
      startdate: startDate,
      searchItem: item,
      endDate: endDate,
    );

    List<DayData> daysData = [];
    for (DaySchedule daySchedule in schedule) {
      final paras = daySchedule.paras.map((final Paras para) {
        return ref.watch(scheduleTilesBuilderProvider).buildParaData(
          date: daySchedule.date,
          teacherId: item.id,
          para: para,
        );
      }).toList();

      daysData.add(DayData(
        zamenaLink: daySchedule.zamenaLinks?.firstOrNull?.link,
        date: daySchedule.date,
        paras: paras
      ));
    }

    return TeacherStatsData(
      schedule: daysData
    );
  }
}

class TeacherStatsData {
  final List<DayData> schedule;
  
  TeacherStatsData({
    required this.schedule,
  });
}

class DayData {
  final DateTime date;
  final List<List<ParaData>> paras;
  final String? zamenaLink;

  DayData({
    required this.date,
    required this.paras,
    required this.zamenaLink
  });
}

class ParaData {
  final Lesson lesson;
  final bool isZamena;
  final int cost;

  ParaData({
    required this.cost,
    required this.lesson,
    required this.isZamena,
  });
}
