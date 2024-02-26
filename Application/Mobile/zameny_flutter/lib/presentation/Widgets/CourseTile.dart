import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Tools.dart';

enum CourseTileType { teacher, group, cabinet }

class CourseTile extends StatelessWidget {
  final Lesson lesson;
  final Lesson? swaped;
  final CourseTileType type;

  const CourseTile(
      {super.key,
      required this.course,
      required this.lesson,
      required this.type,
      required this.swaped});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          // boxShadow: [
          //   BoxShadow(
          //       color: Color.fromARGB(255, 43, 43, 58),
          //       blurStyle: BlurStyle.outer,
          //       blurRadius: 12)
          // ]
        ),
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
                        color: getCourseColor(course.color),
                        // boxShadow: [
                        //   BoxShadow(
                        //       color: getCourseColor(course.color),
                        //       blurRadius: 6,
                        //       blurStyle: BlurStyle.outer),
                        // ],
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
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: getCourseColor(course.color),
                          //       blurRadius: 6,
                          //       blurStyle: BlurStyle.outer),
                          // ],
                          color: getCourseColor(course.color)),
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
                        "${getLessonTimings(lesson.number).start!.hour}:${getLessonTimings(lesson.number).start!.minute < 9 ? "0${getLessonTimings(lesson.number).start!.minute}" : getLessonTimings(lesson.number).start!.minute}",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold)),
                    Text(
                        "${getLessonTimings(lesson.number).end!.hour}:${getLessonTimings(lesson.number).end!.minute < 9 ? "0${getLessonTimings(lesson.number).end!.minute}" : getLessonTimings(lesson.number).end!.minute}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface.withAlpha(200),
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
                                  Course(id: -1, name: "err", color: "0,0,0,0"))
                              .name,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.inverseSurface,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      Text(
                        type == CourseTileType.teacher
                            ? getGroupById(lesson.group)!.name
                            : type == CourseTileType.group
                                ? getTeacherById(lesson.teacher).name
                                : type == CourseTileType.cabinet
                                    ? ""
                                    : "",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface, fontFamily: 'Ubuntu'),
                      ),
                      Row(
                        children: [
                          type != CourseTileType.cabinet
                              ? SvgPicture.asset("assets/icon/vuesax_linear_location.svg",
                             
                                  color: Theme.of(context).colorScheme.inverseSurface,
                                  width: 18,
                                  height: 18,
                                )
                              : const SizedBox(),
                          Text(
                            type == CourseTileType.teacher
                                ? getCabinetById(lesson.cabinet).name
                                : type == CourseTileType.group
                                    ? getCabinetById(lesson.cabinet).name
                                    : type == CourseTileType.cabinet
                                        ? getGroupById(lesson.group)!.name
                                        : "",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inverseSurface,fontFamily: 'Ubuntu'),
                          ),
                        ],
                      ),
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
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            shadows: [Shadow(color: Colors.red, blurRadius: 4)],
                            size: 48,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          )
        ]));
  }
}
