import 'package:flutter/material.dart';

class SettingsVersionBlock extends StatelessWidget {
  const SettingsVersionBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Version: 0.0.1a (34) Github",
            style: TextStyle(fontFamily: 'Monospace', color: Colors.grey),
            textAlign: TextAlign.start,
          ),
          Text(
            "carefully made for people ✨",
            style: TextStyle(fontFamily: 'Monospace', color: Colors.grey),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
