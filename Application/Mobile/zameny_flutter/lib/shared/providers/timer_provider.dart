import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class TimeNotifier extends StateNotifier<String?> {
  TimeNotifier({required this.ref}) : super('00:00:00') {
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
      return '00:00:00';
    }

    final remainingDuration = _getRemainingDuration(currentTiming, now);
    return _formatDuration(remainingDuration);
  }

  LessonTimings? _getCurrentTiming(final DateTime now, final List<LessonTimings> timings) {
    if (now.weekday == DateTime.saturday) {
      return timings.where((final timing) =>
          timing.start.isBefore(now) && timing.saturdayEnd.isAfter(now)).firstOrNull;
    }

    return timings.where((final timing) =>
        timing.start.isBefore(now) && timing.end.isAfter(now)).firstOrNull;
  }

  Duration _getRemainingDuration(final LessonTimings timing, final DateTime now) {
    if (now.weekday == DateTime.saturday) {
      return timing.saturdayEnd.difference(now);
    }
    return timing.end.difference(now);
  }

  String _formatDuration(final Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

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

final timeProvider = StateNotifierProvider<TimeNotifier, String?>((final ref) {
  return TimeNotifier(ref: ref);
});


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

extension DateTimeExtension on DateTime {
  DateTime toStartOfDay() {
    return DateTime(year, month, day);
  }

  DateTime toEndOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  String toddmmyyhhmmss() {
    return DateFormat('dd.MM.y HH.mm.ss').format(this);
  }

  String toyyyymmdd() {
    return DateFormat('y-MM-dd').format(this);
  }
}
