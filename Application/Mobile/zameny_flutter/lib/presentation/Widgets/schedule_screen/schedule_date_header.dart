import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_date_header_toggle_week_button.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ToggleWeekButton(
              next: false,
            ),
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
                        "Неделя ${provider.currentWeek}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            color:
                                Theme.of(context).colorScheme.inverseSurface),
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
            const ToggleWeekButton(next: true),
          ],
        ));
  }
}
