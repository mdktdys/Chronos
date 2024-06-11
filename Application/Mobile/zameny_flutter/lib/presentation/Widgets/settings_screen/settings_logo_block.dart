import 'package:flutter/material.dart';

class SettingsLogoBlock extends StatelessWidget {
  const SettingsLogoBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(193, 101, 221, 1),
                Color.fromRGBO(92, 39, 254, 1),
              ]),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
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
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("будьте терпеливы, я все еще пилю ❤️",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inverseSurface)),
                  ],
                ),
              ),
              const FittedBox(
                child: Padding(padding: EdgeInsets.all(32),child: Image(image: AssetImage("assets/icon/whale_1f40b.png")))
              )
            ],
          ),
        ),
      ),
    );
  }
}
