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
        SvgPicture.asset("assets/icon/vuesax_linear_setting-2.svg",color: Theme.of(context).primaryColorLight,),
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
