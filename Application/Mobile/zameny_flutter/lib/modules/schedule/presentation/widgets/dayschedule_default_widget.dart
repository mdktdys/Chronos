import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/enums/schedule_view_mode.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/extensions/string_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
import 'package:zameny_flutter/new/providers/search_item_provider.dart';
import 'package:zameny_flutter/secrets.dart';
import 'package:zameny_flutter/models/models.dart';

class DayScheduleParasWidget extends ConsumerWidget {
  final DaySchedule daySchedule;
  final bool obed;

  const DayScheduleParasWidget({
    required this.daySchedule,
    required this.obed,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final settings = ref.watch(scheduleSettingsProvider);
    final SearchItem? item = ref.watch(searchItemProvider);
    final bool isSaturday = daySchedule.date.weekday == 6;

    if (daySchedule.holidays.isNotEmpty && (settings.sheduleViewMode == ScheduleViewMode.schedule)) {
      return Column(
        children: daySchedule.holidays.map((final Holiday holiday) {
          return NoParasWidget(reason: holiday.name);
        }).toList()
      );
    }
    
    if (daySchedule.paras.isEmpty) {
      return const NoParasWidget(reason: 'Нет пар');
    }

    final builder = ref.watch(scheduleTilesBuilderProvider);

    List<Widget> paras = [];
    for (Paras para in daySchedule.paras) {
      List<Widget> tiles = [];

      if (item is Teacher) {
        tiles = builder.buildTeacherTiles(
          teacherId: item.id,
          isSaturday: isSaturday,
          viewMode: settings.sheduleViewMode,
          para: para,
          obed: obed,
        );
      }

      if (item is Group) {
        tiles = builder.buildGroupTiles(
          isSaturday: isSaturday,
          zamenaFull: daySchedule.zamenaFull,
          viewMode: settings.sheduleViewMode,
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
      return const NoParasWidget(
        reason: 'Нет пар',
      );
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
          fullSwap: (widget.daySchedule.zamenaFull != null && (provider.sheduleViewMode == ScheduleViewMode.zamenas || provider.sheduleViewMode == ScheduleViewMode.schedule)),
          toggleObed: _toggleObed,
          needObedSwitch: needObedSwitch,
          obed: obed,
        ),
        AnimatedSize(
          duration: Delays.morphDuration,
          alignment: Alignment.topCenter,
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: Delays.morphDuration,
            child: DayScheduleParasWidget(
              key: UniqueKey(),
              daySchedule: widget.daySchedule,
              obed: obed,
            ),
          ),
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
  final String reason;

  const NoParasWidget({
    required this.reason,
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
            reason,
            style: context.styles.ubuntuInversePrimary20,
          ),
        ),
      ),
    );
  }
}

class EmptyCourseTileRework extends ConsumerWidget {
  final SearchType searchType;
  final String placeReason;
  final Lesson lesson;
  final bool obed;
  final int index;

  const EmptyCourseTileRework({
    required this.placeReason,
    required this.searchType,
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
    final Group? group = ref.watch(groupProvider(lesson.group));
    final LessonTimings? timings = ref.watch(timingProvider(lesson.number));

    final String? startTime = obed
      ? timings?.obedStart.hhmm()
      : timings?.start.hhmm();

    final String? endTime = obed
      ? timings?.obedEnd.hhmm()
      : timings?.end.hhmm();

    String? subTitle = '';
    if (searchType == SearchType.teacher) {
      subTitle = group?.name;
    } else if (searchType == SearchType.group) {
      subTitle = teacher?.name;
    } else if (searchType == SearchType.cabinet) {
      subTitle = group?.name;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
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
                  ),
                ),
                const SizedBox(width: 5,),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 18,
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
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (IS_DEV)
                            Text(placeReason),
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
                            subTitle.toString(),
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
      ),
    );
  }
}


class CourseTileRework extends ConsumerStatefulWidget {
  final String placeReason;
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
    required this.placeReason,
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

  Future<void> onLongPress() async {
    
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
      onLongPress: onLongPress,
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
                      color: ((course?.name).toString()).getColorForText(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (IS_DEV) ...[
                        Text(widget.placeReason)
                      ],
                      Skeleton.leaf(
                        child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: title.getColorForText()
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
              duration: Delays.fastMorphDuration,
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
                            ),
                          ),
                          const SizedBox(width: 5,),
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                        ],
                      ),
                      if (widget.swapedLesson != null)
                        Align(
                          child: AnimatedRotation(
                            duration: Delays.fastMorphDuration,
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
