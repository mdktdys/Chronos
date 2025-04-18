import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';

final timeProvider = StateNotifierProvider<TimeNotifier, String?>((final ref) {
  return TimeNotifier(ref: ref);
});

class TimeNotifier extends StateNotifier<String?> {
  TimeNotifier({required this.ref}) : super(null) {
    _startTicker();
  }

  Timer? _timer;
  Ref ref;

  void _startTicker() {
    _timer = Timer.periodic(const Duration(seconds: 1), (final _) {
      state = _calculateRemainingTime();
    });
  }

  String? _calculateRemainingTime() {
    final now = DateTime.now();
    final timings = ref.watch(timingsProvider);

    if (!timings.hasValue) {
      return null;
    }

    final LessonTimings? currentTiming = _getCurrentTiming(now, timings.value!);
    if (currentTiming == null) {
      return null;
    }

    final remainingDuration = _getRemainingDuration(currentTiming, now);
    return _formatDuration(remainingDuration);
  }

  LessonTimings? _getCurrentTiming(final DateTime now, final List<LessonTimings> timings) {
    if (now.weekday == DateTime.saturday) {
      return timings.where((final timing) => timing.saturdayStart.isBefore(now) && timing.saturdayEnd.isAfter(now)).firstOrNull;
    }

    return timings.where((final timing) => timing.start.isBefore(now) && timing.end.isAfter(now)).firstOrNull;
  }

  Duration _getRemainingDuration(final LessonTimings timing, final DateTime now) {
    if (now.weekday == DateTime.saturday) {
      return timing.saturdayEnd.difference(now);
    }

    return timing.end.difference(now);
  }

  String _formatDuration(final Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}



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

    final DateTime startdate = DateTime.now();
    final DateTime endDate = DateTime.now();

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
    }

    return null;
  }
}
