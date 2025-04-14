import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:repaint/repaint.dart';

class PixelPainter implements RePainter {
  final double width;
  final double height;
  final Map<Offset, Color> pixels;
  final double pixelSize;
  final int gridSize;
  final Offset? selectedCell;
  final Function(Offset) onCellClicked;
  final double padding;

  PixelPainter(
    this.pixels,
    this.pixelSize,
    this.gridSize,
    this.selectedCell,
    this.onCellClicked,
    this.width,
    this.height,
    this.padding
  );


  // @override
  // void paint(final Canvas canvas, final Size size) {
  //   final paint = Paint();

  //   // Рисуем все пиксели
  //   pixels.forEach((final key, final color) {
  //     final parts = key.split('_');
  //     final x = int.parse(parts[0]);
  //     final y = int.parse(parts[1]);

  //     paint.color = color;
  //     canvas.drawRect(
  //       Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
  //       paint,
  //     );
  //   });

  //   // Рисуем сетку
  //   paint.color = Colors.grey.withValues(alpha: 0.1);
  //   paint.style = PaintingStyle.stroke;

  //   for (int i = 0; i <= gridSize; i++) {
  //     final offset = i * pixelSize;
  //     canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
  //     canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
  //   }

  //   // Рисуем выбранную ячейку
  //   if (selectedCell != null && selectedCell!.dx >= 0 && selectedCell!.dy >= 0) {
  //     paint.color = Colors.red;
  //     paint.style = PaintingStyle.stroke;
  //     paint.strokeWidth = 2;

  //     canvas.drawRect(
  //       Rect.fromLTWH(
  //         selectedCell!.dx * pixelSize,
  //         selectedCell!.dy * pixelSize,
  //         pixelSize,
  //         pixelSize,
  //       ),
  //       paint,
  //     );
  //   }
  // }

  // @override
  // bool shouldRepaint(covariant final PixelPainter oldDelegate) =>
  //     oldDelegate.pixels != pixels ||
  //     oldDelegate.selectedCell != selectedCell;

  @override
  void lifecycle(final AppLifecycleState state) {
    return;
  }

  @override
  void mount(covariant final RePaintBox box, final PipelineOwner owner) {
    return;
  }

  @override
  bool get needsPaint => true;

  @override
  void onPointerEvent(final PointerEvent event) {
    if (event is PointerUpEvent) {
      onCellClicked(Offset(
        (event.localPosition.dx / pixelSize).floorToDouble() - 1,
        (event.localPosition.dy / pixelSize).floorToDouble() - 1
      ));
    }
  }

  @override
  void unmount() {
    return;
  }

  @override
  void update(covariant final RePaintBox box, final Duration elapsed, final double delta) {
    return;
  }
  
  @override
  void paint(covariant final RePaintBox box, final PaintingContext context) {
    final double centerX = (width - gridSize * pixelSize) / 2;
    final double centerY = (height - gridSize * pixelSize) / 2;
    
    final paint = Paint();

    pixels.forEach((final key, final color) {
      final x = key.dx;
      final y = key.dy;

      paint.color = color;
      context.canvas.drawRect(
        Rect.fromLTWH(x * pixelSize + centerX, y * pixelSize + centerY, pixelSize, pixelSize),
        paint,
      );
    });

    paint.color = Colors.grey.withValues(alpha: 0.1);
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i <= gridSize; i++) {
      final offset = i * pixelSize;
      // vertical line
      context.canvas.drawLine(Offset(offset + centerX, padding), Offset(offset + centerX, gridSize * pixelSize + 20), paint);
      // horizontal line
      context.canvas.drawLine(Offset(padding, offset + centerY), Offset(gridSize * pixelSize + 20, offset + centerY), paint);
    }
  }
}
