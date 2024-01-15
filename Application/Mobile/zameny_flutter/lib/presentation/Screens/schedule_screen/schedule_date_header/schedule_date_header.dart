import 'package:flutter/material.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen/schedule_date_header/schedule_date_header_toggle_week_button.dart';

class DateHeader extends StatelessWidget {
  final parentWidget;

  const DateHeader(
      {super.key,
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
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 59, 64, 82),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 43, 43, 58),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 12)
            ]),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleWeekButton(next: false, widget: parentWidget),
            Column(
              children: [
                const Text(
                  "Осенний семестр 2023/2024",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      color: Colors.white),
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
                        "Week $currentWeek",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      todayWeek == currentWeek
                          ? Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 30, 118, 233),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 28, 95, 182),
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 6,
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  "Current",
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
            ToggleWeekButton(next: true, widget: parentWidget),
          ],
        ));
  }
}
