import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
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
    final SearchItem? item = ref.watch(searchItemProvider);
    final bool isSaturday = daySchedule.date.weekday == 6;

    if (daySchedule.paras.isEmpty) {
      return const NoParasWidget();
    }

    final builder = ref.watch(scheduleTilesBuilderProvider);

    List<Widget> paras = [];
    for (Paras para in daySchedule.paras) {
      List<Widget> tiles = [];

      if (item is Teacher) {
        tiles = builder.buildTeacherTiles(
          isSaturday: isSaturday,
          isShowZamena: isShowZamena,
          para: para,
          obed: obed,
        );
      }

      if (item is Group) {
        tiles = builder.buildGroupTiles(
          isSaturday: isSaturday,
          zamenaFull: daySchedule.zamenaFull,
          isShowZamena: isShowZamena,
          para: para,
          obed: obed,
        );
      }

      if (tiles.isEmpty) {
        continue;
      }

      paras.add(Column(
        children: tiles.map((final tile) {
          if (tile is CourseTileRework) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CourseTileReworkedBlank(child: tile)
            );
          }

          return tile;
        }).toList()
      ));
    }

    if (paras.isEmpty) {
      return const NoParasWidget();
    }

    return Column(children: paras);
  }
}

class CourseTileReworkedBlank extends StatelessWidget {
  final Widget child;

  const CourseTileReworkedBlank({
    required this.child,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      child: child
    );
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
          telegramLink: widget.daySchedule.telegramLink,
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
        bottom: 10,
        top: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
        border: DashedBorder.all(
          color:Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          dashLength: 10,
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
  final bool isSaturday;
  final int index;

  const CourseTileRework({
    required this.searchType,
    required this.lesson,
    required this.index,
    required this.isSaturday,
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
  late Color timeColor;
  late String title;
  late String subTitle;

  Future<void> _onClicked() async {
    isExpanded = !isExpanded;

    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    course = ref.watch(courseProvider(widget.lesson.course));
    teacher = ref.watch(teacherProvider(widget.lesson.teacher));
    cabinet = ref.watch(cabinetProvider(widget.lesson.cabinet));
    timings = ref.watch(timingProvider(widget.lesson.number));
    group = ref.watch(groupProvider(widget.lesson.group));
    
    final String? startTime;
    final String? endTime;

    if (widget.isSaturday) {
      startTime = timings?.saturdayStart.hhmm();
      endTime = timings?.saturdayEnd.hhmm();
    } else {
      startTime = widget.obed
        ? timings?.obedStart.hhmm()
        : timings?.start.hhmm();

      endTime  = widget.obed
        ? timings?.obedEnd.hhmm()
        : timings?.end.hhmm();
    }


    timeColor = widget.obed
      ? (
          widget.index > 3
            ? Colors.green
            : Theme.of(context).colorScheme.inverseSurface
          )
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
      onTap: (widget.swapedLesson != null)
        ? _onClicked
        : null,
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
