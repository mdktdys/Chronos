
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/screens/schedule_days_screen.dart';
import 'package:zameny_flutter/new/widgets/skeletonized_provider.dart';

class ScheduleView extends ConsumerWidget {
  final ScrollController scrollController;

  const ScheduleView({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return SkeletonizedProvider(
      provider: scheduleProvider,
      fakeData: ScheduleNotifier.fake,
      error: (final o, final s) {
        return const Text('data');
      },
      data: (final data) {
        final empty = data.every((final DaySchedule element) => element.paras.isEmpty);

        if (empty) {
          return const SizedBox.shrink();
        }

        return ScheduleDaysWidget(days: data);
      },
    );
  }
}
