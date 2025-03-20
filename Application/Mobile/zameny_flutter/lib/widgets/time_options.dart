import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/timetable/timetable_controller.dart';
import 'package:zameny_flutter/new/providers/time_table_provider.dart';

class TimeOptions extends ConsumerWidget {
  const TimeOptions({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final TimetableController controller = ref.watch(timetableControllerProvider);
    final TimeTableState viewModel = ref.watch(timeTableNotifierProvider);

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
                  value: viewModel.saturday,
                  onChanged: (final bool _) => controller.toggleSaturday()
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Суббота',
              style: context.styles.ubuntu,
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchOutCurve: Easing.legacy,
          switchInCurve: Easing.legacy,
          child: viewModel.saturday
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Без обеда',
                    style: context.styles.ubuntu,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 38,
                    child: FittedBox(
                      child: Switch(
                        value: viewModel.obed,
                        onChanged: (final bool _) => controller.toggleObed(),
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
