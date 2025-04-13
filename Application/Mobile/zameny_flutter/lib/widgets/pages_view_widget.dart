import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repaint/repaint.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/modules/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/modules/settings/settings_screen.dart';
import 'package:zameny_flutter/modules/timetable/time_table_screen.dart';
import 'package:zameny_flutter/modules/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/new/providers/pixel_battle_provider.dart';
import 'package:zameny_flutter/widgets/base_blank_widget.dart';

class PagesViewWidget extends ConsumerWidget {
  const PagesViewWidget({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);

    return PageView(
      onPageChanged: (final int value) => provider.pageChanged(value, context),
      physics: !provider.pageViewScrollEnabled
        ? const NeverScrollableScrollPhysics()
        : null,
      controller: provider.pageController,
      children: const [
        TimeTableScreen(),
        ScheduleScreen(),
        
        ZamenaScreen(),
        // MapScreen(),
        SettingsScreen(),
        PixelBattleScreen(),
      ],
    );
  }
}

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
      _transformationController.value = Matrix4.identity();
      _transformationController.value.translate(pixelSize * gridSize / 2);
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
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const PaletteWidget(),
            ),
          ),
        ),
      ],
    );
  }
  
  void _onCellClicked(final Offset position) {
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

class PaletteWidget extends ConsumerStatefulWidget {
  const PaletteWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaletteWidgetState();
}

class _PaletteWidgetState extends ConsumerState<PaletteWidget> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.white,
    Colors.black,
    Colors.grey,
  ];

  @override
  Widget build(final BuildContext context) {
    final Color? selectedColor = ref.watch(pixelProvider.notifier).selectedColor;
    
    return BaseBlank(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: colors.map((final Color color) => ColorBlank(
            selected: selectedColor != null && selectedColor == color,
            color: color,
            onClicked: () {
              ref.read(pixelProvider.notifier).selectedColor = color;
              setState(() {});
            },
          )).toList(),
        ),
      ),
    );
  }
}

class ColorBlank extends StatelessWidget {
  final Color color;
  final VoidCallback onClicked;
  final bool selected;

  const ColorBlank({
    required this.onClicked,
    required this.selected,
    required this.color,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Bounceable(
      onTap: onClicked,
      child: AnimatedContainer(
        duration: Delays.morphDuration,
        width: 50 + (selected ? 10 : 0),
        height: 50 + (selected ? 10 : 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class PixelPainter implements RePainter {
  final double width;
  final double height;
  final Map<String, Color> pixels;
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
    // TODO: implement lifecycle
  }

  @override
  void mount(covariant final RePaintBox box, final PipelineOwner owner) {
    // TODO: implement mount
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
    // TODO: implement unmount
  }

  @override
  void update(covariant final RePaintBox box, final Duration elapsed, final double delta) {
    
  }
  
  @override
  void paint(covariant final RePaintBox box, final PaintingContext context) {
    final double centerX = (width - gridSize * pixelSize) / 2;
    final double centerY = (height - gridSize * pixelSize) / 2;
    
    final paint = Paint();

    pixels.forEach((final key, final color) {
      final parts = key.split('_');
      final x = int.parse(parts[0]);
      final y = int.parse(parts[1]);

      paint.color = color;
      context.canvas.drawRect(
        Rect.fromLTWH(x * pixelSize + centerX, y * pixelSize + centerY, pixelSize, pixelSize),
        paint,
      );
    });

    // Рисуем сетку
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
