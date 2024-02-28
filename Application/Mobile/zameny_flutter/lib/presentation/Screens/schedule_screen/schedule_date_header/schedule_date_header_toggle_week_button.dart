import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zameny_flutter/presentation/Providers/schedule_provider.dart';

class ToggleWeekButton extends StatelessWidget {
  final bool next;
  const ToggleWeekButton({super.key, required this.next});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    return Container(
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: GestureDetector(
        onTap: () {
          provider.toggleWeek(next ? 1 : -1, context);
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            next ? Icons.arrow_right_rounded : Icons.arrow_left_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
