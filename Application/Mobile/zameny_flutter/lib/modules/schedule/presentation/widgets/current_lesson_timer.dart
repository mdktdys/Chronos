
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
import 'package:zameny_flutter/new/providers/search_item_provider.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/new/providers/today_day_schedule_provider.dart';


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

  bool get inTimingsBounds {
    final DateTime now = DateTime.now();
    final List<LessonTimings>? timings = ref.watch(timingsProvider).value;

    if (timings == null) {
      return false;
    }

    final LessonTimings first = timings.where((final LessonTimings timings) => timings.number == 1).first;
    final LessonTimings last = timings.where((final LessonTimings timings) => timings.number == 7).first;

    if (
      first.start.isAfter(now)
      && last.end.isBefore(now)
    ) {
      return false;
    }

    return true;
  }

  LessonTimings? getLessonTiming(final bool obed) {
    final provider = ref.watch(timingsProvider);
    
    if (!provider.hasValue) {
      return null;
    }

    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;

    if (provider.value == null) {
      return null;
    }

    final List<LessonTimings> timings = provider.value!;

    if (isSaturday) {
      final LessonTimings? timing = timings.where((final element) => element.saturdayStart.isBefore(current) && element.saturdayEnd.isAfter(current)).firstOrNull;
      return timing;
    } else {
      if (obed) {
        final LessonTimings? timing = timings.where((final element) => element.obedStart.isBefore(current) && element.obedEnd.isAfter(current)).firstOrNull;
        return timing;
      } else {
        final LessonTimings? timing = timings.where((final element) => element.start.isBefore(current) && element.end.isAfter(current)).firstOrNull;
        return timing;
      }
    }
  }

  Widget? _buildLessonTile({
    required final SearchItem item,
    required final DaySchedule daySchedule,
    required final int number,
  }) {
    final ScheduleSettingsNotifier scheduleSettings = ref.watch(scheduleSettingsProvider);
    final ScheduleTilesBuilder builder = ref.watch(scheduleTilesBuilderProvider);
    List<Widget> tiles = [];

    final bool isSaturday = daySchedule.date.weekday == 6;
    final bool obedSwitch = scheduleSettings.obed;

    final Paras? para = daySchedule.paras.where((final Paras para) => para.number == number).firstOrNull;
    
    if (para == null) {
      return null;
    }

    if (item is Teacher) {
      tiles = builder.buildTeacherTiles(
        teacherId: item.id,
        isSaturday: isSaturday,
        viewMode: scheduleSettings.sheduleViewMode,
        obed: obedSwitch,
        para: para,
      );
    }

    if (item is Group) {
      tiles = builder.buildGroupTiles(
        isSaturday: isSaturday,
        zamenaFull: daySchedule.zamenaFull,
        viewMode: scheduleSettings.sheduleViewMode,
        obed: obedSwitch,
        para: para,
      );
    }
  
    return Column(
      children: tiles.map((final Widget tile) {
        Widget wrappedTile = tile;

        if (tile is CourseTileRework) {
          wrappedTile = Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              child: tile,
            ),
          );
        }

        return wrappedTile;
      }).toList()
    );
  }

  @override
  Widget build(final BuildContext context) {
    final SearchItem? item = ref.watch(searchItemProvider);
    final DaySchedule? schedule = ref.watch(todayDayScheduleProvider).value;

    final LessonTimings? timing = getLessonTiming(obed);
    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;
    final bool inBounds = inTimingsBounds;
    Widget? child;

    if (
      schedule != null
      && timing != null
      && item != null
    ) {
      child = _buildLessonTile(
        number: timing.number,
        daySchedule: schedule,
        item: item,
      );
    }

    return Column(
      children: [
        AnimatedSize(
          duration: Delays.fastMorphDuration,
          curve: Curves.ease,
          alignment: Alignment.topCenter,
          child:  timing == null || current.weekday == 7 || (schedule?.holidays.isNotEmpty ?? false)
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Сейчас идет ${timing.number} пара',
                    textAlign: TextAlign.start,
                    style: context.styles.ubuntuPrimaryBold24,
                  ),
                  if (child != null)
                    child
                ],
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            timing != null && current.weekday != 7 && (schedule?.holidays.isEmpty ?? false) ?
              Text(
                'Осталось: ${getElapsedTime(obed)}',
                textAlign: TextAlign.start,
                style: context.styles.ubuntuBold18.copyWith(
                  color: obed
                    ? Colors.green
                    : Theme.of(context).primaryColorLight.withValues(alpha: 0.7)
                ),
              ) : const SizedBox(),
            !isSaturday && inBounds && (schedule?.holidays.isEmpty ?? false)
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
