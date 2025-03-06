
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/shared/providers/timer_provider.dart';


class CurrentLessonTimer extends ConsumerStatefulWidget {
  const CurrentLessonTimer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrentLessonTimerState();
}

class _CurrentLessonTimerState extends ConsumerState<CurrentLessonTimer> {
  late Timer ticker;
  bool obed = false;

  @override
  void initState() {
    super.initState();
    ticker = Timer.periodic(const Duration(seconds: 1), (final timer) {
      tick();
    });
  }

  void tick() {
    setState(() {});
  }

  void toggleObed() {
    obed = !obed;
    setState(() {});
  }

  String getElapsedTime(final bool obed) {
    final LessonTimings timing = getLessonTiming(obed)!;
    final bool isSaturday = DateTime.now().weekday == 6;
    final Duration left = isSaturday
        ? timing.saturdayEnd.difference(DateTime.now())
        : (obed
            ? timing.obedEnd.difference(DateTime.now())
            : timing.end.difference(DateTime.now()));

    final int hours = left.inHours;
    final int minutes = left.inMinutes;
    final int seconds = left.inSeconds;

    final int secs = seconds % 60;
    final int mints = minutes % 60;

    return '$hours:${mints > 9 ? mints : '0$mints'}:${secs > 9 ? secs : '0$secs'}';
  }

  LessonTimings? getLessonTiming(final bool obed) {
    final provider = ref.watch(timingsProvider);
    
    if (!provider.hasValue) {
      return null;
    }

    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;

    final List<LessonTimings> timings = provider.value!;

    if (isSaturday) {
      final LessonTimings? timing = timings.where((final element) =>
        element.start.isBefore(current) &&
        element.saturdayEnd.isAfter(current),)
        .firstOrNull;
      return timing;
    } else {
      if (obed) {
        final LessonTimings? timing = timings
          .where((final element) =>
          element.obedStart.isBefore(current) &&
          element.obedEnd.isAfter(current),)
          .firstOrNull;
        return timing;
      } else {
        final LessonTimings? timing = timings
          .where((final element) =>
          element.start.isBefore(current) && element.end.isAfter(current),)
          .firstOrNull;
        return timing;
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final LessonTimings? timing = getLessonTiming(obed);
    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;
    // const bool needObedSwitch = true;
    final DaySchedule? schedule = ref.watch(todayDayScheduleProvider).value;

    Widget child = const SizedBox.shrink();

    if (
      timing == null
      || current.weekday == 7
    ) {
      child = const SizedBox.shrink();
    }

    if (schedule == null) {
      
    } else {
      List<Paras> paras = schedule.paras.where((final para) => para.number == timing!.number).toList();

      child = Column(
        children: paras.map((final para) => CourseTileRework(
          searchType: SearchType.group,
          lesson: para.lesson!.first,
          index: para.number!
        )).toList()
      );
    }

    // schedule.paras.where((paras) => paras.)

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.ease,
          child: timing == null || current.weekday == 7
              ? const SizedBox()
              : Builder(builder: (final context) {
                  
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Сейчас идет ${timing.number} пара',
                          textAlign: TextAlign.start,
                          style: context.styles.ubuntuPrimaryBold24,
                        ),
                        const SizedBox(height: 5),
                        child
                      ],
                    );
                },
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            timing != null ?
              Text(
                'Осталось: ${getElapsedTime(obed)}',
                textAlign: TextAlign.start,
                style: context.styles.ubuntuBold18.copyWith(
                  color: obed
                    ? Colors.green
                    : Theme.of(context).primaryColorLight.withValues(alpha: 0.7)
                ),
              ) : const SizedBox(),
            !isSaturday
              ? Row(
                  children: [
                    SizedBox(
                      height: 38,
                      child: FittedBox(
                        child: Switch(
                          value: obed,
                          onChanged: (final bool value) => toggleObed()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Без обеда',
                      style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
