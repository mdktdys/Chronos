import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ToggleWeekButton extends StatelessWidget {
  final bool next;
  final Function(int way, BuildContext context) onTap;
  const ToggleWeekButton({super.key, required this.next, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        onTap.call(next ? 1 : -1, context);
        // provider.toggleWeek(next ? 1 : -1, context);
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
