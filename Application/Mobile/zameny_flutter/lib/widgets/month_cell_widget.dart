import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';

class MonthCell extends ConsumerWidget {
  final DateRangePickerCellDetails details;
  final bool hasZamena;
  final DateTime? selectedDate;

  const MonthCell({
    required this.selectedDate,
    required this.details,
    required this.hasZamena,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool chillday = details.date.weekday == 7;

    final bool isSelected = selectedDate != null
      ? details.date.sameDate(selectedDate!)
      : false;

    final bool isToday = details.date.day == DateTime.now().day &&
      details.date.month == DateTime.now().month &&
      DateTime.now().year == details.date.year;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: AnimatedContainer(
            duration: Delays.morphDuration,
            padding: const EdgeInsets.all(8),
            decoration: !chillday
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: !isSelected
                    ? theme.colorScheme.surfaceContainerHighest
                    : theme.colorScheme.primary.withValues(alpha: 0.6),
                )
              : null,
            child: Center(child: Text(details.date.day.toString())),
          ),
        ),
        isToday
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.primary,),
              ),
            )
          : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: Delays.morphDuration,
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: hasZamena ? Colors.green : Colors.transparent,
              shape: BoxShape.circle,
            )
          ),
        )
      ],
    );
  }
}
