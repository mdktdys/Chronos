import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o3d/o3d.dart';

import 'package:zameny_flutter/config/text_styles.dart';
import 'package:zameny_flutter/features/map/providers/map_provider.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mapProvider);
    WidgetsBinding.instance.addPostFrameCallback((final _){
        ref.read(mainProvider).updateScrollDirection(ScrollDirection.forward);
    });
    return Scaffold(
      body: Stack(
        children: [
          MapBody(
            url: provider.selectedFloor,).animate(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: provider.floors.map((final floor) {
                  return InkWell(
                    onTap: () => provider.onFloorClicked(floor),
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          floor.name,
                          style: Fa.ubuntu14.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapBody extends ConsumerWidget {
  final Floor url;
  
  const MapBody({
    required this.url,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return O3D.network(
      debugLogging: true,
      src:url.url,
    );
  }
}
