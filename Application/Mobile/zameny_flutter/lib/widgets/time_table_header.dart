import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class TimeTableHeader extends StatelessWidget {
  const TimeTableHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Звонки',
          textAlign: TextAlign.center,
          style: context.styles.ubuntuPrimaryBold24,
        ),
      ],
    );
  }
}
