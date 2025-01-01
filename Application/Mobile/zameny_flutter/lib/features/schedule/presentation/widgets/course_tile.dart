import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/tools.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/features/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

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

  TileData({
    required this.title,
    required this.number,
    required this.subTitle,
    required this.location,
    required this.color,
    required this.zamenaAlert, this.swapedFromTitle,
    this.liqidated
  });
}

class MixedCourseTile extends StatefulWidget {
  final List<TileData> tilesData;
  final bool saturdayTime;
  final bool obedTime;
  const MixedCourseTile(
      {required this.tilesData, required this.saturdayTime, required this.obedTime, super.key,});

  @override
  State<MixedCourseTile> createState() => _MixedCourseTileState();
}

class _MixedCourseTileState extends State<MixedCourseTile> {
  @override
  Widget build(final BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          // boxShadow: Theme.of(context).brightness == Brightness.light
          //     ? [
          //         BoxShadow(
          //             color: Colors.black.withValues(alpha: 0.15),
          //             offset: const Offset(0, 1),
          //             blurRadius: 5)
          //       ]
          //     : null,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        child: Column(
          children: [
            widget.tilesData.length > 1
              ? Builder(builder: (final context) {
                  final data = widget.tilesData.first;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: getColorForText(data.title),),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.number.toString(),
                              textAlign: TextAlign.center,
                              style: context.styles.ubuntuWhiteBold14,
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
                                          .saturdayStart,)
                                  : widget.obedTime
                                      ? getTimeFromDateTime(
                                          getLessonTimings(data.number)
                                              .obedStart,)
                                      : getTimeFromDateTime(
                                          getLessonTimings(data.number)
                                              .start,),
                              style: context.styles.ubuntuBold22.copyWith(
                                  color: widget.obedTime
                                      ? (data.number > 3
                                        ? Colors.green
                                        : Theme.of(context).colorScheme.inverseSurface)
                                      : Theme.of(context).colorScheme.inverseSurface,
                                  ),
                                ),
                            Text(
                                widget.saturdayTime
                                    ? getTimeFromDateTime(
                                        getLessonTimings(data.number)
                                            .saturdayEnd,)
                                    : widget.obedTime
                                        ? getTimeFromDateTime(
                                            getLessonTimings(data.number)
                                                .obedEnd,)
                                        : getTimeFromDateTime(
                                            getLessonTimings(data.number)
                                                .end,),
                                style: context.styles.ubuntu18.copyWith(
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
                                      ),),
                          ],
                        ),
                      ],
                    ),
                  );
                },)
              : const SizedBox.shrink(),
            Column(
                children: List.generate(widget.tilesData.length, (final index) {
              final TileData data = widget.tilesData[index];
              final bool isLast = widget.tilesData.length - 1 == index;
              return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  highlightColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  radius: 100,
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          8, index == 0 ? 8.0 : 0, 10, isLast ? 8.0 : 0,),
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 100),
                            child: Container(
                              width: 10,
                              decoration: BoxDecoration(
                                  color: getColorForText(data.title)
                                      .withValues(alpha: 
                                          data.liqidated == true ? 0.3 : 1.0,),
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
                                  ),),
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
                                          color: getColorForText(data.title),),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data.number.toString(),
                                          textAlign: TextAlign.center,
                                          style: context.styles.ubuntuWhiteBold14,
                                        ),
                                      ),
                                    ),
                                    Text(
                                        widget.saturdayTime
                                            ? getTimeFromDateTime(
                                                getLessonTimings(data.number)
                                                    .saturdayStart,)
                                            : widget.obedTime
                                                ? getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number,)
                                                        .obedStart,)
                                                : getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number,)
                                                        .start,),
                                        style: context.styles.ubuntuInverseSurfaceBold16.copyWith(
                                          color: widget.obedTime
                                            ? (data.number > 3
                                                ? Colors.green
                                                : Theme.of(context).colorScheme.inverseSurface)
                                            : Theme.of(context).colorScheme.inverseSurface
                                            ),
                                          ),
                                    Text(
                                        widget.saturdayTime
                                            ? getTimeFromDateTime(
                                                getLessonTimings(data.number)
                                                    .saturdayEnd,)
                                            : widget.obedTime
                                                ? getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number,)
                                                        .obedEnd,)
                                                : getTimeFromDateTime(
                                                    getLessonTimings(
                                                            data.number,)
                                                        .end,),
                                        style: context.styles.ubuntu.copyWith(
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
                                                    .withAlpha(200)),),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title,
                                  overflow: TextOverflow.fade,
                                  style: context.styles.ubuntuPrimaryBold20.copyWith(
                                    color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: data.liqidated == true
                                      ? 0.3
                                      : 1.0
                                    ),
                                  ),
                                ),
                                Text(
                                  data.subTitle,
                                  style: context.styles.ubuntu.copyWith(
                                    color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: data.liqidated == true
                                      ? 0.3
                                      : 1.0,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    data.location != ''
                                        ? SvgPicture.asset(
                                            'assets/icon/vuesax_linear_location.svg',
                                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 
                                                    data.liqidated == true
                                                        ? 0.3
                                                        : 1.0,), BlendMode.srcIn),
                                            width: 18,
                                            height: 18,
                                          )
                                        : const SizedBox(),
                                    Text(
                                      data.location,
                                      style: context.styles.ubuntu.copyWith(
                                        color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 
                                          data.liqidated == true
                                            ? 0.3
                                            : 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (data.swapedFromTitle != null && data.swapedFromTitle != '')
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Замена с: ${data.swapedFromTitle}',
                                        style: context.styles.ubuntuBold12.copyWith(
                                          color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.3),
                                      )
                                      ),
                                    )
                                  : const SizedBox.shrink (),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Замена',
                                  style: context.styles.ubuntu.copyWith(
                                    shadows: [const Shadow(color: Colors.red, blurRadius: 4)],
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  shadows: [
                                    Shadow(color: Colors.red, blurRadius: 4),
                                  ],
                                  size: 24,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],),);
            }),),
          ],
        ),);
  }
}

class CourseTile extends ConsumerWidget {
  final bool needZamenaAlert;
  final bool saturdayTime;
  final Function refresh;
  final SearchType type;
  final Lesson? swaped;
  final Lesson lesson;
  final bool? removed;
  final bool obedTime;
  final bool clickabe;
  final Course course;
  final bool empty;
  final bool short;

  const CourseTile({
    required this.saturdayTime,
    required this.obedTime,
    required this.refresh,
    required this.course,
    required this.lesson,
    required this.swaped,
    required this.short,
    required this.type,
    this.needZamenaAlert = false,
    this.clickabe = true,
    this.empty = false,
    this.removed,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool isEmpty = course.name.toLowerCase() == 'нет' || course.name.trim() == '';
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isEmpty
              ? Colors.transparent
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          border: isEmpty
              ? DashedBorder.all(
                  dashLength: 10,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),)
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          highlightColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          radius: 100,
          onLongPress: clickabe? () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withValues(alpha: 0.1),
                context: myGlobals.scaffoldKey.currentContext!,
                useSafeArea: true,
                builder: (final BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,),
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.surface,),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(myGlobals.scaffoldKey.currentContext!).pop();
                                ref.read(scheduleProvider).groupSelected(lesson.group, myGlobals.scaffoldKey.currentContext!);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Показать расписание для группы\n${getGroupById(lesson.group)!.name}',
                                  style: context.styles.ubuntu
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },);
          } : null,
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
                              ? getCourseColor(course.color).withValues(alpha: 0.6)
                              : getColorForText(course.name),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),),
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
                              ? getCourseColor(course.color).withValues(alpha: 0.6)
                              : getColorForText(course.name),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lesson.number.toString(),
                            textAlign: TextAlign.center,
                            style: context.styles.ubuntuWhiteBold14,
                          ),
                        ),
                      ),
                      Text(
                          saturdayTime
                              ? getTimeFromDateTime(
                                  getLessonTimings(lesson.number).saturdayStart,)
                              : obedTime
                                  ? getTimeFromDateTime(
                                      getLessonTimings(lesson.number).obedStart,)
                                  : getTimeFromDateTime(
                                      getLessonTimings(lesson.number).start,),
                          style: context.styles.ubuntuBold16.copyWith(
                            color: obedTime
                              ? (lesson.number > 3
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.inverseSurface)
                              : Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                )
                              ),
                        Text(
                          saturdayTime
                              ? getTimeFromDateTime(
                                  getLessonTimings(lesson.number).saturdayEnd,)
                              : obedTime
                                  ? getTimeFromDateTime(
                                      getLessonTimings(lesson.number).obedEnd,)
                                  : getTimeFromDateTime(
                                      getLessonTimings(lesson.number).end,),
                          style: context.styles.ubuntu.copyWith(
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
                                      .withAlpha(200),),),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (getCourseById(lesson.course) ?? Course(id: -1, name: 'err', color: '0,0,0,0',)).name,
                          overflow: TextOverflow.fade,
                          style: context.styles.ubuntuPrimaryBold20.copyWith(color: Theme.of(context).colorScheme.inverseSurface),
                        ),
                        Text(
                          type == SearchType.teacher
                              ? getGroupById(lesson.group)!.name
                              : type == SearchType.group
                                  ? getTeacherById(lesson.teacher).name
                                  : type == SearchType.cabinet
                                      ? ''
                                      : '',
                          style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
                        ),
                        Row(
                          children: [
                            (type != SearchType.cabinet && !isEmpty) ||
                                    type == SearchType.teacher
                                ? SvgPicture.asset(
                                    'assets/icon/vuesax_linear_location.svg',
                                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface, BlendMode.srcIn),
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
                                          : '',
                              style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
                            ),
                          ],
                        ),
                        swaped != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Замена с: ${getCourseById(swaped!.course)!.name}',
                                style: context.styles.ubuntuBold12.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.3)),
                              ),
                            )
                          : const SizedBox.shrink(),
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
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            Text(
                              'Замена',
                              style: context.styles.ubuntu.copyWith(
                                color: Colors.red,
                                shadows: [const Shadow(color: Colors.red, blurRadius: 4)],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              shadows: [
                                Shadow(color: Colors.red, blurRadius: 4),
                              ],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],),
        ),);
  }
}
