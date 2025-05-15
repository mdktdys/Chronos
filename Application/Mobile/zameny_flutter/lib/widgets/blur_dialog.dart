import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/widgets/barrier_widget.dart';

class BlurDialog extends StatefulWidget {
  final Widget Function(Function) popup;

  const BlurDialog({
    required this.popup,
    super.key
  });

  @override
  State<BlurDialog> createState() => _BlurDialogState();
}

class _BlurDialogState extends State<BlurDialog> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  bool opened = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, value: 0, duration: Delays.morphDuration);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onClose() async {
    setState(() => opened = false);
    controller.reverse();
    opened = false;
  }

  @override
  Widget build(final BuildContext context) {
    return Barrier(
      onClose: _onClose,
      visible: opened,
      child: PortalTarget(
        visible: opened,
        closeDuration: const Duration(seconds: 1),
        anchor: const Aligned(
          follower: Alignment.topRight,
          target: Alignment.bottomLeft,
        ),
        portalFollower: Animate(
          controller: controller,
          value: 0.05,
          effects: const [
            FadeEffect(
              duration: Duration(milliseconds: 250)
            ),
            ScaleEffect(
              duration: Duration(milliseconds: 250),
              alignment: Alignment.topRight,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
          ],
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: widget.popup(_onClose)
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          onPressed: () {
            controller.forward().orCancel;
            setState(() => opened = true);
          },
        ),
      ),
    );
  }
}
