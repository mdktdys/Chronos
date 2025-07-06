import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/providers/timer_provider.dart';
import 'package:zameny_flutter/providers/timings_provider.dart';
import 'package:zameny_flutter/providers/today_day_schedule_provider.dart';

class CurrentTimingTimer extends ConsumerWidget {
  const CurrentTimingTimer({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final DaySchedule? schedule = ref.watch(todayDayScheduleProvider).value;
    final List<LessonTimings>? timings = ref.watch(timingsProvider).value;
    final String? timeLeft = ref.watch(timeProvider);

    final now = DateTime.now();

    if (now.weekday == DateTime.sunday) {
      return const SizedBox();
    }

    if (schedule?.holidays.isNotEmpty ?? false) {
      return const SizedBox();
    }

    LessonTimings? timing;
    if (now.weekday == DateTime.saturday) {
      timing = timings?.where((final LessonTimings timing) => timing.saturdayStart.isBefore(now) && timing.saturdayEnd.isAfter(now)).firstOrNull;
    } else {
      timing = timings?.where((final LessonTimings timing) => timing.start.isBefore(now) && timing.end.isAfter(now)).firstOrNull;
    }

    if (timing == null) {
      return const SizedBox();
    }

    return AnimatedSize(
      duration: Delays.fastMorphDuration,
      curve: Curves.ease,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сейчас идет ${timing.number} пара',
                style: context.styles.ubuntuPrimaryBold24,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (timeLeft != null)
                    Text(
                      'Осталось: $timeLeft',
                      style: context.styles.ubuntuBold18.copyWith(color: Theme.of(context).primaryColorLight.withValues(alpha: 0.7)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
