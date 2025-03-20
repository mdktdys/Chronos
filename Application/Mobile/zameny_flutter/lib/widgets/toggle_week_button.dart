import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';

class ToggleWeekButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool next;

  const ToggleWeekButton({
    required this.onTap,
    required this.next,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Bounceable(
      onTap: onTap,
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
