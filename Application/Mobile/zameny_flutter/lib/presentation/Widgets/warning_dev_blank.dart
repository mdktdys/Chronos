import 'package:flutter/material.dart';

import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class WarningDevBlank extends StatelessWidget {
  const WarningDevBlank({super.key,});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠️ Фича в деве',
            style: context.styles.ubuntuInverseSurfaceBold16,
          ),
          const SizedBox(height: 5),
          Text(
            'Данные могут быть некорректны, для уверенности свертесь с файлом замен',
            style: context.styles.ubuntu400,
          ),
        ],
      ),
    );
  }
}
