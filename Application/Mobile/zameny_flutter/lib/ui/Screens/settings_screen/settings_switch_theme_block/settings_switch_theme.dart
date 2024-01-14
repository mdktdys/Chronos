import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSwitchThemeBlock extends StatelessWidget {
  const SettingsSwitchThemeBlock(
      {super.key, required this.sliding, required this.onSwitch});

  final int sliding;
  final Function onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl(
            thumbColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.background,
            groupValue: sliding,
            children: {
              0: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.dark_mode_outlined),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      "Dark",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              1: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.light_mode_outlined),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      "Light",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            },
            onValueChanged: (index) {
              onSwitch(index);
            }));
  }
}
