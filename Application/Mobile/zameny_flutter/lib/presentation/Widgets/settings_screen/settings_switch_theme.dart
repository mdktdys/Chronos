import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsSwitchThemeBlock extends StatelessWidget {
  const SettingsSwitchThemeBlock(
      {required this.sliding, required this.onSwitch, super.key,});

  final int sliding;
  final Function onSwitch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl(
            thumbColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            groupValue: sliding,
            children: {
              0: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icon/vuesax_linear_moon.svg', color: Colors.white,),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Темная',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,),
                    ),
                  ],
                ),
              ),
              1: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icon/vuesax_linear_sun-2.svg', color: Colors.white,),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Светлая',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,),
                    ),
                  ],
                ),
              ),
            },
            onValueChanged: (index) {
              onSwitch(index);
            },),);
  }
}
