import 'package:flutter/material.dart';

class SettingsLogoBlock extends StatelessWidget {
  const SettingsLogoBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(193, 101, 221, 1),
                Color.fromRGBO(92, 39, 254, 1),
              ]),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chronos",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text("будьте терпеливы, я все еще пилю ❤️",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            Text(
              "🐋",
              style: TextStyle(fontSize: 48),
            )
          ],
        ),
      ),
    );
  }
}
