
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_header.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/new/widgets/skeletonized_provider.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class ScheduleDaysWidget extends StatelessWidget {
  final List<DaySchedule> days;

  const ScheduleDaysWidget({
    required this.days,
    super.key,
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

    // return AdaptiveLayout(
    //   mobile: () {
    //     return Column(
    //       spacing: 10,
    //       children: [
    //         ...days.map((final day) {
    //           return DayScheduleWidget(daySchedule: day);
    //         }),
    //         const SizedBox(height: 100),
    //       ]
    //     );
    //   }(),
    //   desktop: Expanded(child: ScheduleViewGrid(days: days)),
    // );
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
    final scheduleSettings = ref.watch(scheduleSettingsProvider);

    return Column(
      children: [
        //headers
        Row(
          children: widget.days.map((final DaySchedule day) {
            final bool needObedSwitch = day.paras.any((final Paras para) => para.number! > 3) && day.paras.isNotEmpty;

            return Expanded(
              child: DayScheduleHeader(
                toggleObed: () => _toggleDayObed(day),
                needObedSwitch: needObedSwitch,
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
        Expanded(
          child: SkeletonizedProvider<List<LessonTimings>>(
            provider: timingsProvider,
            fakeData: () => [],
            data: (final timings) {
              return Column(
                children: timings.map((final LessonTimings timings) {
                  return Expanded(
                    child: Row(
                      children: widget.days.map((final DaySchedule day) {
                        return const Expanded(
                          child: Text('data')
                        );
                      }).toList(),
                    ),
                  );
                }).toList()
              );
            },
            error: (final e,final o) {
              return const Text('data');
            },
          ),
        ),
      ],
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
