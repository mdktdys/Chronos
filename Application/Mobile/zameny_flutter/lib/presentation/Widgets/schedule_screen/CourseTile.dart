import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen.dart';
import 'package:zameny_flutter/domain/Models/models.dart';

enum SearchType { teacher, group, cabinet }

class TileData {
  final String title;
  final String subTitle;
  final String location;
  final int number;
  final bool zamenaAlert;
  final Color color;
  final String? swapedFromTitle;
  final bool? liqidated;

  TileData(
      {required this.title,
      required this.number,
      required this.subTitle,
      required this.location,
      required this.color,
      this.swapedFromTitle,
      this.liqidated,
      required this.zamenaAlert});
}

class MixedCourseTile extends StatefulWidget {
  final List<TileData> tilesData;
  final bool saturdayTime;
  final bool obedTime;
  const MixedCourseTile(
      {super.key,
      required this.tilesData,
      required this.saturdayTime,
      required this.obedTime});

  @override
  State<MixedCourseTile> createState() => _MixedCourseTileState();
}

class _MixedCourseTileState extends State<MixedCourseTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 5)
                ]
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface,
          border: null,
        ),
        child: Column(
          children: [
            widget.tilesData.length > 1
                ? Builder(builder: (context) {
                    final data = widget.tilesData.first;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: data.color),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data.number.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  widget.saturdayTime
                                      ? getTimeFromDateTime(
                                          getLessonTimings(data.number)
                                              .saturdayStart)
                                      : widget.obedTime
                                          ? getTimeFromDateTime(
                                              getLessonTimings(data.number)
                                                  .obedStart)
                                          : getTimeFromDateTime(
                                              getLessonTimings(data.number)
                                                  .start),
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: widget.obedTime
                                          ? (data.number > 3
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface)
                                          : Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  widget.saturdayTime
                                      ? getTimeFromDateTime(
                                          getLessonTimings(data.number)
                                              .saturdayEnd)
                                      : widget.obedTime
                                          ? getTimeFromDateTime(
                                              getLessonTimings(data.number)
                                                  .obedEnd)
                                          : getTimeFromDateTime(
                                              getLessonTimings(data.number)
                                                  .end),
                                  style: TextStyle(
                                      color: widget.obedTime
                                          ? (data.number > 3
                                              ? Colors.green.withAlpha(200)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface
                                                  .withAlpha(200))
                                          : Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withAlpha(200),
                                      fontSize: 18,
                                      fontFamily: 'Ubuntu')),
                            ],
                          )
                        ],
                      ),
                    );
                  })
                : const SizedBox(),
            Column(
                children: List.generate(widget.tilesData.length, (index) {
              TileData data = widget.tilesData[index];
              bool isLast = widget.tilesData.length - 1 == index;
              return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  highlightColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  radius: 100,
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          8, index == 0 ? 8.0 : 0, 10, isLast ? 8.0 : 0),
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 100),
                            child: Container(
                              width: 10,
                              decoration: BoxDecoration(
                                  color: getColorForText(data.title).withOpacity(
                                      data.liqidated == true ? 0.3 : 1.0),
                                  borderRadius: BorderRadius.only(
                                    topLeft: index == 0
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    topRight: index == 0
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    bottomRight: isLast
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    bottomLeft: isLast
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          index == 0 && widget.tilesData.length == 1
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: getColorForText(data.title) ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data.number.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Text(
                                        widget.saturdayTime
                                            ? getTimeFromDateTime(
                                                getLessonTimings(data.number)
                                                    .saturdayStart)
                                            : widget.obedTime
                                                ? getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number)
                                                        .obedStart)
                                                : getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number)
                                                        .start),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: widget.obedTime
                                                ? (data.number > 3
                                                    ? Colors.green
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                            fontFamily: 'Ubuntu',
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        widget.saturdayTime
                                            ? getTimeFromDateTime(
                                                getLessonTimings(data.number)
                                                    .saturdayEnd)
                                            : widget.obedTime
                                                ? getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number)
                                                        .obedEnd)
                                                : getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number)
                                                        .end),
                                        style: TextStyle(
                                            color: widget.obedTime
                                                ? (data.number > 3
                                                    ? Colors.green
                                                        .withAlpha(200)
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface
                                                        .withAlpha(200))
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface
                                                    .withAlpha(200),
                                            fontFamily: 'Ubuntu')),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.title,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(data.liqidated == true
                                                ? 0.3
                                                : 1.0),
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Text(
                                  data.subTitle,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withOpacity(data.liqidated == true
                                              ? 0.3
                                              : 1.0),
                                      fontFamily: 'Ubuntu'),
                                ),
                                Row(
                                  children: [
                                    data.location != ""
                                        ? SvgPicture.asset(
                                            "assets/icon/vuesax_linear_location.svg",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                                .withOpacity(
                                                    data.liqidated == true
                                                        ? 0.3
                                                        : 1.0),
                                            width: 18,
                                            height: 18,
                                          )
                                        : const SizedBox(),
                                    Text(
                                      data.location,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withOpacity(
                                                  data.liqidated == true
                                                      ? 0.3
                                                      : 1.0),
                                          fontFamily: 'Ubuntu'),
                                    ),
                                  ],
                                ),
                                (data.swapedFromTitle != null &&
                                        data.swapedFromTitle != '')
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Замена с: ${data.swapedFromTitle}",
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
                    //Алерт замены
                    data.zamenaAlert
                        ? Container(
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                          )
                        : const SizedBox(),
                  ]));
            })),
          ],
        ));
  }
}

class CourseTile extends StatelessWidget {
  final Lesson lesson;
  final Lesson? swaped;
  final SearchType type;
  final Function refresh;
  final bool? removed;
  final bool saturdayTime;
  final bool obedTime;
  final bool empty;
  final bool short;
  final bool needZamenaAlert;

  const CourseTile(
      {this.empty = false,
      super.key,
      required this.course,
      required this.lesson,
      required this.type,
      required this.refresh,
      this.removed,
      required this.swaped,
      required this.saturdayTime,
      required this.obedTime,
      required this.short,
      this.needZamenaAlert = false});

  final Course course;

  @override
  Widget build(BuildContext context) {
    bool isEmpty =
        course.name.toLowerCase() == "нет" || course.name.trim() == '';
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 5)
                ]
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isEmpty
              ? Colors.transparent
              : Theme.of(context).colorScheme.onSurface,
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
                          color: Theme.of(context).colorScheme.surface),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: short ? 60 : 100),
                    child: Container(
                      width: 10,
                      decoration: BoxDecoration(
                          color: isEmpty
                              ? getCourseColor(course.color).withOpacity(0.6)
                              : getColorForText(course.name),
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
                                : getColorForText(course.name),),
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
                              ? getTimeFromDateTime(
                                  getLessonTimings(lesson.number).saturdayStart)
                              : obedTime
                                  ? getTimeFromDateTime(
                                      getLessonTimings(lesson.number).obedStart)
                                  : getTimeFromDateTime(
                                      getLessonTimings(lesson.number).start),
                          style: TextStyle(
                              fontSize: 16,
                              color: obedTime
                                  ? (lesson.number > 3
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .inverseSurface)
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold)),
                      Text(
                          saturdayTime
                              ? getTimeFromDateTime(
                                  getLessonTimings(lesson.number).saturdayEnd)
                              : obedTime
                                  ? getTimeFromDateTime(
                                      getLessonTimings(lesson.number).obedEnd)
                                  : getTimeFromDateTime(
                                      getLessonTimings(lesson.number).end),
                          style: TextStyle(
                              color: obedTime
                                  ? (lesson.number > 3
                                      ? Colors.green.withAlpha(200)
                                      : Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withAlpha(200))
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withAlpha(200),
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
                            (type != SearchType.cabinet && !isEmpty) ||
                                    type == SearchType.teacher
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
            //Алерт замены
            Positioned(
              top: 0,
              right: 0,
              child: (swaped != null || needZamenaAlert)
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
