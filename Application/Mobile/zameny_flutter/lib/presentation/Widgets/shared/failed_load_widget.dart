
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';

class FailedLoadWidget extends StatelessWidget {
  final String error;
  const FailedLoadWidget(
      {super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
          size: 100,
          shadows: [Shadow(color: Colors.red, blurRadius: 4)],
        ),
        const Text(
          "Ошибка :(",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.red,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            provider.loadWeekSchedule.call(context);
          },
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 2, color: Colors.red),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: const Center(
              child: Text(
                "Перезагрузить",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }
}
