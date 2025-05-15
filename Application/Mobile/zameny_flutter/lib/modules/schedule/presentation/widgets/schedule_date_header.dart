import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as sf;

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';
import 'package:zameny_flutter/widgets/toggle_week_button.dart';


class DateHeader extends ConsumerWidget {
  const DateHeader({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 5,
        children: [
          ToggleWeekButton(
            next: false,
            onTap: () {
              ref.read(navigationDateProvider.notifier).toggleWeek(-7);
            }
          ),
          const Expanded(child: DateHeaderDatePicker()),
          ToggleWeekButton(
            next: true,
            onTap: () {
              ref.read(navigationDateProvider.notifier).toggleWeek(7);
            }
          ),
        ],
      ),
    );
  }
}

class DateHeaderDatePicker extends ConsumerStatefulWidget {
  const DateHeaderDatePicker({super.key});

  @override
  ConsumerState<DateHeaderDatePicker> createState() => _DateHeaderDatePickerState();
}

class _DateHeaderDatePickerState extends ConsumerState<DateHeaderDatePicker> {
  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(final BuildContext ctx) {
    final DateTime navigationDate = ref.watch(navigationDateProvider);

    final int currentWeekNumber = ((navigationDate.difference(Constants.septemberFirst).inDays + Constants.septemberFirst.weekday) ~/ 7) + 1;
    final int todayWeekNumber = ((DateTime.now().difference(Constants.septemberFirst).inDays + Constants.septemberFirst.weekday) ~/ 7) + 1;

    final bool isCurrentWeek = todayWeekNumber == currentWeekNumber;

    final DateTime date = DateTime.now();

    String title = '';
    if (date.month >= 9) {
      title = 'I Семестр ${date.year}/${date.year + 1}';
    } else if (date.month >= 1 && date.month <= 6) {
      title = 'II Семестр ${date.year - 1}/${date.year}';
    } else {
      title = 'Лето';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: ctx,
              builder: (final BuildContext context) {
                return Center(
                  child: Container(
                    width: 380,
                    height: 450,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: sf.SfDateRangePicker(
                      initialSelectedDate: selectedDate,
                      cancelText: 'Закрыть',
                      confirmText: 'Ок',
                      selectionColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      initialDisplayDate: DateTime.now(),
                      showActionButtons: true,
                      allowViewNavigation: false,
                      onCancel: () => Navigator.of(context).pop(),
                      onSubmit: (final p0) {
                        if (p0 == null) {
                          Navigator.of(context).pop();
                          return;
                        }

                        final DateTime time = (p0 as DateTime);
                        ref.watch(navigationDateProvider.notifier).state = time;
                        Navigator.of(context).pop();
                      },
                      monthViewSettings: const sf.DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.monday),
                      showNavigationArrow: true,
                      navigationDirection: sf.DateRangePickerNavigationDirection.vertical,
                      navigationMode: sf.DateRangePickerNavigationMode.scroll,
                      headerStyle: const sf.DateRangePickerHeaderStyle(backgroundColor: Colors.transparent,),
                      onSelectionChanged: (final dateRangePickerSelectionChangedArgs) {
                        selectedDate = dateRangePickerSelectionChangedArgs.value;
                        setState(() {});
                      },
                      cellBuilder: (final context, final cellDetails) {
                        return MonthCell(
                          selectedDate: selectedDate,
                          details: cellDetails,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: ctx.styles.ubuntuInverseSurfaceBold16,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      'Неделя $currentWeekNumber',
                      style: ctx.styles.ubuntuInverseSurfaceBold16,
                    ),
                    CurrentNavigationWeekBadge(isCurrentWeek: isCurrentWeek),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentNavigationWeekBadge extends ConsumerWidget {
  final bool isCurrentWeek;

  const CurrentNavigationWeekBadge({
    required this.isCurrentWeek,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    TextStyle textStyle = context.styles.ubuntuCanvasColorBold14;

    if (!isCurrentWeek) {
      textStyle = textStyle.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.4), fontSize: 14);
    }

    return Bounceable(
      onTap: !isCurrentWeek
        ? ref.read(navigationDateProvider.notifier).reset
        : null,
      child: AnimatedContainer(
        duration: Delays.morphDuration,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isCurrentWeek
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        ),
        child: isCurrentWeek
          ? Text(
            'Текущая',
            style: textStyle,
          )
          : SvgPicture.asset(
            Images.reverse,
            colorFilter: ColorFilter.mode(textStyle.color!, BlendMode.srcIn),
          ),
      ),
    );
  }
}

class MonthCell extends ConsumerWidget {
  final sf.DateRangePickerCellDetails details;
  final DateTime? selectedDate;

  const MonthCell({
    required this.details,
    required this.selectedDate,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // final bool chillday = details.date.weekday == 7 ||
    //     GetIt.I
    //         .get<Data>()
    //         .holidays
    //         .any((final element) => element.date == details.date);

    const bool chillday = false;
    final bool isSelected = selectedDate != null
      ? details.date.sameDate(selectedDate!)
      : false;

    final bool isToday = details.date.day == DateTime.now().day &&
        details.date.month == DateTime.now().month &&
        DateTime.now().year == details.date.year;
    if (isToday) {
      //GetIt.I.get<Talker>().good("da");
    }
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
                      ? Colors.white.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                  )
                : null,
            child: Center(child: Text(details.date.day.toString())),
          ),
        ),
        isToday
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).colorScheme.primary,),),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
