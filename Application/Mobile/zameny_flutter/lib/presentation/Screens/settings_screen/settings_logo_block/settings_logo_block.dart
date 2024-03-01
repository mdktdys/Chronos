import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsLogoBlock extends StatelessWidget {
  const SettingsLogoBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: Border.lerp(
              Border(top: BorderSide(color: Colors.red, width: 1), left: BorderSide(color: Colors.yellow,width: 1,) ),
              Border(top: BorderSide(color: Colors.blue, width: 1), left: BorderSide(color: Colors.yellow, width: 1 ) ),
              0.4),
          // gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Color.fromRGBO(193, 101, 221, 1),
          //       Color.fromRGBO(92, 39, 254, 1),
          //     ]),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chronos",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text("будьте терпеливы, я все еще пилю ❤️",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            FittedBox(
              child: Text(
                "🐋",
                style: TextStyle(fontSize: 48),
              ),
            )
          ],
        ),
      ),
    );
  }
}
