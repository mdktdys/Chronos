import 'package:flutter/material.dart';

class SettingsVersionBlock extends StatelessWidget {
  const SettingsVersionBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Text(
            "Версия: 01.04.24 билд: 1.1 TEST WEB",
            style: TextStyle(
                fontFamily: 'Monospace', color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
