import 'package:flutter/material.dart';

class BaseBlank extends StatelessWidget {
  final Widget child;

  const BaseBlank({
    required this.child,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: child
    );
  }
}
