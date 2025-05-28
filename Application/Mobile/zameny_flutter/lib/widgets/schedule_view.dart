
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/shared/domain/models/day_schedule_model.dart';
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
        error: (final Object o, final StackTrace s) {
          return Text(
            'Ошибка',
            style: context.styles.ubuntu14,
          );
        },
        data: (final List<DaySchedule> data) {
          final bool empty = data.every((final DaySchedule element) => element.paras.isEmpty);
          final AsyncValue<List<DaySchedule>> provider = ref.watch(scheduleProvider);

          if (
            empty &&
            !provider.isLoading
          ) {
            return const SizedBox.shrink();
          }
      
          return ScheduleDaysWidget(days: data);
        },
      ),
    );
  }
}
