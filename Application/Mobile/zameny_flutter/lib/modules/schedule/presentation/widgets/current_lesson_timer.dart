
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
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
    final bool isShowZamena = scheduleSettings.isShowZamena;
    final bool obedSwitch = scheduleSettings.obed;

    final Paras? para = daySchedule.paras.where((final Paras para) => para.number == number).firstOrNull;
    
    if (para == null) {
      return null;
    }

    if (item is Teacher) {
      tiles = builder.buildTeacherTiles(
        teacherId: item.id,
        isSaturday: isSaturday,
        isShowZamena: isShowZamena,
        obed: obedSwitch,
        para: para,
      );
    }

    if (item is Group) {
      tiles = builder.buildGroupTiles(
        isSaturday: isSaturday,
        zamenaFull: daySchedule.zamenaFull,
        isShowZamena: isShowZamena,
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
    final DaySchedule? schedule = ref.watch(todayDayScheduleProvider).value;
    final SearchItem? item = ref.watch(searchItemProvider);

    final LessonTimings? timing = getLessonTiming(obed);
    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;
    Widget? child;

    //TODO REWORK FOR TEACHER
    if (
      schedule != null
      && timing != null
    ) {
      child = _buildLessonTile(
        number: timing.number,
        daySchedule: schedule,
        item: item!,
      );

      // List<Paras> paras = schedule.paras.where((final para) => para.number == timing?.number).toList();
      // if (paras.isNotEmpty) {
      //   child = Column(
      //     children: paras.map((final para) {
      //       if (
      //         para.lesson != null
      //         && para.lesson!.isNotEmpty
      //       ) {
      //         return CourseTileRework(
      //           placeReason: 'timer',
      //           searchType: item?.type ?? SearchType.group,
      //           lesson: para.lesson!.first,
      //           isSaturday: isSaturday,
      //           index: para.number!,
      //         );
      //       }

      //       if (
      //         para.zamena != null
      //         && para.zamena!.isNotEmpty
      //       ) {
      //         final Zamena zamena = para.zamena!.first;

      //         return CourseTileRework(
      //           placeReason: 'timer zamena',
      //           searchType: item?.type ?? SearchType.group,
      //           lesson: Lesson(
      //             id: zamena.id,
      //             number: zamena.lessonTimingsID,
      //             group: zamena.groupID,
      //             date: zamena.date,
      //             course: zamena.courseID,
      //             teacher: zamena.teacherID,
      //             cabinet: zamena.cabinetID
      //           ),
      //           isSaturday: isSaturday,
      //           index: para.number!,
      //         );
      //       }

      //       return const SizedBox();
      //     }).toList()
      //   );
      // }
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
                    // const SizedBox(height: 5),
                    child
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
