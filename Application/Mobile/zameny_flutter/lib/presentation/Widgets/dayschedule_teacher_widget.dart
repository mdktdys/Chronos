import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';
import 'package:zameny_flutter/presentation/Widgets/dayschedule_header.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import '../../Services/tools.dart';
import '../Providers/schedule_provider.dart';

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
  const DayScheduleWidgetTeacher(
      {super.key,
      required this.startDate,
      required this.currentDay,
      required this.currentWeek,
      required this.todayWeek,
      required this.data,
      required this.refresh,
      required this.day,
      required this.dayZamenas,
      required this.lessons});

  @override
  State<DayScheduleWidgetTeacher> createState() =>
      _DayScheduleWidgetTeacherState();
}

class _DayScheduleWidgetTeacherState extends State<DayScheduleWidgetTeacher> {
  bool obed = false;

  toggleObed() {
    obed = !obed;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = (widget.day == widget.currentDay &&
            widget.todayWeek == widget.currentWeek
        ? true
        : false);

    ScheduleProvider provider = context.watch<ScheduleProvider>();

    int todayYear = widget.startDate.add(Duration(days: widget.day - 1)).year;
    int todayMonth = widget.startDate.add(Duration(days: widget.day - 1)).month;
    int todayDay = widget.startDate.add(Duration(days: widget.day - 1)).day;

    Set<ZamenaFull> fullzamenas = GetIt.I
        .get<Data>()
        .zamenasFull
        .where((element) =>
            element.date.day == todayDay &&
            element.date.month == todayMonth &&
            element.date.year == todayYear)
        .toSet();
    int teacherID = provider.teacherIDSeek;
    List<Widget> tiles =
        newMethod(teacherID, fullzamenas, todayDay, todayMonth, todayYear);
    List<CourseTile> courseTiles = [];
    for (Widget i in tiles) {
      if (i is CourseTile) {
        courseTiles.add(i);
      }
    }
    bool needObedSwitch = courseTiles.any((element) =>
        element.lesson.number == 4 ||
        element.lesson.number == 5 ||
        element.lesson.number == 6 ||
        element.lesson.number == 7);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isToday
          ? BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(20)))
          : null,
      child: Column(
        children: [
          DayScheduleHeader(
              day: widget.day, startDate: widget.startDate, isToday: isToday),
          //isToday
          courseTiles.isNotEmpty && needObedSwitch && (widget.day != 6)
              ? Row(
                  children: [
                    SizedBox(
                      height: 38,
                      child: FittedBox(
                        child: Switch(
                            value: obed, onChanged: (value) => toggleObed()),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Без обеда",
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          color: Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withOpacity(0.6)),
                    )
                  ],
                )
              : const SizedBox(),
          Column(children: tiles)
        ],
      ),
    );
  }

  List<Widget> newMethod(int teacherID, Set<ZamenaFull> fullzamenas,
      int todayDay, int todayMonth, int todayYear) {
    Data data = GetIt.I.get<Data>();

    Holiday? holiday = data.holidays
        .where((element) =>
            element.date == DateTime(todayYear, todayMonth, todayDay))
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
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.6))),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                holiday.name,
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ))),
        )
      ];
    }
    return widget.data.timings.map((para) {
      //проверяю есть ли замена затрагивающих этого препода либо группы в которых он ведет по дефолту
      if (widget.dayZamenas
          .any((element) => element.lessonTimingsID == para.number)) {
        //если есть любая замена в этот день, неважно дети или препод
        Zamena? zamena = widget.dayZamenas
            .where((element) => element.lessonTimingsID == para.number)
            .first;

        //если это замена детей и она не меняет на моего препода
        if (zamena.teacherID != teacherID) {
          //пытаюсь поставить дефолтную пару препода
          //проверяю не состоит ли эта пара в полной замене
          if (widget.lessons.any((element) => element.number == para.number)) {
            Lesson lesson = widget.lessons
                .where((element) => element.number == para.number)
                .first;
            final course = getCourseById(lesson.course) ??
                Course(id: -1, name: "err3", color: "50,0,0,1");

            //проверяю не состоит ли группа дефолтного расписания в полной замене

            bool hasFullZamena = fullzamenas
                .where((element) =>
                    element.group == lesson.group &&
                    element.date.day == todayDay &&
                    element.date.month == todayMonth &&
                    element.date.year == todayYear)
                .isNotEmpty;

            bool hasOtherZamena = widget.dayZamenas
                .where((element) =>
                    element.groupID == lesson.group &&
                    element.lessonTimingsID == para.number)
                .isNotEmpty;

            bool hasLiquidation = data.liquidations.any((element) =>
                element.date == DateTime(todayYear, todayMonth, todayDay) &&
                element.group == lesson.group);

            if (!hasFullZamena && !hasOtherZamena && !hasLiquidation) {
              return CourseTile(
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
          Lesson? swapedPara = widget.lessons
              .where((element) => element.number == para.number)
              .firstOrNull;
          //замена этой пары

          Zamena zamena = widget.dayZamenas
              .where((element) =>
                  element.lessonTimingsID == para.number &&
                  element.teacherID == teacherID)
              .first;
          final course = getCourseById(zamena.courseID) ??
              Course(id: -1, name: "err2", color: "100,0,0,0");
          return CourseTile(
            type: SearchType.teacher,
            course: course,
            obedTime: obed,
            refresh: widget.refresh,
            saturdayTime: widget.day == 6,
            lesson: Lesson(
                id: -1,
                course: course.id,
                cabinet: zamena.cabinetID,
                number: zamena.lessonTimingsID,
                teacher: zamena.teacherID,
                group: zamena.groupID,
                date: zamena.date),
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
        if (widget.lessons.any((element) => element.number == para.number)) {
          Lesson lesson = widget.lessons
              .where((element) => element.number == para.number)
              .first;

          final course = getCourseById(lesson.course) ??
              Course(id: -1, name: "err3", color: "50,0,0,1");

          //проверяю не состоит ли группа дефолтного расписания в полной замене
          if (fullzamenas
              .where((element) =>
                  element.group == lesson.group &&
                  element.date.day == todayDay &&
                  element.date.month == todayMonth &&
                  element.date.year == todayYear)
              .isEmpty) {
            return CourseTile(
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

      return const SizedBox();
      //return Text("data ${lessons.where((element) => element.number == para.number).length}");
    }).toList();
  }
}
