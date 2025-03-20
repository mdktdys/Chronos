import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;

  const BaseContainer({
    required this.child,
    this.padding,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      child: child,
    );
  }
}
