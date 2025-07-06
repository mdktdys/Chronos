import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfall/flutterfall.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/providers/main_provider.dart';

class SnowFall extends ConsumerWidget {
  const SnowFall({
    super.key,
  });

  List<String>? _defineFallImages() {
    final DateTime date = DateTime.now();
    if (date.betweenIgnoreYear(DateTime(2024, 10), DateTime(2024, 11))) {
      return [Images.autumnLeaves];
    }
    if (date.betweenIgnoreYear(DateTime(2024, 11), DateTime(2025, 2, 28))) {
      return [Images.snowflake];
    }
    return null;
  }


  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final List<String>? images = _defineFallImages();
    return (
      images == null
      || (!ref.watch(mainProvider).falling)
    )
    ? const SizedBox()
    : const IgnorePointer(
      child: RepaintBoundary(
        child: FlutterFall(
          totalParticles: 25,
          particleImages: [Images.snowflake],
        ),
      ),
    );
  }
}
