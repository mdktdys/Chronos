import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/providers/timings_provider.dart';

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
