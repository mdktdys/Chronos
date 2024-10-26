import 'package:flutter/material.dart';

class SettingsLogoBlock extends StatelessWidget {
  const SettingsLogoBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ]),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
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
                  Text("Будьте терпеливы, я все еще пилю ❤️",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface)),
                ],
              ),
            ),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Image.asset(
                  'assets/icon/whale_1f40b.png',
                  width: 60,
                  height: 60,
                ))
          ],
        ),
      ),
    );
  }
}
