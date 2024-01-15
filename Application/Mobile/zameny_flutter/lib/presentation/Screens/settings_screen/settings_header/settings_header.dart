import 'package:flutter/material.dart';

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
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.settings_suggest_rounded,
              size: 36,
              color: Theme.of(context).primaryColorLight,
            )),
        Text(
          "Settings",
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
