import 'package:flutter/material.dart';

import 'package:zameny_flutter/models/day_schedule_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';



class ScheduleViewList extends StatelessWidget {
  final List<DaySchedule> days;

  const ScheduleViewList({
    required this.days,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        spacing: 10,
        children: [
          ...days.map((final day) {
            return DayScheduleWidget(daySchedule: day);
          }),
          const SizedBox(height: 100),
        ]
      ),
    );
  }
}
