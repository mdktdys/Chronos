import 'package:flutter/material.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Tools.dart';

class CourseTile extends StatelessWidget {
  final Lesson lesson;
  final bool swaped;

  const CourseTile(
      {super.key,
      required this.course,
      required this.lesson,
      required this.swaped});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 41, 44, 58),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 43, 43, 58),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 12)
            ]),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  decoration: BoxDecoration(
                      color: getCourseColor(course.color),
                      boxShadow: [
                        BoxShadow(
                            color: getCourseColor(course.color),
                            blurRadius: 6,
                            blurStyle: BlurStyle.outer),
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: 100,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: getCourseColor(course.color),
                                blurRadius: 6,
                                blurStyle: BlurStyle.outer),
                          ],
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
                        "${getLessonTimings(lesson.number).start!.hour}:${getLessonTimings(lesson.number).start!.minute}",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold)),
                    Text(
                        "${getLessonTimings(lesson.number).end!.hour}:${getLessonTimings(lesson.number).end!.minute}",
                        style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontFamily: 'Ubuntu')),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getCourseById(lesson.course).name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    Text(
                      getTeacherById(lesson.teacher).name,
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Ubuntu'),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          getCabinetById(lesson.cabinet).name,
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Ubuntu'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: swaped
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          Text(
                            "Swaped",
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
