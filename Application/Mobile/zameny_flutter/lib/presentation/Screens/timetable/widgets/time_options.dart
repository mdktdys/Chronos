
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/domain/Providers/time_table_provider.dart';

class TimeOptions extends ConsumerWidget {
  const TimeOptions({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(timeTableProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 38,
              child: FittedBox(
                child: Switch(
                    value: provider.saturday,
                    onChanged: (final value) => provider.toggleSaturday(),),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Суббота',
              style: TextStyle(fontFamily: 'Ubuntu'),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchOutCurve: Easing.legacy,
          switchInCurve: Easing.legacy,
          child: provider.saturday
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Без обеда',
                      style: TextStyle(fontFamily: 'Ubuntu',),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 38,
                      child: FittedBox(
                        child: Switch(
                            value: provider.obed,
                            onChanged: (final value) =>
                                provider.toggleObed(),),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
