import 'package:flutter/material.dart';

import 'package:zameny_flutter/new/typedefs/on_clicked_typedef.dart';


class FrameLessButton extends StatelessWidget {
  final OnClicked onClicked;
  final bool isActive;
  final Widget child;

  const FrameLessButton({
    required this.onClicked,
    required this.child,
    this.isActive = false,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 
      isActive
        ? 0.10
        : 0.01);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: color,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: onClicked,
          child: child,
        ),
      ),
    );
  }
}
