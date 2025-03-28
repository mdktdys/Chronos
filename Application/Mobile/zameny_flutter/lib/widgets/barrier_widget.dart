import 'package:flutter/material.dart';

import 'package:flutter_portal/flutter_portal.dart';


class Barrier extends StatelessWidget {
  const Barrier({
    required this.onClose, required this.visible, required this.child, super.key,
  });

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(final BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClose,
        child: const SizedBox(),),
      child: child,
    );
  }
}
