import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o3d/o3d.dart';

import 'package:zameny_flutter/modules/map/providers/map_provider.dart';

class MapBody extends ConsumerWidget {
  final Floor url;

  const MapBody({
    required this.url,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return O3D.network(
      src: url.url,
      cameraOrbit: CameraOrbit(
        -45,
        45,
        15
      ),
    );
  }
}
