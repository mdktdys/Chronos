import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class ZamenaScreenHeader extends StatelessWidget {
  const ZamenaScreenHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Замены',
          style: context.styles.ubuntuPrimaryBold24,
        ),
      ],
    );
  }
}
