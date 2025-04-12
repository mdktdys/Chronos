import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/modules/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/modules/settings/settings_screen.dart';
import 'package:zameny_flutter/modules/timetable/time_table_screen.dart';
import 'package:zameny_flutter/modules/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/new/providers/pixel_battle_provider.dart';

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
        PixelBattleScreen(),
        ZamenaScreen(),
        // MapScreen(),
        SettingsScreen(),
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
  final int gridSize = 50; // 100x100 "пикселей"

  @override
  Widget build(final BuildContext context) {
    final pixels = ref.watch(pixelProvider);
     final notifier = ref.read(pixelProvider.notifier);

    return GestureDetector(
      onTapUp: (final details) {
        final position = details.localPosition;
        notifier.placePixel(position, pixelSize);
      },
      onPanUpdate: (final details) {
        notifier.updateSelectedCell(details.localPosition, pixelSize);
      },
      onPanStart: (final details) {
        notifier.updateSelectedCell(details.localPosition, pixelSize);
      },
      onPanEnd: (final _) {
        notifier.updateSelectedCell(const Offset(-1, -1), pixelSize); // убираем выделение
      },
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: CustomPaint(
          size: Size(gridSize * pixelSize, gridSize * pixelSize),
          painter: PixelPainter(
            pixels,
            pixelSize,
            gridSize,
            notifier.selectedCell,
          ),
        ),
      )
    );
  }
}

class PixelPainter extends CustomPainter {
  final Map<String, Color> pixels;
  final double pixelSize;
  final int gridSize;
  final Offset? selectedCell;

  PixelPainter(this.pixels, this.pixelSize, this.gridSize, this.selectedCell);

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint();

    // Рисуем все пикселиasdasdasdaas
    pixels.forEach((final key, final color) {
      final parts = key.split('_');
      final x = int.parse(parts[0]);
      final y = int.parse(parts[1]);

      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint,
      );
    });

    // Рисуем сетку
    paint.color = Colors.grey;
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i <= gridSize; i++) {
      final offset = i * pixelSize;
      canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
      canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }

    // Рисуем выбранную ячейку
    if (selectedCell != null && selectedCell!.dx >= 0 && selectedCell!.dy >= 0) {
      paint.color = Colors.red;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;

      canvas.drawRect(
        Rect.fromLTWH(
          selectedCell!.dx * pixelSize,
          selectedCell!.dy * pixelSize,
          pixelSize,
          pixelSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant final PixelPainter oldDelegate) =>
      oldDelegate.pixels != pixels ||
      oldDelegate.selectedCell != selectedCell;
}
