import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/new/config/delays.dart';
import 'package:zameny_flutter/new/enums/schedule_view_modes.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/new/widgets/skeletonized_provider.dart';
import 'package:zameny_flutter/shared/layouts/adaptive_layout.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class ScheduleDaysWidget extends ConsumerWidget {
  final List<DaySchedule> days;

  const ScheduleDaysWidget({
    required this.days,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ScheduleViewModes viewMode = ref.watch(scheduleSettingsProvider).viewmode;
    Widget child = const SizedBox.shrink();

    if (viewMode == ScheduleViewModes.grid) {
      child = ScheduleViewGrid(days: days);
    }

    if (viewMode == ScheduleViewModes.list) {
      child = ScheduleViewList(days: days);
    }

    if (viewMode == ScheduleViewModes.auto) {
      child = AdaptiveLayout(
        mobile: () => ScheduleViewList(days: days),
        desktop: () => ScheduleViewGrid(days: days),
      );
    }

    return AnimatedSwitcher(
      duration: Delays.morphDuration,
      child: child,
    );
  }
}


class ScheduleViewList extends StatelessWidget {
  final List<DaySchedule> days;

  const ScheduleViewList({
    required this.days,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        ...days.map((final day) {
          return DayScheduleWidget(daySchedule: day);
        }),
        const SizedBox(height: 100),
      ]
    );
  }
}


class ScheduleViewGrid extends ConsumerStatefulWidget {
  final List<DaySchedule> days;

  const ScheduleViewGrid({
    required this.days,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleViewGridState();
}

class _ScheduleViewGridState extends ConsumerState<ScheduleViewGrid> {
  final Map<DaySchedule, bool> obed = {};

  @override
  Widget build(final BuildContext context) {
    final SearchItem? item = ref.watch(searchItemProvider);
    final scheduleSettings = ref.watch(scheduleSettingsProvider);
    final builder = ref.watch(scheduleTilesBuilderProvider);

    final bool isShowZamena = scheduleSettings.isShowZamena;
    final bool obedSwitch = scheduleSettings.obed;

    List<Map<int, Widget>> tiles = widget.days.map((final daySchedule) {
      return Map<int, Widget>.fromEntries(
        daySchedule.paras.expand((final Paras para) {  
          List<Widget> tiles = [];

          if (item is Teacher) {
            tiles = builder.buildTeacherTiles(
              isShowZamena: isShowZamena,
              obed: obedSwitch,
              para: para,
            );
          }

          if (item is Group) {
            tiles = builder.buildGroupTiles(
              zamenaFull: daySchedule.zamenaFull,
              isShowZamena: isShowZamena,
              obed: obedSwitch,
              para: para,
            );
          }

          if (tiles.isEmpty) {
            return [MapEntry(para.number!, const SizedBox.shrink())];
          }

          return tiles.map((final Widget tile) {
            Widget wrappedTile = tile;
            
            if (tile is CourseTileRework) {
              wrappedTile = Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  ),
                  child: tile,
                ),
              );
            }

            return MapEntry(para.number!, wrappedTile);
          });
        }),
      );
    }).toList();


    return Expanded(
      child: Column(
        children: [
          //headers
          Row(
            children: widget.days.map((final DaySchedule day) {
              return Expanded(
                child: DayScheduleHeader(
                  toggleObed: () => _toggleDayObed(day),
                  needObedSwitch: false,
                  links: day.zamenaLinks ?? [],
                  obed: obed[day] ?? false,
                  date: day.date,
                  fullSwap: (
                    (day.zamenaFull != null)
                    && scheduleSettings.isShowZamena
                  ),
                ),
              );
            }).toList()
          ),
          // Paras
          SkeletonizedProvider<List<LessonTimings>>(
            provider: timingsProvider,
            fakeData: () => [],
            data: (final List<LessonTimings> timings) {
              return Column(
                children: timings.asMap().entries.map((final MapEntry<int, LessonTimings> timings) {
                  return AnimatedSize(
                    alignment: Alignment.topCenter,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 200),
                    child: IntrinsicHeight(
                      child: Row(
                        spacing: 10,
                        children: widget.days.asMap().entries.map((final MapEntry<int, DaySchedule> day) {
                      
                      
                          final dayParas = tiles[day.key][timings.key + 1];
                      
                          return Expanded(child: Column(
                            children: [
                              // Text('day ${day.key.toString()} timing ${timings.key}'),
                              Expanded(child: dayParas ?? const SizedBox()),
                            ],
                          ));
                          // return Expanded(child: );
                          // return [timings.key];
                        }).toList(),
                      ),
                    ),
                  );
                }).toList()
              );
            },
            error: (final e,final o) {
              return const Text('data');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _toggleDayObed(final DaySchedule day) async {
    if (!obed.containsKey(day)) {
      obed[day] = false;
    } else {
      obed[day] = !obed[day]!;
    }

    setState(() {});
  }
}
