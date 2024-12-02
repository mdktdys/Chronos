import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Providers/adaptive.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/dayschedule_header.dart';

class DayScheduleWidgetTeacher extends StatefulWidget {
  final DateTime startDate;
  final int currentDay;
  final int currentWeek;
  final int todayWeek;
  final Data data;
  final Function refresh;
  final int day;
  final List<Zamena> dayZamenas;
  final List<Lesson> lessons;

  const DayScheduleWidgetTeacher({
    required this.startDate,
    required this.currentDay,
    required this.currentWeek,
    required this.todayWeek,
    required this.data,
    required this.refresh,
    required this.day,
    required this.dayZamenas,
    required this.lessons,
    super.key,
  });

  @override
  State<DayScheduleWidgetTeacher> createState() =>
      _DayScheduleWidgetTeacherState();
}

class _DayScheduleWidgetTeacherState extends State<DayScheduleWidgetTeacher> {
  bool obed = false;

  void toggleObed() {
    obed = !obed;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final timestamp) {
      if (widget.day == widget.currentDay &&
          widget.currentWeek == widget.todayWeek &&
          !Adaptive.isDesktop(context)) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 500), alignment: 0.5,);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final bool isToday = (widget.day == widget.currentDay &&
            widget.todayWeek == widget.currentWeek
        ? true
        : false);

    final ScheduleProvider provider = context.watch<ScheduleProvider>();

    final int todayYear = widget.startDate.add(Duration(days: widget.day - 1)).year;
    final int todayMonth = widget.startDate.add(Duration(days: widget.day - 1)).month;
    final int todayDay = widget.startDate.add(Duration(days: widget.day - 1)).day;

    final Set<ZamenaFull> fullzamenas = GetIt.I
        .get<Data>()
        .zamenasFull
        .where((final element) =>
            element.date.day == todayDay &&
            element.date.month == todayMonth &&
            element.date.year == todayYear,)
        .toSet();
    final int teacherID = provider.teacherIDSeek;
    final List<Widget> tiles =
        newMethod(teacherID, fullzamenas, todayDay, todayMonth, todayYear);

    final List<Widget> courseTiles = [];
    for (final Widget i in tiles) {
      if (i is CourseTile || i is MixedCourseTile) {
        courseTiles.add(i);
      }
    }
    // bool needObedSwitch = courseTiles.any((element) =>
    //     element.lesson.number == 4 ||
    //     element.lesson.number == 5 ||
    //     element.lesson.number == 6 ||
    //     element.lesson.number == 7);

    const bool needObedSwitch = true;

    GetIt.I.get<Talker>().info('ДЕНЬ ${widget.day}');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isToday
          ? BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,),
              borderRadius: const BorderRadius.all(Radius.circular(20)),)
          : null,
      child: Column(
        children: [
          DayScheduleHeader(
              day: widget.day, startDate: widget.startDate, isToday: isToday,),
          //isToday
          courseTiles.isNotEmpty && needObedSwitch && (widget.day != 6)
              ? Row(
                  children: [
                    SizedBox(
                      height: 38,
                      child: FittedBox(
                        child: Switch(
                            value: obed, onChanged: (final value) => toggleObed(),),
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
              : Adaptive.isDesktop(context)
                  ? const SizedBox(
                      height: 38,
                    )
                  : const SizedBox(),
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
                              .withOpacity(0.6),),),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        'Нет пар',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 20,
                            color:
                                Theme.of(context).colorScheme.inversePrimary,),
                      ),),),
                ),
        ],
      ),
    );
  }

  List<Widget> newMethod(final int teacherID, final Set<ZamenaFull> fullzamenas,
      final int todayDay, final int todayMonth, final int todayYear,) {
    final Data data = GetIt.I.get<Data>();

    final Holiday? holiday = data.holidays
        .where((final element) =>
            element.date == DateTime(todayYear, todayMonth, todayDay),)
        .firstOrNull;
    if (holiday != null) {
      return [
        Container(
          height: 110,
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.transparent,
              border: DashedBorder.all(
                  dashLength: 10,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.6),),),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                holiday.name,
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,),
              ),),),
        ),
      ];
    }
    return widget.data.timings.map((final para) {
      //проверяю есть ли замена затрагивающих этого препода либо группы в которых он ведет по дефолту
      if (widget.dayZamenas
          .any((final element) => element.lessonTimingsID == para.number)) {
        //если есть любая замена в этот день, неважно дети или препод
        final Zamena zamena = widget.dayZamenas
            .where((final element) => element.lessonTimingsID == para.number)
            .first;
        //если это замена детей и она не  меняет на моего препода
        if (zamena.teacherID != teacherID) {
          //пытаюсь поставить дефолтную пару препода
          //проверяю не состоит ли эта пара в полной замене
          if (widget.lessons.any((final element) => element.number == para.number)) {
            final Lesson lesson = widget.lessons
                .where((final element) => element.number == para.number)
                .first;

            final course = getCourseById(lesson.course) ??
                Course(id: -1, name: 'err3', color: '50,0,0,1');

            //проверяю не состоит ли группа дефолтного расписания в полной замене

            final bool hasFullZamena = fullzamenas
                .where((final element) =>
                    element.group == lesson.group &&
                    element.date.day == todayDay &&
                    element.date.month == todayMonth &&
                    element.date.year == todayYear,)
                .isNotEmpty;

            final bool hasOtherZamena = widget.dayZamenas
                .where((final element) =>
                    element.groupID == lesson.group &&
                    element.lessonTimingsID == para.number,)
                .isNotEmpty;

            final bool hasLiquidation = data.liquidations.any((final element) =>
                element.date == DateTime(todayYear, todayMonth, todayDay) &&
                element.group == lesson.group,);

            if (!hasFullZamena && !hasOtherZamena && !hasLiquidation) {
              return CourseTile(
                short: false,
                type: SearchType.teacher,
                course: course,
                obedTime: obed,
                lesson: lesson,
                swaped: null,
                refresh: widget.refresh,
                saturdayTime: widget.day == 6,
              );
            }
          }
        }
        //если это замена препода, ставлю ее
        else {
          //пара которая меняется
          final Lesson? swapedPara = widget.lessons
              .where((final element) => element.number == para.number)
              .firstOrNull;
          //замена этой пары

          final Zamena zamena = widget.dayZamenas
              .where((final element) =>
                  element.lessonTimingsID == para.number &&
                  element.teacherID == teacherID,)
              .first;
          final course = getCourseById(zamena.courseID) ??
              Course(id: -1, name: 'err2', color: '100,0,0,0');
          return CourseTile(
            short: false,
            type: SearchType.teacher,
            course: course,
            obedTime: obed,
            refresh: widget.refresh,
            saturdayTime: widget.day == 6,
            needZamenaAlert: true,
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
        }
      }

      //если замен нет, пытаюсь составить дефолтное расписание
      else {
        // GetIt.I.get<Talker>().critical(para.number);
        // lessons.forEach((element) {
        //   GetIt.I.get<Talker>().good(getGroupById(element.group)!.name);
        //   GetIt.I.get<Talker>().good(element.number);
        //   GetIt.I.get<Talker>().good(para.number);
        // });
        if (widget.lessons.any((final element) => element.number == para.number)) {
          final List<Lesson> lessons = widget.lessons
              .where((final element) => element.number == para.number)
              .toList();

          final List<TileData> tiles = [];

          for (final lesson in lessons) {
            final course = getCourseById(lesson.course) ??
                Course(id: -1, name: 'err3', color: '50,0,0,1');

            final group = getGroupById(lesson.group);
            final cabinet = getCabinetById(lesson.cabinet);
            final color = getCourseColor(course.color);

            final bool hasLiquidation = data.liquidations.any((final element) =>
                element.date == DateTime(todayYear, todayMonth, todayDay) &&
                element.group == lesson.group,);

            if (hasLiquidation) {
// CourseTile(
//                 short: false,
//                 type: SearchType.teacher,
//                 course: courseEmpty,
//                 obedTime: obed,
//                 lesson: sec,
//                 swaped: lessonEmpty,
//                 refresh: widget.refresh,
//                 saturdayTime: widget.day == 6,
//               )

              tiles.add(TileData(
                  liqidated: true,
                  title: course.copyWith(name: '${course.name} - Снято').name,
                  number: lesson.number,
                  subTitle: group?.name??'',
                  location: cabinet.name,
                  color: color,
                  zamenaAlert: false,),);
            }

//проверяю не состоит ли группа дефолтного расписания в полной замене
            if (fullzamenas
                .where((final element) =>
                    element.group == lesson.group &&
                    element.date.day == todayDay &&
                    element.date.month == todayMonth &&
                    element.date.year == todayYear,)
                .isEmpty) {
// CourseTile(
//                 short: false,
//                 type: SearchType.teacher,
//                 course: course,
//                 obedTime: obed,
//                 lesson: lesson,
//                 swaped: null,
//                 refresh: widget.refresh,
//                 saturdayTime: widget.day == 6,
//               )

              tiles.add(TileData(
                  title: course.name,
                  number: lesson.number,
                  subTitle: group?.name ?? '',
                  location: cabinet.name,
                  color: color,
                  zamenaAlert: false,),);
            }
          }
          return MixedCourseTile(
            tilesData: tiles,
            saturdayTime: widget.day == 6,
            obedTime: obed,
          );
        }
      }

      return const SizedBox();
      //return Text("data ${lessons.where((element) => element.number == para.number).length}");
    }).toList();
  }
}
