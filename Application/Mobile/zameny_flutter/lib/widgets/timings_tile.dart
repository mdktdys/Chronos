import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/modules/timetable/time_table_provider.dart';

class TimingTile extends ConsumerWidget {
  final LessonTimings timing;

  const TimingTile({
    required this.timing,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(timeTableNotifierProvider);

    final DateTime startTime = provider.saturday
        ? timing.saturdayStart
        : provider.obed
            ? timing.obedStart
            : timing.start;

    final DateTime endTime = provider.saturday
        ? timing.saturdayEnd
        : provider.obed
            ? timing.obedEnd
            : timing.end;

    final bool isGreen = provider.obed && timing.obedStart.toFormattedTime() != timing.start.toFormattedTime();

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withAlpha(25),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Container(
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                timing.number.toString(),
                style: context.styles.ubuntu20,
              ),
            ),
          ),
          const SizedBox(width: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            switchInCurve: Easing.legacy,
            child: Text(
              key: ValueKey(
                provider.saturday
                  ? UniqueKey()
                  : startTime.toFormattedTime(),
              ),
              '${startTime.toFormattedTime()}-${endTime.toFormattedTime()}',
              style: context.styles.ubuntu20.copyWith(
                color: provider.saturday
                  ? null
                  : isGreen
                    ? Colors.green
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
