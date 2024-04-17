import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as sf;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Providers/providers.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Providers/theme_provider.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_date_header_toggle_week_button.dart';
import 'package:zameny_flutter/secrets.dart';
import 'package:zameny_flutter/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as river;

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    return Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ToggleWeekButton(
              next: false,
            ),
            const SizedBox(
              width: 5,
            ),
            DateHeaderDatePicker(provider: provider),
            const SizedBox(
              width: 5,
            ),
            const ToggleWeekButton(next: true),
          ],
        ));
  }
}

class DateHeaderDatePicker extends StatelessWidget {
  const DateHeaderDatePicker({
    super.key,
    required this.provider,
  });

  final ScheduleProvider provider;

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              true? showDialog(
                  context: ctx,
                  builder: (context) {
                    return Center(
                        child: Container(
                      width: 380,
                      height: 450,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context)
                              .theme
                              .colorScheme
                              .background,
                          borderRadius: BorderRadius.circular(20)),
                      child: sf.SfDateRangePicker(
                        selectionColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                        backgroundColor: Colors.transparent,
                        selectionRadius: 10,
                        selectionShape: sf.DateRangePickerSelectionShape.circle,
                        initialDisplayDate: DateTime.now()
                            .add(GetIt.I.get<Data>().networkOffset),
                        showActionButtons: true,
                        onViewChanged: (dateRangePickerViewChangedArgs) {
                          GetIt.I.get<Talker>().debug("need load");
                        },
                        allowViewNavigation: false,
                        selectionMode: sf.DateRangePickerSelectionMode.single,
                        onCancel: () => Navigator.of(context).pop(),
                        onSubmit: (p0) {
                          if(p0 == null){
                            Navigator.of(context).pop();
                            return;
                          }
                          DateTime time = (p0 as DateTime);
                          provider.navigationDate = time;
                          provider.currentWeek = provider.getWeekNumber(time);
                          GetIt.I.get<Talker>().debug(p0);
                          provider.dateSwitched(ctx);
                          Navigator.of(context).pop();
                        },
                        monthViewSettings: sf.DateRangePickerMonthViewSettings(
                            firstDayOfWeek: DateTime.monday,
                            blackoutDates: GetIt.I
                                .get<Data>()
                                .holidays
                                .map((e) => e.date)
                                .toList()),
                        showTodayButton: true,
                        showNavigationArrow: true,
                        navigationDirection:
                            sf.DateRangePickerNavigationDirection.vertical,
                        navigationMode: sf.DateRangePickerNavigationMode.scroll,
                        headerStyle: const sf.DateRangePickerHeaderStyle(
                            backgroundColor: Colors.transparent),
                        extendableRangeSelectionDirection:
                            sf.ExtendableRangeSelectionDirection.both,
                        view: sf.DateRangePickerView.month,
                        cellBuilder: (context, cellDetails) {
                          return MonthCell(details: cellDetails);
                        },
                      ),
                    ));
                  }) : null;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Весенний семестр 2023/2024",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      color: Theme.of(ctx).colorScheme.inverseSurface),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Неделя ${provider.currentWeek}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            color: Theme.of(ctx).colorScheme.inverseSurface),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      AnimatedSize(
                        curve: Curves.easeOutCubic,
                        duration: const Duration(milliseconds: 150),
                        alignment: Alignment.center,
                        child: provider.todayWeek == provider.currentWeek
                            ? Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 30, 118, 233),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    "Текущий",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MonthCell extends river.ConsumerWidget {
  const MonthCell({super.key, required this.details});
  final sf.DateRangePickerCellDetails details;

  @override
  Widget build(BuildContext context, river.WidgetRef ref) {
    bool chillday = details.date.weekday == 7 ||
        GetIt.I
            .get<Data>()
            .holidays
            .any((element) => element.date == details.date);
    bool isToday = details.date.day ==
        DateTime.now().add(GetIt.I.get<Data>().networkOffset).day && details.date.month == DateTime.now().add(GetIt.I.get<Data>().networkOffset).month && DateTime.now().add(GetIt.I.get<Data>().networkOffset).year == details.date.year;
    if (isToday) {
      //GetIt.I.get<Talker>().good("da");
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: !chillday
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.1))
                : null,
            child: Center(child: Text(details.date.day.toString())),
          ),
        ),
        // GetIt.I.get<Data>().zamenaFileLinks.any(
        //   (element) {
        //     return element.date == details.date;
        //   },
        // )
        //     ? Align(
        //         alignment: Alignment.topRight,
        //         child: Container(
        //           width: 5,
        //           height: 5,
        //           decoration: const BoxDecoration(
        //               color: Colors.green, shape: BoxShape.circle),
        //         ))
        //     : const SizedBox(),
        isToday
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary)),
              )
            : const SizedBox(),
      ],
    );
  }
}
