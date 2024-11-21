import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Providers/time_table_provider.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/timetable_screen/current_timing_timer.dart';
import 'package:zameny_flutter/presentation/Widgets/timetable_screen/time_table_header.dart';

import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';

class TimeTableWrapper extends StatelessWidget {
  const TimeTableWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeTableProvider(),
      child: const TimeTableScreen(),
    );
  }
}

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    final TimeTableProvider provider = context.watch<TimeTableProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    //const SizedBox(height: 10),
                    const TimeTableHeader(),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    CurrentTimingTimer(obed: provider.obed),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 38,
                              child: FittedBox(
                                child: Switch(
                                    value: provider.saturday,
                                    onChanged: (value) =>
                                        provider.toggleSaturday(),),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Суббота',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                              ),
                            ),
                          ],
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchOutCurve: Easing.legacy,
                          switchInCurve: Easing.legacy,
                          child: provider.saturday
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Без обеда',
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    SizedBox(
                                      height: 38,
                                      child: FittedBox(
                                        child: Switch(
                                            value: provider.obed,
                                            onChanged: (value) =>
                                                provider.toggleObed(),),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
              
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                              children: List.generate(7, (index) {
                            final LessonTimings? timing = GetIt.I
                                .get<Data>()
                                .timings
                                .where(
                                  (element) => element.number == (index + 1),
                                )
                                .firstOrNull;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.1),
                              ),
                              child: timing == null
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Container(
                                          width: 45,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 2,),),
                                          child: Center(
                                            child: Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  // color: Colors.white,
                                                  fontSize: 20,),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 150),
                                          switchInCurve: Easing.legacy,
                                          child: Text(
                                              key: ValueKey(provider.saturday ? UniqueKey() :getTimeFromDateTime(
                                                  provider.obed
                                                      ? timing.obedStart
                                                      : timing.start,),),
                                              '${getTimeFromDateTime( provider.saturday ? timing.saturdayStart : provider.obed ? timing.obedStart : timing.start)}-${getTimeFromDateTime(provider.saturday ? timing.saturdayEnd :provider.obed ? timing.obedEnd : timing.end)}',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  color: provider.saturday ? null : provider.obed
                                                      ? getTimeFromDateTime(provider
                                                                      .obed
                                                                  ? timing.obedStart
                                                                  : timing.start,) !=
                                                              getTimeFromDateTime(
                                                                  !provider.obed
                                                                      ? timing
                                                                          .obedStart
                                                                      : timing
                                                                          .start,)
                                                          ? Colors.green
                                                          : null
                                                      : null,
                                                  fontSize: 20,),),
                                        ),
                                      ],
                                    ),
                            );
                          }),),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),),
    );
  }
}

class CurrentLessonTimer extends StatefulWidget {
  const CurrentLessonTimer({
    super.key,
  });

  @override
  State<CurrentLessonTimer> createState() => _CurrentLessonTimerState();
}

class _CurrentLessonTimerState extends State<CurrentLessonTimer> {
  late Timer ticker;
  bool obed = false;

  @override
  void initState() {
    super.initState();
    ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  String getElapsedTime(bool obed) {
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

  LessonTimings? getLessonTiming(bool obed) {
    final DateTime current = DateTime.now();
    final bool isSaturday = current.weekday == 6;
    if (isSaturday) {
      final LessonTimings? timing = GetIt.I
          .get<Data>()
          .timings
          .where((element) =>
              element.start.isBefore(current) &&
              element.saturdayEnd.isAfter(current),)
          .firstOrNull;
      return timing;
    } else {
      if (obed) {
        final LessonTimings? timing = GetIt.I
            .get<Data>()
            .timings
            .where((element) =>
                element.obedStart.isBefore(current) &&
                element.obedEnd.isAfter(current),)
            .firstOrNull;
        return timing;
      } else {
        final LessonTimings? timing = GetIt.I
            .get<Data>()
            .timings
            .where((element) =>
                element.start.isBefore(current) && element.end.isAfter(current),)
            .firstOrNull;
        return timing;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final LessonTimings? timing = getLessonTiming(obed);
    final DateTime current = DateTime.now();
    final ScheduleProvider provider = context.watch<ScheduleProvider>();
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: timing == null || current.weekday == 7
          ? const SizedBox()
          : Builder(builder: (context) {
              final bool needObedSwitch = timing.number > 3 && current.weekday != 6;
              final bool isSaturday = current.weekday == 6;
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Сейчас идет ${timing.number} пара',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Ubuntu',),),
                        const SizedBox(height: 5),
                        AnimatedSize(
                          alignment: Alignment.topCenter,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.ease,
                          child: BlocBuilder<ScheduleBloc, ScheduleState>(
                            builder: (context, state) {
                              if (state is ScheduleLoaded &&
                                  provider.currentWeek == provider.todayWeek) {
                                final Lesson? lesson = state.lessons
                                    .where((element) =>
                                        element.date.weekday ==
                                            current.weekday &&
                                        timing.number == element.number,)
                                    .firstOrNull;

                                Zamena? zamena = state.zamenas
                                    .where((element) =>
                                        element.date.weekday ==
                                            current.weekday &&
                                        timing.number ==
                                            element.lessonTimingsID,)
                                    .firstOrNull;
                                if (zamena != null) {
                                  if (provider.searchType ==
                                      SearchType.teacher) {
                                    zamena = zamena.teacherID ==
                                            provider.teacherIDSeek
                                        ? zamena
                                        : null;
                                  }
                                }
                                if (zamena == null) {
                                  if (lesson != null) {
                                    if (GetIt.I
                                        .get<Data>()
                                        .zamenasFull
                                        .where((element) =>
                                            element.group == lesson.group &&
                                            element.date.day == current.day &&
                                            element.date.month == current.month,)
                                        .isNotEmpty) {
                                      return const SizedBox();
                                    }
                                    return CourseTile(
                                        short: true,
                                        course: getCourseById(lesson.course)!,
                                        lesson: lesson,
                                        type: provider.searchType,
                                        refresh: () {},
                                        swaped: null,
                                        saturdayTime: isSaturday,
                                        obedTime: obed,);
                                  }
                                }
                                if (zamena != null) {
                                  return CourseTile(
                                      short: true,
                                      course: getCourseById(zamena.courseID) ??
                                          Course(
                                              id: -1,
                                              name: 'name',
                                              color: '255,255,255,255',),
                                      lesson: Lesson(
                                          id: -1,
                                          number: zamena.lessonTimingsID,
                                          group: zamena.groupID,
                                          date: zamena.date,
                                          course: zamena.courseID,
                                          teacher: zamena.teacherID,
                                          cabinet: zamena.cabinetID,),
                                      type: provider.searchType,
                                      refresh: () {},
                                      swaped: lesson,
                                      saturdayTime: isSaturday,
                                      obedTime: obed,);
                                }
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Осталось: ${getElapsedTime(obed)}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: obed
                                          ? Colors.green
                                          : Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.7),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Ubuntu',),),
                              needObedSwitch && !isSaturday
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          height: 38,
                                          child: FittedBox(
                                            child: Switch(
                                                value: obed,
                                                onChanged: (value) =>
                                                    toggleObed(),),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Без обеда',
                                          style: TextStyle(
                                              fontFamily: 'Ubuntu',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface
                                                  .withOpacity(0.6),),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],),
                      ],),
                ),
              );
            },),
    );
  }
}
