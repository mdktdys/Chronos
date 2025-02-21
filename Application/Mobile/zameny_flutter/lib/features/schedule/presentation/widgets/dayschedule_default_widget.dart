import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';
import 'package:zameny_flutter/shared/providers/groups_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/tools.dart';

class DayScheduleParasWidget extends ConsumerWidget {
  final DaySchedule daySchedule;
  final bool isShowZamena;
  final bool obed;


  const DayScheduleParasWidget({
    required this.isShowZamena,
    required this.daySchedule,
    required this.obed,
    super.key

  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final item = ref.watch(searchItemProvider);

    if (daySchedule.paras.isEmpty) {
      return const NoParasWidget();
    }

    return Column(
      children: [
        ... daySchedule.paras.map((final Paras para) {

          List<Widget> tiles = [];
    
          if (item is Teacher) {
            tiles = _buildTeacherTiles(
              isShowZamena: isShowZamena,
              para: para,
              obed: obed,
            );
          }

          if (item is Group) {
            tiles = _buildGroupTiles(
              zamenaFull: daySchedule.zamenaFull,
              isShowZamena: isShowZamena,
              para: para,
              obed: obed,
            );
          }

          if (tiles.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: tiles.map((final tile) {

              if (tile is CourseTileRework) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    child: tile
                  ),
                );
              }

              return tile;
            }).toList()
          );

        })
      ],
    );
  }

  List<Widget> _buildGroupTiles({
    required final ZamenaFull? zamenaFull,
    required final bool isShowZamena,
    required final Paras para,
    required final bool obed,
  }) {
    List<Widget> tiles = [];

    if (!isShowZamena) {
      return para.lesson!.map((final lesson) {
        return CourseTileRework(
          searchType: SearchType.group,
          index: lesson.number,
          lesson: lesson,
          obed: obed,
        );
      }).toList();
    }

    if (zamenaFull != null) {
      return para.zamena!.map((final zamena) {
        return CourseTileRework(
          searchType: SearchType.group,
          index: zamena.lessonTimingsID,
          obed: obed,
          lesson: Lesson(

            id: -1,
            number: zamena.lessonTimingsID,
            group: zamena.groupID,
            date: zamena.date,
            course: zamena.courseID,
            teacher: zamena.teacherID,
            cabinet: zamena.cabinetID
          ),
        );
      }).toList();
    }

    final Zamena? zamena = para.zamena?.firstOrNull;
    final Lesson? lesson = para.lesson?.firstOrNull; 

    if (zamena == null && lesson != null) {
      tiles.add(CourseTileRework(
        searchType: SearchType.group,
        obed: obed,
        index: lesson.number,
        lesson: lesson,
      ));

    } else {

      if (zamena?.courseID == 10843) {

        if (lesson == null) {
          return [];
        }
        
        tiles.add(
          EmptyCourseTileRework(
            obed: obed,
            index: zamena!.lessonTimingsID,
            lesson: Lesson(
            id: -1,
            number: lesson.number,
            group: lesson.group,
            date: lesson.date,
            course: lesson.course,
            teacher: lesson.teacher,
            cabinet: lesson.cabinet
          ),)
        );
        
      } else {
        tiles.add(CourseTileRework(
          searchType: SearchType.group,
          index: zamena!.lessonTimingsID,
          isZamena: true,
          swapedLesson: lesson,
          obed: obed,
          
          lesson: Lesson(

            id: -1,
            number: zamena.lessonTimingsID,
            group: zamena.groupID,
            date: zamena.date,
            course: zamena.courseID,

            teacher: zamena.teacherID,
            cabinet: zamena.cabinetID
          ),
        ),
      );
      }
    }

    return tiles;
  }

  List<Widget> _buildTeacherTiles({
    required final bool isShowZamena,
    required final Paras para,
    required final bool obed,
  }) {

    List<Widget> tiles = [];

    if (!isShowZamena) {
      tiles = para.lesson!.map((final lesson) {
        return CourseTileRework(
          searchType: SearchType.teacher,
          index: lesson.number,
          lesson: lesson,
        );
      }).toList();

      return tiles;
    }

    // Если нет замен, то ставим стандартное расписание, без учета пар с полной заменой
    if (
      (para.zamena == null
      || (para.zamena!.isEmpty))
      && para.lesson != null
    ) {
      for (Lesson para2 in para.lesson!) {

        if (para.zamenaFull != null) { 
          final bool zamenaFull = para.zamenaFull!.any((final zamena) => zamena.group == para2.group);

          if (zamenaFull) {
            continue;
          }
        }

        tiles.add(CourseTileRework(
          searchType: SearchType.teacher,
          index: para2.number,
          lesson: para2,
        ));

      }
    }

    // Если по стандартному расписанию пары нет, то есть замена
    if (
      para.lesson == null
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {
        tiles.add(CourseTileRework(
          searchType: SearchType.teacher,
          isZamena: true,
          obed: obed,
          index: para2.lessonTimingsID,
          lesson: Lesson(
            id: -1,
            number: para2.lessonTimingsID,
            group: para2.groupID,
            date: para2.date,
            course: para2.courseID,
            teacher: para2.teacherID,
            cabinet: para2.cabinetID
          ),
        ));
      }
    }

    // Если есть и стандартное расписание и замена
    if (
      para.lesson != null
      && para.lesson!.isNotEmpty
      && para.zamena != null
      && para.zamena!.isNotEmpty
    ) {
      for (Zamena para2 in para.zamena!) {

        // Если это замена обычной пары той же группы
        if (para.lesson!.any((final Lesson lesson) => lesson.group == para2.groupID)) {
          tiles.add(CourseTileRework(
            searchType: SearchType.teacher,
            isZamena: true,
            obed: obed,
            index: para2.lessonTimingsID,
            swapedLesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.group == para2.groupID),
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: para2.date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID
            ),
          ));
        } else {
          // Если это просто замена другой группы
          tiles.add(CourseTileRework( 
            searchType: SearchType.teacher,
            isZamena: true,
            obed: obed,
            swapedLesson: para.lesson!.firstWhere((final Lesson lesson) => lesson.number == para2.lessonTimingsID),
            index: para2.lessonTimingsID,
            lesson: Lesson(
              id: -1,
              number: para2.lessonTimingsID,
              group: para2.groupID,
              date: para2.date,
              course: para2.courseID,
              teacher: para2.teacherID,
              cabinet: para2.cabinetID
            ),
          ));
        }
      }
    }

    return tiles;
  }
}

class DayScheduleWidget extends ConsumerStatefulWidget {

  final DaySchedule daySchedule;

  const DayScheduleWidget({
    required this.daySchedule,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayscheduleWidgetState();
}

class _DayscheduleWidgetState extends ConsumerState<DayScheduleWidget> {
  late bool needObedSwitch;
  bool obed = false;

  @override
  void initState() {
    super.initState();
    needObedSwitch = widget.daySchedule.paras.any((final Paras para) => para.number! > 3) && widget.daySchedule.paras.isNotEmpty;
  }

  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(scheduleSettingsProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        DayScheduleHeader(
          date: widget.daySchedule.date,
          links: widget.daySchedule.zamenaLinks ?? [],
          fullSwap: (widget.daySchedule.zamenaFull != null && provider.isShowZamena),
          toggleObed: _toggleObed,
          needObedSwitch: needObedSwitch,
          obed: obed,
        ),
        DayScheduleParasWidget(
          isShowZamena: provider.isShowZamena,
          daySchedule: widget.daySchedule,
          obed: obed,
        ),
      ],
    );
  }

  void _toggleObed() {
    obed = !obed;
    setState(() {});
  }
}

class NoParasWidget extends StatelessWidget {
  const NoParasWidget({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
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
              'Нет пар 🎉',
              style: context.styles.ubuntuInversePrimary20,
            ),
          ),
      ),
    );
  }
}

class EmptyCourseTileRework extends ConsumerWidget {
  final Lesson lesson;
  final bool obed;
  final int index;

  const EmptyCourseTileRework({
    required this.lesson,
    required this.index,
    required this.obed,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final Course? course = ref.watch(courseProvider(lesson.course));
    final Teacher? teacher = ref.watch(teacherProvider(lesson.teacher));
    final Cabinet? cabinet = ref.watch(cabinetProvider(lesson.cabinet));
    final LessonTimings? timings = ref.watch(timingProvider(lesson.number));

    final String? startTime = obed
      ? timings?.obedStart.hhmm()
      : timings?.start.hhmm();

    final String? endTime = obed
      ? timings?.obedEnd.hhmm()
      : timings?.end.hhmm();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
        border: DashedBorder.all(
          dashLength: 10,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Замена',
                style: context.styles.ubuntu.copyWith(
                  color: Colors.red,
                  shadows: [const Shadow(color: Colors.red, blurRadius: 4)],
                ),
              ),
              const SizedBox(width: 5,),
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
          IntrinsicHeight(
              child: Row(
                spacing: 10,
                children: [
                  Skeleton.leaf(
                    child: Container(
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton.leaf(
                          child: Container(
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                index.toString(),
                                textAlign: TextAlign.center,
                                style: context.styles.ubuntuWhiteBold14.copyWith(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          startTime.toString(),
                          style: context.styles.ubuntuBold16.copyWith(color:  Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)),
                        ),
                        Text(
                          endTime.toString(),
                          style: context.styles.ubuntu.copyWith(color:  Theme.of(context).colorScheme.primary.withValues(alpha: 0.6))
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (course?.name).toString(),
                          style: context.styles.ubuntuPrimaryBold20.copyWith(color:  Theme.of(context).colorScheme.primary.withValues(alpha: 0.6))
                        ),
                        Text(
                          (teacher?.name).toString(),
                          style: context.styles.ubuntu.copyWith(color:  Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),),
                        ),
                        if (cabinet?.name != null)
                          Text(
                            (cabinet?.name).toString(),
                            style: context.styles.ubuntu.copyWith(color:  Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),),
                          ),
                      ],
                    )
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}


class SwapedParaTileWidget extends StatelessWidget {
  const SwapedParaTileWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent,
          border: DashedBorder.all(
            dashLength: 10,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),),),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Text(
          'Пара снята',
          style: context.styles.ubuntu20.copyWith(color: Theme.of(context).colorScheme.inversePrimary,),
          ),
        ),
      ),
    );
  }
}

class CourseTileRework extends ConsumerStatefulWidget {
  final SearchType searchType;
  final Lesson? swapedLesson;
  final Lesson lesson;
  final bool isZamena;
  final bool obed;
  final int index;

  const CourseTileRework({
    required this.searchType,
    required this.lesson,
    required this.index,
    this.isZamena = false,
    this.swapedLesson,
    this.obed = false,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseTileReworkedZamenaState();
}

class _CourseTileReworkedZamenaState extends ConsumerState<CourseTileRework> {
  bool isExpanded = false;
  
  late Course? course;
  late Teacher? teacher;
  late Cabinet? cabinet;
  late LessonTimings? timings;
  late Group? group;
  late String? startTime;
  late String? endTime;
  late Color timeColor;
  late String title;
  late String subTitle;

  @override
  Widget build(final BuildContext context) {
    course = ref.watch(courseProvider(widget.lesson.course));
    teacher = ref.watch(teacherProvider(widget.lesson.teacher));
    cabinet = ref.watch(cabinetProvider(widget.lesson.cabinet));
    timings = ref.watch(timingProvider(widget.lesson.number));
    group = ref.watch(groupProvider(widget.lesson.group));

    
    startTime = widget.obed
      ? timings?.obedStart.hhmm()
      : timings?.start.hhmm();


    endTime = widget.obed
      ? timings?.obedEnd.hhmm()
      : timings?.end.hhmm();


    timeColor = widget.obed
      ? (widget.index > 3 ? Colors.green : Theme.of(context).colorScheme.inverseSurface)
      : Theme.of(context).colorScheme.inverseSurface;

    title = (course?.name).toString();
    subTitle = '';
    if (widget.searchType == SearchType.group) {
      subTitle = (teacher?.name).toString();
    } else {
      subTitle = (group?.name).toString();
    }


    return Bounceable(
      hitTestBehavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              spacing: 10,
              children: [
                Skeleton.leaf(
                  child: Container(
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: getColorForText((course?.name).toString()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton.leaf(
                        child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getColorForText(title)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.index.toString(),
                              textAlign: TextAlign.center,
                              style: context.styles.ubuntuWhiteBold14,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        startTime.toString(),
                        style: context.styles.ubuntuBold16.copyWith(color: timeColor),
                      ),
                      Text(
                        endTime.toString(),
                        style: context.styles.ubuntu.copyWith(color: timeColor)
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: context.styles.ubuntuPrimaryBold20.copyWith(color: Theme.of(context).colorScheme.inverseSurface)
                      ),
                      Text(
                        subTitle,
                        style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
                      ),
                      if (cabinet?.name != null)
                        Text(
                          (cabinet?.name).toString(),
                          style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
                        ),
                    ],
                  )
                )
              ],
            ),
          ),
          if (widget.isZamena)
            AnimatedSize(
              alignment: Alignment.topCenter,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Замена',
                            style: context.styles.ubuntu.copyWith(
                              color: Colors.red,
                              shadows: [const Shadow(color: Colors.red, blurRadius: 4)],
                            ),
                          ),
                          const SizedBox(width: 5,),
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
                      if (widget.swapedLesson != null)
                        Align(
                          child: AnimatedRotation(
                            duration: const Duration(milliseconds: 150),
                            turns: isExpanded ? 0.5 : 0,
                            child: SvgPicture.asset(Images.chevron, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.4), BlendMode.srcIn),),
                          ),
                        ),
                    ],
                  ),
                  if (isExpanded && widget.swapedLesson != null)

                    Opacity(
                      opacity: 0.4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SwapedParaWidget(
                          searchType: widget.searchType,
                          lesson: widget.swapedLesson!,
                        ),
                      ),
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SwapedParaWidget extends ConsumerWidget {
  final SearchType searchType;
  final Lesson lesson;

  const SwapedParaWidget({
    required this.searchType,
    required this.lesson,
    super.key,
  });


  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final course = ref.watch(courseProvider(lesson.course));
    final teacher = ref.watch(teacherProvider(lesson.teacher));
    final cabinet = ref.watch(cabinetProvider(lesson.cabinet));
    final group = ref.watch(groupProvider(lesson.group));

    final title = (course?.name).toString();
    
    String subTitle = '';
    if (searchType == SearchType.group) {
      subTitle = (teacher?.name).toString();
    } else {
      subTitle = (group?.name).toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: context.styles.ubuntuPrimaryBold20.copyWith(color: Theme.of(context).colorScheme.inverseSurface)
        ),
        Text(
          subTitle,
          style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
        ),
        if (cabinet?.name != null)
          Text(
            (cabinet?.name).toString(),
            style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
          ),
      ],
    );
  }
}

// class DayScheduleWidget extends ConsumerStatefulWidget {
//   final DateTime startDate;
//   final int currentDay;
//   final int currentWeek;
//   final int todayWeek;
//   final Data data;
//   final int day;
//   final List<Zamena> dayZamenas;
//   final List<Lesson> lessons;

//   const DayScheduleWidget({
//     required this.day,
//     required this.dayZamenas,
//     required this.lessons,
//     required this.startDate,
//     required this.currentDay,
//     required this.currentWeek,
//     required this.todayWeek,
//     required this.data,
//     super.key,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _DayScheduleWidgetState();
// }

// class _DayScheduleWidgetState extends ConsumerState<DayScheduleWidget> {
// bool obed = false;

//   void toggleObed() {
//     obed = !obed;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((final timestamp) {
//       if (
//         widget.day == widget.currentDay
//         && widget.currentWeek == widget.todayWeek
//         && !Adaptive.isDesktop(context)
//       ) {
//         Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), alignment: 0.5,);
//       }
//     });
//   }

//   @override
//   Widget build(final BuildContext context) {
//     final bool isToday = (
//       widget.day == widget.currentDay
//       && widget.todayWeek == widget.currentWeek
//         ? true
//         : false);
//     final SearchType type = ref.watch(scheduleProvider).searchType;
//     bool fullSwap = false;
//     final int searchDay = widget.startDate.add(Duration(days: widget.day - 1)).day;
//     final int searchMonth =
//         widget.startDate.add(Duration(days: widget.day - 1)).month;
//     final int searchYear = widget.startDate.add(Duration(days: widget.day - 1)).year;
//     if (widget.lessons.isNotEmpty) {
//       if (type == SearchType.group) {
//         fullSwap = GetIt.I
//             .get<Data>()
//             .zamenasFull
//             .where((final element) =>
//                 (element.group == widget.lessons[0].group) &&
//                 (element.date.day == searchDay) &&
//                 (element.date.month == searchMonth) &&
//                 (element.date.year == searchYear),)
//             .toSet()
//             .isNotEmpty;
//       }
//     }
//     final List<Widget> tiles = newMethod(fullSwap, type, searchYear, searchMonth,
//         searchDay, GetIt.I.get<Data>().seekGroup!,);
//     final List<CourseTile> courseTiles = [];
//     for (final Widget i in tiles) {
//       if (i is CourseTile) {
//         courseTiles.add(i);
//       }
//     }
//     final bool needObedSwitch = courseTiles.any((final element) =>
//         element.lesson.number == 4 ||
//         element.lesson.number == 5 ||
//         element.lesson.number == 6 ||
//         element.lesson.number == 7,);
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: isToday
//           ? BoxDecoration(
//               border: Border.all(
//                   strokeAlign: BorderSide.strokeAlignOutside,
//                   color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
//                   width: 2,),
//               borderRadius: const BorderRadius.all(Radius.circular(20)),)
//           : null,
//       child: Column(
//         children: [
//           Column(
//             children: [
//               // DayScheduleHeader(
//               //     day: widget.day,
//               //     startDate: widget.startDate,
//               //     isToday: isToday,
//               //     fullSwap: fullSwap,),
//               //isToday
//               courseTiles.isNotEmpty && needObedSwitch && (widget.day != 6)
//                   ? Row(
//                       children: [
//                         SizedBox(
//                           height: 38,
//                           child: FittedBox(
//                             child: Switch(
//                                 value: obed,
//                                 onChanged: (final value) => toggleObed(),),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         Text(
//                           'Без обеда',
//                           style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
//                         ),
//                       ],
//                     )
//                   : Adaptive.isDesktop(context) ? const SizedBox(height: 38,) : const SizedBox(),
//             ],
//           ),
//           courseTiles.isNotEmpty
//             ? Column(children: courseTiles)
//             : Container(
//                 height: 110,
//                 margin: const EdgeInsets.only(top: 20, bottom: 10),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(20)),
//                     color: Colors.transparent,
//                     border: DashedBorder.all(
//                         dashLength: 10,
//                         color: Theme.of(context)
//                             .colorScheme
//                             .primary
//                             .withValues(alpha: 0.6),),),
//                 child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Center(
//                       child: Text(
//                         'Нет пар',
//                         style: context.styles.ubuntuInversePrimary20,
//                     ),
//                   ),
//                 ),
//               ),
//         ],
//       ),
//     );
//   }

//   List<Widget> newMethod(
//     final bool fullSwap,
//     final SearchType type,
//     final int todayYear,
//     final int todayMonth,
//     final int todayDay,
//     final int group
//   ) {
//     final Data data = GetIt.I.get<Data>();

//     final Holiday? holiday = data.holidays.where((final element) => element.date == DateTime(todayYear, todayMonth, todayDay)).firstOrNull;
//     if (holiday != null) {
//       return [
//         Container(
//           height: 110,
//           margin: const EdgeInsets.only(
//             top: 20,
//             bottom: 10
//           ),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//             color: Colors.transparent,
//             border: DashedBorder.all(
//               dashLength: 10,
//               color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
//             ),
//           ),
//           child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Center(
//                 child: Text(
//                   holiday.name,
//                   style: context.styles.ubuntuInversePrimary20,
//                 ),
//               ),
//             ),
//           ),
//       ];
//     }
//     final Liquidation? liquidation = data.liquidations.where((final element) => DateTime(todayYear, todayMonth, todayDay) == element.date && element.group == group).firstOrNull;

//     if (liquidation != null) {
//       return [
//         Container(
//           height: 110,
//           margin: const EdgeInsets.only(
//             top: 20,
//             bottom: 10,
//           ),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//             color: Colors.transparent,
//             border: DashedBorder.all(
//               dashLength: 10,
//               color:Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
//             ),
//           ),
//           child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Center(
//                 child: Text(
//                   'Ликвидация задолженностей',
//                   style: context.styles.ubuntuInversePrimary20,
//                 ),
//               ),
//           ),
//         ),
//       ];
//     }
//     return widget.data.timings.map((final para) {
//       if (fullSwap) {
//         // Lesson? removedPara = lessons
//         //     .where((element) => element.number == para.number)
//         //     .firstOrNull;
//         // if (removedPara != null) {
//         //   return const SizedBox();
//         // }
//         final Zamena? zamena = widget.dayZamenas.where((final element) => element.lessonTimingsID == para.number).firstOrNull;
//         if (zamena != null) {
//           final course = getCourseById(zamena.courseID) ?? Course(id: -1, name: 'err2', color: '100,0,0,0');
//           return CourseTile(
//             short: false,
//             type: type,
//             obedTime: obed,
//             course: course,
//             swaped: null,
//             saturdayTime: widget.day == 6,
//             lesson: Lesson(
//                 id: -1,
//                 course: course.id,
//                 cabinet: zamena.cabinetID,
//                 number: zamena.lessonTimingsID,
//                 teacher: zamena.teacherID,
//                 group: zamena.groupID,
//                 date: zamena.date,),
//           );
//         }
//         return const SizedBox.shrink();
//       } else {
//         if (widget.dayZamenas.any((final element) => element.lessonTimingsID == para.number)) {
//           final Lesson? swapedPara = widget.lessons.where((final element) => element.number == para.number).firstOrNull;
//           final Zamena zamena = widget.dayZamenas.where((final element) => element.lessonTimingsID == para.number).first;
//           final course = getCourseById(zamena.courseID) ?? Course(id: -1, name: 'err2', color: '100,0,0,0');

//           return CourseTile(
//             needZamenaAlert: true,
//             short: false,
//             type: type,
//             obedTime: obed,
//             course: course,
//             saturdayTime: widget.day == 6,
//             lesson: Lesson(
//               id: -1,
//               course: course.id,
//               cabinet: zamena.cabinetID,
//               number: zamena.lessonTimingsID,
//               teacher: zamena.teacherID,
//               group: zamena.groupID,
//               date: zamena.date,),
//             swaped: swapedPara,
//           );
//         } else {
//           if (widget.lessons.any((final element) => element.number == para.number)) {
//             final Lesson lesson = widget.lessons
//                 .where((final element) => element.number == para.number)
//                 .first;
//             final course = getCourseById(lesson.course) ??
//                 Course(id: -1, name: 'err3', color: '50,0,0,1');
//                 //дефолтное
//             return CourseTile(
//               short: false,
//               saturdayTime: widget.day == 6,
//               type: type,
//               obedTime: obed,
//               course: course,
//               lesson: lesson,
//               swaped: null,
//             );
//           }
//         }
//       }
//       return const SizedBox();
//     }).toList();
//   }
// }


          
    
          // return Padding(
          //   padding: const EdgeInsets.only(top: 8),
          //   child: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          //     ),
          //     child: Column(
          //       spacing: 8,
          //       children: tiles
          //     ),
          //   ),
          // );
        