import 'package:flutter/material.dart';

import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class SettingsVersionBlock extends StatelessWidget {
  const SettingsVersionBlock({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Версия: 18.04.24 билд: 1.1 TEST WEB',
            textAlign: TextAlign.start,
            style: context.styles.monospace12
          ),
        ],
      ),
    );
  }
}
