
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class ScheduleViewSettingsWidget extends ConsumerWidget {
  const ScheduleViewSettingsWidget({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleSettingsProvider);
    final notifier = ref.watch(scheduleSettingsProvider.notifier);

    return Row(
    spacing: 8,
      children: [
        SizedBox(
          height: 38,
          child: FittedBox(
            child: Switch(
              value: provider.isShowZamena,
              onChanged: (final value) {
                provider.isShowZamena = !provider.isShowZamena;
                notifier.notify();
              },
          ),
        )),
        Text(
          'С заменами',
          style: context.styles.ubuntu.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
