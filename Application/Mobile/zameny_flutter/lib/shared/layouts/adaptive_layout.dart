import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';

class AdaptiveLayout extends ConsumerWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AdaptiveLayout({
    required this.desktop,
    required this.mobile,
    this.tablet,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        if (constraints.maxWidth >= Constants.maxWidthDesktop) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
} 
