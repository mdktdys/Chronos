import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/paras_model.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_tiles_builder.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/widgets/skeletonized_provider.dart';


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
    final ScheduleSettingsNotifier scheduleSettings = ref.watch(scheduleSettingsProvider);
    final ScheduleTilesBuilder builder = ref.watch(scheduleTilesBuilderProvider);

    final bool obedSwitch = scheduleSettings.obed;

    List<Map<int, Widget>> tiles = widget.days.map((final DaySchedule daySchedule) {
      final bool isSaturday = daySchedule.date.weekday == 6;
      return Map<int, Widget>.fromEntries(
        daySchedule.paras.expand((final Paras para) {  
          List<Widget> tiles = [];

          if (daySchedule.holidays.isNotEmpty && (scheduleSettings.sheduleViewMode == ScheduleViewMode.schedule)) {
            return List.generate(daySchedule.holidays.length,(final int index) {
              return MapEntry(1, NoParasWidget(reason: daySchedule.holidays[index].name));
            }).toList();
          }

          if (item is Teacher) {
            tiles = builder.buildTeacherTiles(
              teacherId: item.id,
              isSaturday: isSaturday,
              viewMode: scheduleSettings.sheduleViewMode,
              obed: obedSwitch,
              para: para,
            );
          }

          if (item is Group) {
            tiles = builder.buildGroupTiles(
              isSaturday: isSaturday,
              zamenaFull: daySchedule.zamenaFull,
              viewMode: scheduleSettings.sheduleViewMode,
              obed: obedSwitch,
              para: para,
            );
          }

          if (tiles.isEmpty) {
            return [MapEntry(para.number ?? 1, const SizedBox.shrink())];
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  child: tile,
                ),
              );
            }

            return MapEntry(para.number ?? 1, wrappedTile);
          });
        }),
      );
    }).toList();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //headers
          IntrinsicHeight(
            child: Row(
              children: widget.days.map((final DaySchedule day) {
                return Expanded(
                  child: DayScheduleHeader(
                    toggleObed: () => _toggleDayObed(day),
                    needObedSwitch: false,
                    links: day.zamenaLinks ?? [],
                    obed: obed[day] ?? false,
                    date: day.date,
                    telegramLink: day.telegramLink,
                    fullSwap: (
                      (day.zamenaFull != null)
                      && (scheduleSettings.sheduleViewMode == ScheduleViewMode.schedule)
                    ),
                  ),
                );
              }).toList()
            ),
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
                    child: AnimatedSwitcher(
                      duration: Delays.morphDuration,
                      child: IntrinsicHeight(
                        key: UniqueKey(),
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
