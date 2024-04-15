import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 52,
            height: 52,
            child: Center(
                child: SvgPicture.asset(
              "assets/icon/vuesax_linear_setting-2.svg",
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.inverseSurface,
                  BlendMode.srcIn),
              width: 32,
              height: 32,
            ))),
        Text(
          "Настроечки",
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu'),
        ),
        const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 36,
              color: Colors.transparent,
            ))
      ],
    );
  }
}
