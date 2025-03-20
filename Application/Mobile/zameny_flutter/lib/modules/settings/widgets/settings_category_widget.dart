import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class SettingsCategory extends StatelessWidget {
  final List<Widget> tiles;
  final String category;
  final double spacing;

  const SettingsCategory({
    required this.category,
    required this.tiles,
    this.spacing = 10,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: [
        Text(
          category,
          style: context.styles.ubuntuPrimaryBold20,
        ),
        ...tiles
      ],
    );
  }
}
