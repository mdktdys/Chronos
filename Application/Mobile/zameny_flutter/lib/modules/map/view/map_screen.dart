import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/modules/map/providers/map_provider.dart';
import 'package:zameny_flutter/modules/map/widgets/map_body.dart';
import 'package:zameny_flutter/modules/map/widgets/map_floor_selector.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mapProvider);
    WidgetsBinding.instance.addPostFrameCallback((final _){
      ref.read(mainProvider).updateScrollDirection(ScrollDirection.forward);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            MapBody(
              url: provider.selectedFloor,
            ).animate(
              effects: [
                const FadeEffect(
                  begin: 0,
                  end: 1,
                ),
                const MoveEffect(
                  curve: Curves.easeOutCubic,
                  begin: Offset(0, 40),
                  end: Offset(0, 0),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: MapFloorSelector()
            ),
          ],
        ),
      ),
    );
  }
}
