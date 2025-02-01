
import 'package:flutter/material.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/new/models/day_schedule.dart';

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
  }
}
