import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class FailedLoadWidget extends ConsumerWidget {
  final String error;
  const FailedLoadWidget(
      {required this.error, super.key,});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(scheduleProvider);
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
          'Ошибка :(',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              fontSize: 26,),
        ),
        Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.red,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
              fontSize: 14,),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          // onTap: () {
          //   provider.loadWeekSchedule.call(context);
          // },
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 2, color: Colors.red),
                borderRadius: const BorderRadius.all(Radius.circular(20)),),
            child: const Center(
              child: Text(
                'Перезагрузить',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18,),
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
