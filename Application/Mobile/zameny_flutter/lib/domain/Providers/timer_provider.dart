import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';

class TimeNotifier extends StateNotifier<String> {
  TimeNotifier() : super('00:00:00') {
    _startTicker();
  }

  Timer? _timer;

  void _startTicker() {
    _timer = Timer.periodic(const Duration(seconds: 1), (final _) {
      state = _calculateRemainingTime();
    });
  }

  String _calculateRemainingTime() {
    final now = DateTime.now();
    final timings = GetIt.I.get<Data>().timings;

    final LessonTimings? currentTiming = _getCurrentTiming(now, timings);
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

final timeProvider = StateNotifierProvider<TimeNotifier, String>((final ref) {
  return TimeNotifier();
});
