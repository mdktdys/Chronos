
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/map/providers/map_provider.dart';

class MapFloorSelector extends ConsumerWidget {
  const MapFloorSelector({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mapProvider);

    return ClipRRect(
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
                  style: context.styles.ubuntuInverseSurface16,
                ),
              ),
            ),
          );
        }).toList(),
      )
    );
  }
}
