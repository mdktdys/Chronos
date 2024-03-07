import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/tools.dart';
import 'package:zameny_flutter/presentation/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_screen.dart';

enum SearchType { teacher, group, cabinet }

class CourseTile extends StatelessWidget {
  final Lesson lesson;
  final Lesson? swaped;
  final SearchType type;
  final Function refresh;
  final bool? removed;
  final bool saturdayTime;
  final bool obedTime;

  const CourseTile({
    super.key,
    required this.course,
    required this.lesson,
    required this.type,
    required this.refresh,
    this.removed,
    required this.swaped,
    required this.saturdayTime,
    required this.obedTime,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    bool isEmpty = course.name.toLowerCase() == "нет";
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isEmpty
              ? Colors.transparent
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          border: isEmpty
              ? DashedBorder.all(
                  dashLength: 10,
                  width: 1,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6))
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          highlightColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          radius: 100,
          onLongPress: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(0.1),
                context: myGlobals.scaffoldKey.currentContext!,
                useSafeArea: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.background),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                          myGlobals.scaffoldKey.currentContext!)
                                      .pop();
                                  myGlobals.scaffoldKey.currentContext!
                                      .read<ScheduleProvider>()
                                      .teacherSelected(
                                        lesson.teacher,
                                        myGlobals.scaffoldKey.currentContext!,
                                      );
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                        "Показать расписание для препода\n${getTeacherById(lesson.teacher).name}",
                                        style: const TextStyle(
                                            fontFamily: 'Ubuntu')))),
                            Divider(
                              color: Colors.white.withOpacity(0.15),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(
                                        myGlobals.scaffoldKey.currentContext!)
                                    .pop();
                                myGlobals.scaffoldKey.currentContext!
                                    .read<ScheduleProvider>()
                                    .groupSelected(
                                      lesson.group,
                                      myGlobals.scaffoldKey.currentContext!,
                                    );
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                      "Показать расписание для группы\n${getGroupById(lesson.group)!.name}",
                                      style: const TextStyle(
                                          fontFamily: 'Ubuntu'))),
                            ),
                            Divider(
                              color: Colors.white.withOpacity(0.15),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(
                                        myGlobals.scaffoldKey.currentContext!)
                                    .pop();
                                myGlobals.scaffoldKey.currentContext!
                                    .read<ScheduleProvider>()
                                    .cabinetSelected(
                                      lesson.cabinet,
                                      myGlobals.scaffoldKey.currentContext!,
                                    );
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Показать расписание для кабинета\n${getCabinetById(lesson.cabinet).name}",
                                    style:
                                        const TextStyle(fontFamily: 'Ubuntu'),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  LimitedBox(
                    maxHeight: 100,
                    child: Container(
                      width: 10,
                      decoration: BoxDecoration(
                          color: isEmpty
                              ? getCourseColor(course.color).withOpacity(0.6)
                              : getCourseColor(course.color),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isEmpty
                                ? getCourseColor(course.color).withOpacity(0.6)
                                : getCourseColor(course.color)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lesson.number.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      Text(
                          saturdayTime
                              ? getLessonTimings(lesson.number).saturdayStart
                              : obedTime ? getLessonTimings(lesson.number).obedStart : getLessonTimings(lesson.number).start,
                          style: TextStyle(
                              fontSize: 16,
                              color: obedTime ? (lesson.number > 3 ?  Colors.green : Theme.of(context).colorScheme.inverseSurface) :
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold)),
                      Text(
                          saturdayTime
                              ? getLessonTimings(lesson.number).saturdayEnd
                              : obedTime ? getLessonTimings(lesson.number).obedEnd : getLessonTimings(lesson.number).end,
                          style: TextStyle(
                              color: obedTime ? (lesson.number > 3 ?  Colors.green.withAlpha(200) : Theme.of(context).colorScheme.inverseSurface.withAlpha(200)) :
                                  Theme.of(context).colorScheme.inverseSurface.withAlpha(200),
                              fontFamily: 'Ubuntu')),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            (getCourseById(lesson.course) ??
                                    Course(
                                        id: -1, name: "err", color: "0,0,0,0"))
                                .name,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        Text(
                          type == SearchType.teacher
                              ? getGroupById(lesson.group)!.name
                              : type == SearchType.group
                                  ? getTeacherById(lesson.teacher).name
                                  : type == SearchType.cabinet
                                      ? ""
                                      : "",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontFamily: 'Ubuntu'),
                        ),
                        Row(
                          children: [
                            type != SearchType.cabinet && !isEmpty
                                ? SvgPicture.asset(
                                    "assets/icon/vuesax_linear_location.svg",
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    width: 18,
                                    height: 18,
                                  )
                                : const SizedBox(),
                            Text(
                              type == SearchType.teacher
                                  ? getCabinetById(lesson.cabinet).name
                                  : type == SearchType.group
                                      ? getCabinetById(lesson.cabinet).name
                                      : type == SearchType.cabinet
                                          ? getGroupById(lesson.group)!.name
                                          : "",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  fontFamily: 'Ubuntu'),
                            ),
                          ],
                        ),
                        swaped != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Замена с: ${getCourseById(swaped!.course)!.name}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withOpacity(0.3),
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: swaped != null
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            Text(
                              "Замена",
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: Colors.red,
                                  shadows: [
                                    Shadow(color: Colors.red, blurRadius: 4)
                                  ]),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              shadows: [
                                Shadow(color: Colors.red, blurRadius: 4)
                              ],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            )
          ]),
        ));
  }
}
