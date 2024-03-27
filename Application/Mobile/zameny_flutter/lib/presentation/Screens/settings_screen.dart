import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Providers/theme_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/settings_screen/settings_logo_block.dart';

import '../Widgets/settings_screen/settings_header.dart';
import '../Widgets/settings_screen/settings_switch_theme.dart';
import '../Widgets/settings_screen/settings_version_block.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  int _sliding = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _sliding = context.read<ThemeProvider>().getCurrentIndex();
    super.initState();
  }

  void onSwitch(int index) {
    setState(() {
      _sliding = index;
      context.read<ThemeProvider>().toggleTheme();
      setChoosedTheme(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
                // Column(
                //   children: [
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       child: Text(
                //         "Оформление",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontFamily: 'Ubuntu',
                //             fontSize: 20,
                //             color: Theme.of(context).primaryColorLight),
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 5,
                //     ),
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       child: Text(
                //         "Тема:",
                //         style: TextStyle(
                //             fontFamily: 'Ubuntu',
                //             fontSize: 18,
                //             color: Theme.of(context).primaryColorLight),
                //       ),
                //     ),
                //     // SettingsSwitchThemeBlock(
                //     //     sliding: _sliding, onSwitch: onSwitch),
                //   ],
                // ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Контакты",
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.1),
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
                                          "Сайтик колледжа",
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
                                          "В представлении не нуждается",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Ubuntu',
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                            width: 48,
                                            height: 48,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              "assets/icon/vuesax_linear_teacher.svg",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface,
                                            )))
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.1),
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
                                          "Есть идеи или предложения?",
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
                                          "Отпишите мне в телеграмчике",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Ubuntu',
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                            width: 48,
                                            height: 48,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              "assets/icon/vuesax_linear_send-2.svg",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface,
                                            )))
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
                              await launchUrl(
                                  Uri.parse(
                                      "https://t.me/bot_uksivt"),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.1),
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
                                          "Актуальные замены!",
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
                                          "Получайте уведомления о заменах\nв тг канальчике ;)",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Ubuntu',
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                            width: 48,
                                            height: 48,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              "assets/icon/vuesax_linear_message-programming.svg",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface,
                                            )))
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
