import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repaint/repaint.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/pixel/pixel_painter.dart';
import 'package:zameny_flutter/modules/pixel/providers/pixel_battle_provider.dart';
import 'package:zameny_flutter/widgets/base_blank_widget.dart';

class PixelBattleScreen extends ConsumerStatefulWidget {
  const PixelBattleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PixelBattleScreenState();
}

class _PixelBattleScreenState extends ConsumerState<PixelBattleScreen> {
  final double pixelSize = 20.0;
  final int gridSize = 80;
  final TransformationController _transformationController = TransformationController();
  bool dragging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final timeStamp) {
      final width = MediaQuery.of(context).size.width;
      _transformationController.value = Matrix4.identity();
      _transformationController.value.translate((width - gridSize * pixelSize) / 2);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final pixels = ref.watch(pixelProvider);
    final notifier = ref.read(pixelProvider.notifier);

    return Stack(
      children: [
        InteractiveViewer(
          maxScale: 1000,
          minScale: 0.0001,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(1200),
          onInteractionUpdate: (final details) {
            dragging = true;
          },
          onInteractionEnd: (final details) {
            dragging = false;
          },
          transformationController: _transformationController,
          child: SizedBox(
            width: gridSize * pixelSize + 40,
            height: gridSize * pixelSize + 40,
            child: RePaint(
              painter: PixelPainter(
                pixels,
                pixelSize,
                gridSize,
                notifier.selectedCell,
                _onCellClicked,
                gridSize * pixelSize + 40,
                gridSize * pixelSize + 40,
                20
              )
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(20),
        //   child: Align(
        //     alignment: Alignment.topCenter,
        //     child: ConstrainedBox(
        //       constraints: const BoxConstraints(maxWidth: 500),
        //       child: const PaletteWidget(),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: BaseBlank(
                child: Text(
                  'Сейчас недоступно',
                  style: context.styles.ubuntu16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void _onCellClicked(final Offset position) {
    return;

    if (position.dx < 0 || position.dy < 0) {
      return;
    }

    if (position.dx >= gridSize || position.dy >= gridSize) {
      return;
    }

    if (dragging) {
      return;
    }

    ref.read(pixelProvider.notifier).placePixel(position, pixelSize);
  }
}
