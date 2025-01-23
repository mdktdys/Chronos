import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/features/zamena_screen/providers/zamena_provider.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/services/Data.dart';
import 'package:zameny_flutter/shared/providers/adaptive.dart';
import 'package:zameny_flutter/shared/providers/groups_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';
import 'package:zameny_flutter/shared/tools.dart';

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
    needObedSwitch = widget.daySchedule.paras.any((final para) => para.number! > 3);
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        DayScheduleHeader(
          date: widget.daySchedule.date,
          links: widget.daySchedule.zamenaLinks ?? []
        ),
        if (needObedSwitch)
          Row(
            spacing: 8,
            children: [
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                    value: obed,
                    onChanged: (final value) => _toggleObed(),),
                ),
              ),
              Text(
                'Без обеда',
                style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ... widget.daySchedule.paras.map((final para) {
          final Lesson? lesson = para.lesson?.firstOrNull;
          final Course? course = ref.watch(courseProvider(lesson?.course ?? -1));
          final Teacher? teacher = ref.watch(teacherProvider(lesson?.teacher ?? -1));
          final Cabinet? cabinet = ref.watch(cabinetProvider(lesson?.cabinet ?? -1));
          final LessonTimings? timings = ref.watch(timingProvider(lesson?.number ?? -1));

          return CourseTileRework(
            cabinetTitle: cabinet?.name ?? '',
            subTitle: teacher?.name ?? '',
            index: lesson?.number ?? -1,
            title: course?.name ?? '',
            startTime: timings?.start.hhmm().toString(),
            endTime: timings?.end.hhmm().toString(),
          );
        })
      ],
    );
  }

  void _toggleObed() {
    obed = !obed;
    setState(() {
      
    });
  }
}


class CourseTileRework extends StatelessWidget {
  final String? cabinetTitle;
  final String? startTime;
  final String? subTitle;
  final String? endTime;
  final bool obedTime;
  final String title;
  final int index;

  const CourseTileRework({
    required this.title,
    required this.index,
    this.obedTime = false,
    this.cabinetTitle,
    this.startTime,
    this.subTitle,
    this.endTime,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    final Color timeColor = obedTime
      ? (index > 3 ? Colors.green : Theme.of(context).colorScheme.inverseSurface)
      : Theme.of(context).colorScheme.inverseSurface;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      padding: const EdgeInsets.all(8),
      child: IntrinsicHeight(
        child: Row(
          spacing: 10,
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: getColorForText(title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColorForText(title)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        index.toString(),
                        textAlign: TextAlign.center,
                        style: context.styles.ubuntuWhiteBold14,
                      ),
                    ),
                  ),
                  if (startTime != null)
                    Text(
                      startTime!,
                      style: context.styles.ubuntuBold16.copyWith(color: timeColor),
                    ),
                  if (endTime != null)
                    Text(
                      endTime!,
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
                  if (subTitle != null)
                    Text(
                      subTitle!,
                      style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
                    ),
                  if (cabinetTitle != null)
                    Text(
                      cabinetTitle!,
                      style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface,),
                    ),
                ],
              )
            )
          ],
        ),
      ),
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
