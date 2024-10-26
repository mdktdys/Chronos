import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';

class ToggleWeekButton extends StatelessWidget {
  final bool next;
  const ToggleWeekButton({super.key, required this.next});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    return Bounceable(
      onTap: () {
        provider.toggleWeek(next ? 1 : -1, context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
           ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            next ? Icons.arrow_right_rounded : Icons.arrow_left_rounded,
            color: Theme.of(context).colorScheme.surface,
            size: 36,
          ),
        ),
      ),
    );
  }
}
