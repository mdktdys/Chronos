
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/modules/timetable/time_table_provider.dart';
import 'package:zameny_flutter/shared/tools.dart';

class TimingTile extends ConsumerWidget {
  final LessonTimings timing;

  const TimingTile({
    required this.timing,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(timeTableNotifierProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: 80,
      decoration: BoxDecoration(
        borderRadius:const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      child: Row(
          children: [
            const SizedBox(width: 20),
            Container(
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary,
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
                  key: ValueKey(provider.saturday ? UniqueKey() :getTimeFromDateTime(provider.obed ? timing.obedStart : timing.start)),
                  '${getTimeFromDateTime( provider.saturday ? timing.saturdayStart : provider.obed ? timing.obedStart : timing.start)}-${getTimeFromDateTime(provider.saturday ? timing.saturdayEnd :provider.obed ? timing.obedEnd : timing.end)}',
                  style: context.styles.ubuntu20.copyWith(color: provider.saturday
                    ? null
                    : provider.obed
                      ? getTimeFromDateTime(provider.obed
                        ? timing.obedStart
                        : timing.start
                      ) !=
                        getTimeFromDateTime(!provider.obed
                          ? timing.obedStart
                          : timing.start,
                        )
                          ? Colors.green
                          : null
                      : null,
                ),
              ),
            ),
          ],
        ),
    );
  }
}
