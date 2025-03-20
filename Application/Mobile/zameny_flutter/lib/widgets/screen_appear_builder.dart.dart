import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/new/providers/main_provider.dart';

class ScreenAppearBuilder extends ConsumerWidget {
  final bool showNavbar;
  final Widget child;
  
  const ScreenAppearBuilder({
    required this.child,
    this.showNavbar = false,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if(showNavbar) {
      WidgetsBinding.instance.addPostFrameCallback((final _){ref.read(mainProvider).updateScrollDirection(ScrollDirection.forward);});
    }
    return child.animate(
      effects: [
        const FadeEffect(
          duration: Duration(milliseconds: 100),
          end: 1.0,
          begin: 0.0
        ),
      ]
    );
  }
}
