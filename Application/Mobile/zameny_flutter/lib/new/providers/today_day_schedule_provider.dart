import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/shared/domain/models/day_schedule_model.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';
import 'package:zameny_flutter/shared/domain/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/providers/search_item_provider.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';

final todayDayScheduleProvider = AsyncNotifierProvider<TodayDayScheduleNotifier, DaySchedule?>(() {
  return TodayDayScheduleNotifier();
});


class TodayDayScheduleNotifier extends AsyncNotifier<DaySchedule?> {
  @override
  FutureOr<DaySchedule?> build() async {
    final SearchItem? searchItem = ref.watch(searchItemProvider);

    if (searchItem == null) {
      return null;
    }

    final DaySchedulesProvider daySchedulesProvider = ref.watch(dayScheduleProvider);
    final List<LessonTimings> timings = await ref.watch(timingsProvider.future);

    final DateTime startdate = DateTime.now().toStartOfDay();
    final DateTime endDate = DateTime.now().toEndOfDay();

    if (searchItem is Group) {
      List<DaySchedule> schedule = await daySchedulesProvider.groupSchedule(
        searchItem: searchItem,
        startdate: startdate,
        timings: timings,
        endDate: endDate,
      );

      return schedule.firstOrNull;
    } else if (searchItem is Teacher) {
      List<DaySchedule> schedule = await daySchedulesProvider.teacherSchedule(
        searchItem: searchItem,
        startdate: startdate,
        timings: timings,
        endDate: endDate,
      );

      return schedule.firstOrNull;
    } else if (searchItem is Cabinet) {
      List<DaySchedule> schedule = await daySchedulesProvider.cabinetSchedule(
        searchItem: searchItem,
        startdate: startdate,
        timings: timings,
        endDate: endDate,
      );

      return schedule.firstOrNull;
    }

    return null;
  }
}
