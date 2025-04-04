
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/new/providers/day_schedules_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/new/screens/schedule_days_screen.dart';
import 'package:zameny_flutter/widgets/skeletonized_provider.dart';

class ScheduleView extends ConsumerWidget {
  final ScrollController scrollController;

  const ScheduleView({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Screenshot(
      controller: ref.watch(scheduleSettingsProvider.notifier).screenShotController,
      child: SkeletonizedProvider(
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
      ),
    );
  }
}
