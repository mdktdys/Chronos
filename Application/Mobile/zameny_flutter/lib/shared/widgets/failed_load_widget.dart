import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedLoadWidget extends ConsumerWidget {
  final VoidCallback onClicked;
  final String error;
  
  const FailedLoadWidget({
    required this.onClicked,
    required this.error,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
          size: 100,
          shadows: [Shadow(color: Colors.red, blurRadius: 4)],
        ),
        // const Text(
        //   'Ошибка :(',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //       color: Colors.red,
        //       fontFamily: 'Ubuntu',
        //       fontWeight: FontWeight.bold,
        //       fontSize: 26,),
        // ),
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
        BaseButton.red(
          text: 'Еще разок',
          onClicked: () async {
            await Future.delayed(const Duration(seconds: 3));
          },
        ),
        // GestureDetector(
        //   // onTap: () {
        //   //   provider.loadWeekSchedule.call(context);
        //   // },
        //   child: Container(
        //     width: 150,
        //     height: 40,
        //     decoration: BoxDecoration(
        //         color: Colors.transparent,
        //         border: Border.all(width: 2, color: Colors.red),
        //         borderRadius: const BorderRadius.all(Radius.circular(20)),),
        //     child: const Center(
        //       child: Text(
        //         'Перезагрузить',
        //         style: ,
        //       ),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class BaseButton extends StatelessWidget {
  final Future<void> Function() onClicked;
  final String text;
  final Color color;

  const BaseButton({
    required this.onClicked,
    required this.color,
    required this.text,
    super.key
  });

  factory BaseButton.red({
    required final String text,
    required final Future<void> Function() onClicked
  }) {
    return BaseButton(
      onClicked: onClicked,
      color: Colors.red,
      text: text
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onClicked,
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Ubuntu', 
                fontSize: 18,
              )
            ),
          ),
        ),
      ),
    );
  }
}
