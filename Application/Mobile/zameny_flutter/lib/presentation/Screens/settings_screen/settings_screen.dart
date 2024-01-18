import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Providers/theme_provider.dart';
import 'package:zameny_flutter/presentation/Screens/settings_screen/settings_logo_block/settings_logo_block.dart';

import 'settings_header/settings_header.dart';
import 'settings_switch_theme_block/settings_switch_theme.dart';
import 'settings_version_block/settings_version_block.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _sliding = 0;

  @override
  void initState() {
    _sliding = context.read<ThemeProvider>().getCurrentIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onSwitch(int index) {
      setState(() {
        _sliding = index;
        context.read<ThemeProvider>().toggleTheme();
        setChoosedTheme(index);
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SettingsHeader()),
        SliverToBoxAdapter(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const SettingsLogoBlock(),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Decoration",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                        fontSize: 20,
                        color: Theme.of(context).primaryColorLight),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "App theme:",
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        color: Theme.of(context).primaryColorLight),
                  ),
                ),
                SettingsSwitchThemeBlock(
                    sliding: _sliding, onSwitch: onSwitch),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Contacts",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                        fontSize: 20,
                        color: Theme.of(context).primaryColorLight),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(
                        3,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(
                              Uri.parse("https://www.uksivt.ru/"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Educational organization website",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Visit for more information",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: const Icon(
                                    Icons.open_in_new,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                        3,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse("https://t.me/mdktdys"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Have a question or suggestion?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Write to the application developer in Telegram",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: const Icon(
                                    Icons.telegram,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                        3,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse("https://github.com/EventGamer67/Chronos"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stay tuned for new updates",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Follow the development\nand get the latest versions on Github",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: const Icon(
                                    Icons.android_rounded,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SettingsVersionBlock()
          ],
        ))
      ],
        ),
      ),
    );
  }
}
