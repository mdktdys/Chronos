import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portal/flutter_portal.dart';

class Modal extends StatefulWidget {
  
  const Modal({
    required this.visible,
    required this.onClose,
    required this.modal,
    required this.child,
    super.key,
  });

  final Widget child;
  final Widget modal;
  final bool visible;
  final VoidCallback onClose;

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, value: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PortalTarget(
      visible: widget.visible,
      closeDuration: const Duration(seconds: 1),
      anchor: const Aligned(
        follower: Alignment.topRight,
        target: Alignment.bottomLeft,
      ),
      portalFollower: Animate(
        controller: controller,
        value: 0.05,
        effects: const [
          FadeEffect(duration: Duration(milliseconds: 250)),
          ScaleEffect(
            duration: Duration(milliseconds: 250),
            alignment: Alignment.topRight,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
        ],
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: widget.modal,
        ),
      ),
      child: widget.child,
    );
  }
}
