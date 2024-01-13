import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/theme/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _sliding = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.settings_suggest_rounded,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Text(
                  "Settings",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu'),
                ),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            )),
            SliverToBoxAdapter(
                child: Column(
              children: [
                //Logo
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
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
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("be patient, test versions ❤️",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                        const Text(
                          "🐋",
                          style: TextStyle(fontSize: 48),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl(
                        thumbColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        groupValue: _sliding,
                        children: {
                          0: Text(
                            "Dark",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight),
                          ),
                          1: Text("Light",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).primaryColorLight)),
                        },
                        onValueChanged: (sel) {
                          setState(() {
                            _sliding = sel!;
                            provider.toggleTheme();
                          });
                        }))
              ],
            ))
          ],
        ),
      )),
    );
  }
}
