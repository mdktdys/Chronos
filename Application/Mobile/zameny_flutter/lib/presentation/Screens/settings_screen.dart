import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/domain/Providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/settings_screen/settings_logo_block.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

import '../Widgets/settings_screen/settings_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final int _sliding = 0;

  // @override
  // bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   _sliding = context.read<ThemeProvider>().getCurrentIndex();
  //   super.initState();
  // }

  // void onSwitch(int index) {
  //   setState(() {
  //     _sliding = index;
  //     context.read<ThemeProvider>().toggleTheme();
  //     setChoosedTheme(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    const SettingsHeader(),
                    Column(
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
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
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Сайтик колледжа",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'Ubuntu',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "В представлении не нуждается",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Ubuntu',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () async {
                                      await launchUrl(
                                          Uri.parse("https://t.me/mdktdys"),
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
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Есть идеи или предложения?",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'Ubuntu',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Отпишите мне в телеграмчике",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Ubuntu',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () async {
                                      await launchUrl(
                                          Uri.parse("https://t.me/bot_uksivt"),
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
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Актуальные замены!",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'Ubuntu',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Получайте уведомления о заменах\nв тг канальчике ;)",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Ubuntu',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const ThemeSwitchBlock(),
                            const SizedBox(height: 5),
                            const DevTools()
                          ],
                        ),
                        // const SettingsVersionBlock()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}


class BaseBlank extends StatelessWidget {
  final Widget child;

  const BaseBlank({super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      )
    );
  }
}

class DevTools extends ConsumerWidget {
  const DevTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MainProvider provider =  context.watch<MainProvider>();
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Прочее",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
                fontSize: 20,
                color:
                    Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 5),
        BaseBlank(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Партиклы",style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'Ubuntu',
                                                    ),),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                      value: provider.falling,
                      onChanged: (value) =>
                          provider.switchFalling()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        BaseBlank(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("DEV",style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'Ubuntu',
                                                    ),),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                      value: provider.isDev,
                      onChanged: (value) =>
                          provider.switchDev()),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ThemeSwitchBlock extends ConsumerStatefulWidget {
  const ThemeSwitchBlock({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ThemeSwitchBlockState();
}

class _ThemeSwitchBlockState extends ConsumerState<ThemeSwitchBlock> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark
        ? true
        : false;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Тема",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
                fontSize: 20,
                color:
                    Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: SegmentedButtonTheme(
            data: Theme.of(context).segmentedButtonTheme,
            child: SegmentedButton(
                onSelectionChanged: (p0) {
                  ref.read(lightThemeProvider).setThemeMode(p0.first);
                },
                segments: const [
                  ButtonSegment(value: 1, icon: Icon(Icons.dark_mode)),
                  ButtonSegment(value: 2, icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: 3, icon: Icon(Icons.phone_android))
                ],
                selected: {
                  ref.watch(lightThemeProvider).themeModeIndex
                }),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            height: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: themes.map((theme) {    
                return Row(
                  children: [
                    ThemeTile(
                        ref: ref,
                        scheme: theme.$2,
                        flexScheme: theme.$1,
                        isDark: isDark),
                        const SizedBox(width: 5)
                  ],
                );
              }).toList()),
            )
          )
        ]
      );
  }
}

class ThemeTile extends StatelessWidget {
  final FlexSchemeData scheme;
  final FlexScheme flexScheme;
  final bool isDark;

  const ThemeTile(
      {super.key,
      required this.ref,
      required this.scheme,
      required this.flexScheme,
      required this.isDark});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = isDark ? scheme.dark : scheme.light;
    final bool isCurrent = ref.watch(lightThemeProvider).scheme == flexScheme;
    return Bounceable(
      onTap: () {
        ref.read(lightThemeProvider).setScheme(scheme, flexScheme);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
          border: isCurrent ? Border.all(color: Theme.of(context).colorScheme.inversePrimary, width: 4) :  null )
        ,
        child: ClipRRect(
          borderRadius: BorderRadius.circular( isCurrent ? 10 : 6),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Column(
              children: [
                Expanded(
                  child: Row(children: [
                    Expanded(
                      child: Container(color: theme.primary),
                    ),
                    Expanded(
                      child: Container(
                        color: theme.tertiary,
                      ),
                    )
                  ]),
                ),
                Expanded(
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        color: theme.primaryContainer,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: theme.secondary,
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
