import 'package:flutter/material.dart';

import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class SwapedParaTileWidget extends StatelessWidget {
  const SwapedParaTileWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
        border: DashedBorder.all(
          dashLength: 10,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Text(
              'Пара снята',
              style: context.styles.ubuntu20.copyWith(color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
