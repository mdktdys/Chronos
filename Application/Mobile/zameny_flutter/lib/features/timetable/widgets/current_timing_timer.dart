import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/shared/providers/timer_provider.dart';

class CurrentTimingTimer extends ConsumerWidget {
  const CurrentTimingTimer({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final timings = ref.watch(timingsProvider).value;
    final timeLeft = ref.watch(timeProvider);

    final now = DateTime.now();
    final timing = timings?.where((final timing) => timing.start.isBefore(now) && timing.end.isAfter(now)).firstOrNull;

    if (
      (timing == null)
      || (now.weekday == DateTime.sunday)
    ) {
      return const SizedBox();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сейчас идет ${timing.number} пара',
                style: context.styles.ubuntuPrimaryBold24,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Осталось: $timeLeft',
                    style: context.styles.ubuntuBold18.copyWith(color: Theme.of(context).primaryColorLight.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
