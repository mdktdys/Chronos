import 'package:flutter/material.dart';

import 'package:zameny_flutter/modules/schedule/presentation/widgets/dayschedule_default_widget.dart';
import 'package:zameny_flutter/models/day_schedule_model.dart';



class ScheduleViewList extends StatelessWidget {
  final List<DaySchedule> days;

  const ScheduleViewList({
    required this.days,
    super.key
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
