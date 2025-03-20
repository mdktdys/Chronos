
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/day_schedule.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/timer_provider.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';


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

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
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
    final DaySchedule? schedule = ref.watch(todayDayScheduleProvider).value;
    final SearchItem? item = ref.watch(searchItemProvider);

    final LessonTimings? timing = getLessonTiming(obed);
    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;
    Widget? child;

    if (schedule != null) {
      List<Paras> paras = schedule.paras.where((final para) => para.number == timing?.number).toList();
      if (paras.isNotEmpty) {
        child = Column(
          children: paras.map((final para) {
            if (
              para.lesson != null
              && para.lesson!.isNotEmpty
            ) {
              return CourseTileRework(
                searchType: item?.type ?? SearchType.group,
                lesson: para.lesson!.first,
                isSaturday: isSaturday,
                index: para.number!,
              );
            }

            if (para.zamena != null) {
              
            }
            return const SizedBox();
          }).toList()
        );
      }
    }

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.ease,
          alignment: Alignment.topCenter,
          child: timing == null || current.weekday == 7
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Сейчас идет ${timing.number} пара',
                    textAlign: TextAlign.start,
                    style: context.styles.ubuntuPrimaryBold24,
                  ),
                  if (child != null) ... [
                    const SizedBox(height: 5),
                    CourseTileReworkedBlank(child: child)
                  ]
                ],
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
