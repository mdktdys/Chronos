import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/new/config/delays.dart';
import 'package:zameny_flutter/new/enums/platforms_enum.dart';
import 'package:zameny_flutter/new/enums/schedule_view_modes.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';
import 'package:zameny_flutter/new/screens/responsive/schedule_days_grid.dart';
import 'package:zameny_flutter/new/screens/responsive/schedule_days_list.dart';
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
