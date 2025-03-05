import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/new/config/delays.dart';

final layoutProvider = StateProvider<Platform>((final ref) => Platform.mobile);

class AdaptiveLayout extends ConsumerWidget {
  final Widget Function() mobile;
  final Widget Function()? tablet;
  final Widget Function() desktop;

  const AdaptiveLayout({
    required this.desktop,
    required this.mobile,
    this.tablet,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    Widget? child;

    final platform = (width >= Constants.maxWidthDesktop)
        ? Platform.desktop
        : (width >= 600)
            ? Platform.tablet
            : Platform.mobile;

    if (platform == Platform.desktop) {
      child = desktop();
    } else if (platform == Platform.tablet) {
      child = tablet?.call() ?? mobile();
    }
    
    return AnimatedSwitcher(
      duration: Delays.morphDuration,
      child: child ?? mobile(),
    );
  }
}

enum Platform {
  desktop,
  mobile,
  tablet,
}
