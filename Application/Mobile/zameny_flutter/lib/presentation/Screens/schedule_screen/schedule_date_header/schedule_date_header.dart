import 'package:flutter/material.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_date_header/schedule_date_header_toggle_week_button.dart';

class DateHeader extends StatelessWidget {
  final Function dateSwitched;
  final parentWidget;

  const DateHeader(
      {super.key,
      required this.dateSwitched,
      required this.todayWeek,
      required this.currentWeek,
      required this.parentWidget});

  final int todayWeek;
  final int currentWeek;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            // boxShadow: [
            //   BoxShadow(
            //       color: Color.fromARGB(255, 43, 43, 58),
            //       blurStyle: BlurStyle.outer,
            //       blurRadius: 12)
            // ]
            ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleWeekButton(next: false, widget: parentWidget, dateSwitched: dateSwitched),
            Column(
              children: [
                Text(
                  "Весенний семестр 2023/2024",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inverseSurface),
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
                        "Неделя $currentWeek",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.inverseSurface),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      todayWeek == currentWeek
                          ? Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 30, 118, 233),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Color.fromARGB(255, 28, 95, 182),
                                  //     blurStyle: BlurStyle.outer,
                                  //     blurRadius: 6,
                                  //   )
                                  // ],
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
                          : Container()
                    ],
                  ),
                )
              ],
            ),
            ToggleWeekButton(next: true, widget: parentWidget, dateSwitched: dateSwitched),
          ],
        ));
  }
}
