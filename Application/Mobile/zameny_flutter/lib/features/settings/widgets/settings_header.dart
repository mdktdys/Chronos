import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Настроечки',
          style: context.styles.ubuntuPrimaryBold24
        ),
      ],
    );
  }
}
