import 'package:flutter/material.dart';

class ToggleWeekButton extends StatelessWidget {
  final bool next;
  final widget;

  const ToggleWeekButton({super.key, required this.next, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 28, 95, 182),
              blurStyle: BlurStyle.outer,
              blurRadius: 6,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: GestureDetector(
        onTap: () {
          const Duration(seconds: 1); // имитация загрузки данных

          widget.currentWeek += next ? 1 : -1;
          if (widget.currentWeek < 1) {
            widget.currentWeek = 1;
          } else {
            widget.NavigationDate =
                widget.NavigationDate.add(Duration(days: next ? 7 : -7));
            widget.setState(() {
              // обновление состояния страницы
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            next ? Icons.arrow_right_rounded : Icons.arrow_left_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
