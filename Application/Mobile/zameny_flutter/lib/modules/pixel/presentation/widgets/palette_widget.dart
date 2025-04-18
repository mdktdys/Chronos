import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/modules/pixel/presentation/widgets/palette_color_widget.dart';
import 'package:zameny_flutter/modules/pixel/providers/pixel_battle_provider.dart';
import 'package:zameny_flutter/widgets/base_blank_widget.dart';

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
