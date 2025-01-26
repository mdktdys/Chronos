
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/services/Data.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

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
    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;
    if (isSaturday) {
      final LessonTimings? timing = GetIt.I
          .get<Data>()
          .timings
          .where((final element) =>
              element.start.isBefore(current) &&
              element.saturdayEnd.isAfter(current),)
          .firstOrNull;
      return timing;
    } else {
      if (obed) {
        final LessonTimings? timing = GetIt.I
            .get<Data>()
            .timings
            .where((final element) =>
                element.obedStart.isBefore(current) &&
                element.obedEnd.isAfter(current),)
            .firstOrNull;
        return timing;
      } else {
        final LessonTimings? timing = GetIt.I
            .get<Data>()
            .timings
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
    final ScheduleProvider provider = ref.watch(scheduleProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: timing == null || current.weekday == 7
          ? const SizedBox()
          : Builder(builder: (final context) {
              final bool needObedSwitch = timing.number > 3 && current.weekday != 6;
              final bool isSaturday = current.weekday == 6;
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Сейчас идет ${timing.number} пара',
                          textAlign: TextAlign.start,
                          style: context.styles.ubuntuPrimaryBold24,
                        ),
                        const SizedBox(height: 5),
                        // AnimatedSize(
                        //   alignment: Alignment.topCenter,
                        //   duration: const Duration(milliseconds: 150),
                        //   curve: Curves.ease,
                        //   child: Consumer(
                        //     builder: (final context, final ref, final child) {
                        //       final scheduleState = ref.watch(riverpodScheduleProvider);

                        //       if (scheduleState.isLoading) {
                        //         return const CircularProgressIndicator();
                        //       }
                              
                        //       if (provider.currentWeek == provider.todayWeek) {
                        //         final Lesson? lesson = scheduleState.lessons.where((final element) =>
                        //                 element.date.weekday == current.weekday &&
                        //                 timing.number == element.number)
                        //             .firstOrNull;

                        //         Zamena? zamena = scheduleState.zamenas
                        //             .where((final element) =>
                        //                 element.date.weekday == current.weekday &&
                        //                 timing.number == element.lessonTimingsID)
                        //             .firstOrNull;

                        //         if (zamena != null) {
                        //           if (provider.searchType == SearchType.teacher) {
                        //             zamena = zamena.teacherID == provider.teacherIDSeek ? zamena : null;
                        //           }
                        //         }

                        //         if (zamena == null) {
                        //           if (lesson != null) {
                        //             if (GetIt.I
                        //                 .get<Data>()
                        //                 .zamenasFull
                        //                 .where((final element) =>
                        //                     element.group == lesson.group &&
                        //                     element.date.day == current.day &&
                        //                     element.date.month == current.month)
                        //                 .isNotEmpty) {
                        //               return const SizedBox();
                        //             }
                        //             return CourseTile(
                        //               short: true,
                        //               course: getCourseById(lesson.course)!,
                        //               lesson: lesson,
                        //               type: provider.searchType,
                        //               swaped: null,
                        //               saturdayTime: isSaturday,
                        //               obedTime: obed,
                        //             );
                        //           }
                        //         }

                        //         if (zamena != null) {
                        //           return CourseTile(
                        //             short: true,
                        //             course: getCourseById(zamena.courseID) ??
                        //                 Course(
                        //                   id: -1,
                        //                   name: 'name',
                        //                   color: '255,255,255,255',
                        //                 ),
                        //             lesson: Lesson(
                        //               id: -1,
                        //               number: zamena.lessonTimingsID,
                        //               group: zamena.groupID,
                        //               date: zamena.date,
                        //               course: zamena.courseID,
                        //               teacher: zamena.teacherID,
                        //               cabinet: zamena.cabinetID,
                        //             ),
                        //             type: provider.searchType,
                        //             swaped: lesson,
                        //             saturdayTime: isSaturday,
                        //             obedTime: obed,
                        //           );
                        //         }
                        //       }
                        //       return const SizedBox();
                        //     },
                        //   ),
                        // ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Осталось: ${getElapsedTime(obed)}',
                                textAlign: TextAlign.start,
                                style: context.styles.ubuntuBold18.copyWith(
                                  color: obed
                                    ? Colors.green
                                    : Theme.of(context).primaryColorLight.withValues(alpha: 0.7)
                                ),
                              ),
                              needObedSwitch && !isSaturday
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
                    ),
                ),
              );
            },
          ),
    );
  }
}
