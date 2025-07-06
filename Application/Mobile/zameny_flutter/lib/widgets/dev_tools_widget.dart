import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/providers/main_provider.dart';
import 'package:zameny_flutter/widgets/base_blank_widget.dart';

class DevTools extends ConsumerWidget {
  const DevTools({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Прочее',
            style: context.styles.ubuntuPrimaryBold20,
          ),
        ),
        const SizedBox(height: 5),
        BaseBlank(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Партиклы',
                style: context.styles.ubuntuBold14,
              ),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                      value: provider.falling,
                      onChanged: (final value) => provider.switchFalling(),
                    ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        BaseBlank(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DEV',
                style: context.styles.ubuntuBold14,
              ),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                    value: provider.isDev,
                    onChanged: (final value) => provider.switchDev(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
