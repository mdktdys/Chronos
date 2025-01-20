import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/services/Data.dart';
import 'package:zameny_flutter/shared/providers/adaptive.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/tools.dart';

class DayScheduleWidget extends ConsumerStatefulWidget {
  final DateTime startDate;
  final int currentDay;
  final int currentWeek;
  final int todayWeek;
  final Data data;
  final int day;
  final List<Zamena> dayZamenas;
  final List<Lesson> lessons;

  const DayScheduleWidget({
    required this.day,
    required this.dayZamenas,
    required this.lessons,
    required this.startDate,
    required this.currentDay,
    required this.currentWeek,
    required this.todayWeek,
    required this.data,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayScheduleWidgetState();
}

class _DayScheduleWidgetState extends ConsumerState<DayScheduleWidget> {
bool obed = false;

  void toggleObed() {
    obed = !obed;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final timestamp) {
      if (
        widget.day == widget.currentDay
        && widget.currentWeek == widget.todayWeek
        && !Adaptive.isDesktop(context)
      ) {
        Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), alignment: 0.5,);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final bool isToday = (
      widget.day == widget.currentDay
      && widget.todayWeek == widget.currentWeek
        ? true
        : false);
    final SearchType type = ref.watch(scheduleProvider).searchType;
    bool fullSwap = false;
    final int searchDay = widget.startDate.add(Duration(days: widget.day - 1)).day;
    final int searchMonth =
        widget.startDate.add(Duration(days: widget.day - 1)).month;
    final int searchYear = widget.startDate.add(Duration(days: widget.day - 1)).year;
    if (widget.lessons.isNotEmpty) {
      if (type == SearchType.group) {
        fullSwap = GetIt.I
            .get<Data>()
            .zamenasFull
            .where((final element) =>
                (element.group == widget.lessons[0].group) &&
                (element.date.day == searchDay) &&
                (element.date.month == searchMonth) &&
                (element.date.year == searchYear),)
            .toSet()
            .isNotEmpty;
      }
    }
    final List<Widget> tiles = newMethod(fullSwap, type, searchYear, searchMonth,
        searchDay, GetIt.I.get<Data>().seekGroup!,);
    final List<CourseTile> courseTiles = [];
    for (final Widget i in tiles) {
      if (i is CourseTile) {
        courseTiles.add(i);
      }
    }
    final bool needObedSwitch = courseTiles.any((final element) =>
        element.lesson.number == 4 ||
        element.lesson.number == 5 ||
        element.lesson.number == 6 ||
        element.lesson.number == 7,);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isToday
          ? BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,),
              borderRadius: const BorderRadius.all(Radius.circular(20)),)
          : null,
      child: Column(
        children: [
          Column(
            children: [
              DayScheduleHeader(
                  day: widget.day,
                  startDate: widget.startDate,
                  isToday: isToday,
                  fullSwap: fullSwap,),
              //isToday
              courseTiles.isNotEmpty && needObedSwitch && (widget.day != 6)
                  ? Row(
                      children: [
                        SizedBox(
                          height: 38,
                          child: FittedBox(
                            child: Switch(
                                value: obed,
                                onChanged: (final value) => toggleObed(),),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Без обеда',
                          style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
                        ),
                      ],
                    )
                  : Adaptive.isDesktop(context) ? const SizedBox(height: 38,) : const SizedBox(),
            ],
          ),
          courseTiles.isNotEmpty
            ? Column(children: courseTiles)
            : Container(
                height: 110,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.transparent,
                    border: DashedBorder.all(
                        dashLength: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.6),),),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Нет пар',
                        style: context.styles.ubuntuInversePrimary20,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  List<Widget> newMethod(
    final bool fullSwap,
    final SearchType type,
    final int todayYear,
    final int todayMonth,
    final int todayDay,
    final int group
  ) {
    final Data data = GetIt.I.get<Data>();

    final Holiday? holiday = data.holidays.where((final element) => element.date == DateTime(todayYear, todayMonth, todayDay)).firstOrNull;
    if (holiday != null) {
      return [
        Container(
          height: 110,
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 10
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
            border: DashedBorder.all(
              dashLength: 10,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  holiday.name,
                  style: context.styles.ubuntuInversePrimary20,
                ),
              ),
            ),
          ),
      ];
    }
    final Liquidation? liquidation = data.liquidations.where((final element) => DateTime(todayYear, todayMonth, todayDay) == element.date && element.group == group).firstOrNull;

    if (liquidation != null) {
      return [
        Container(
          height: 110,
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
            border: DashedBorder.all(
              dashLength: 10,
              color:Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Ликвидация задолженностей',
                  style: context.styles.ubuntuInversePrimary20,
                ),
              ),
          ),
        ),
      ];
    }
    return widget.data.timings.map((final para) {
      if (fullSwap) {
        // Lesson? removedPara = lessons
        //     .where((element) => element.number == para.number)
        //     .firstOrNull;
        // if (removedPara != null) {
        //   return const SizedBox();
        // }
        final Zamena? zamena = widget.dayZamenas.where((final element) => element.lessonTimingsID == para.number).firstOrNull;
        if (zamena != null) {
          final course = getCourseById(zamena.courseID) ?? Course(id: -1, name: 'err2', color: '100,0,0,0');
          return CourseTile(
            short: false,
            type: type,
            obedTime: obed,
            course: course,
            swaped: null,
            saturdayTime: widget.day == 6,
            lesson: Lesson(
                id: -1,
                course: course.id,
                cabinet: zamena.cabinetID,
                number: zamena.lessonTimingsID,
                teacher: zamena.teacherID,
                group: zamena.groupID,
                date: zamena.date,),
          );
        }
        return const SizedBox.shrink();
      } else {
        if (widget.dayZamenas.any((final element) => element.lessonTimingsID == para.number)) {
          final Lesson? swapedPara = widget.lessons.where((final element) => element.number == para.number).firstOrNull;
          final Zamena zamena = widget.dayZamenas.where((final element) => element.lessonTimingsID == para.number).first;
          final course = getCourseById(zamena.courseID) ?? Course(id: -1, name: 'err2', color: '100,0,0,0');

          return CourseTile(
            needZamenaAlert: true,
            short: false,
            type: type,
            obedTime: obed,
            course: course,
            saturdayTime: widget.day == 6,
            lesson: Lesson(
              id: -1,
              course: course.id,
              cabinet: zamena.cabinetID,
              number: zamena.lessonTimingsID,
              teacher: zamena.teacherID,
              group: zamena.groupID,
              date: zamena.date,),
            swaped: swapedPara,
          );
        } else {
          if (widget.lessons.any((final element) => element.number == para.number)) {
            final Lesson lesson = widget.lessons
                .where((final element) => element.number == para.number)
                .first;
            final course = getCourseById(lesson.course) ??
                Course(id: -1, name: 'err3', color: '50,0,0,1');
                //дефолтное
            return CourseTile(
              short: false,
              saturdayTime: widget.day == 6,
              type: type,
              obedTime: obed,
              course: course,
              lesson: lesson,
              swaped: null,
            );
          }
        }
      }
      return const SizedBox();
    }).toList();
  }
}
