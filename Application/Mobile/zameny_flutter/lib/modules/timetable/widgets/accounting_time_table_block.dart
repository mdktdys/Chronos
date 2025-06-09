import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class AccountingTimeTableBlock extends ConsumerWidget {
  const AccountingTimeTableBlock({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          'Бухгалтерия',
          style: context.styles.ubuntuPrimaryBold18,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ПН - ЧТ 8:00-17:00',
                style: context.styles.ubuntu,
                textAlign: TextAlign.left,
              ),
              Text(
                'ПТ 9:00-17:00',
                style: context.styles.ubuntu,
                textAlign: TextAlign.left,
              ),
              Text(
                'Обед 13:00-14:00',
                style: context.styles.ubuntu,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        )
      ],
    );
  }
}
