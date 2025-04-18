import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';

import 'package:zameny_flutter/config/delays.dart';

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
