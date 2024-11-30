import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/domain/Providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/app/providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/settings/widgets/settings_header.dart';
import 'package:zameny_flutter/presentation/Screens/settings/widgets/settings_logo_block.dart';
import 'package:zameny_flutter/presentation/Screens/settings/widgets/settings_version_block.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class SettingsCategory extends StatelessWidget {
  final String category;
  final List<Widget> tiles;

  const SettingsCategory({
    required this.category,
    required this.tiles,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu',
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary
          ),
        ),
        const SizedBox(height: 10),
        ...tiles
      ],
    );
  }
}

class SettingsCategoryTile extends StatelessWidget {
  final VoidCallback onClicked;
  final String description;
  final String title;
  final String icon;

  const SettingsCategoryTile({
    required this.description,
    required this.onClicked,
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onClicked,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    icon,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreenWrapper extends ConsumerWidget {
  const SettingsScreenWrapper({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((final _){
      ref.read(mainProvider).updateScrollDirection(ScrollDirection.forward);
    });
    return const SettingsScreen().animate(
      effects: [
        const FadeEffect(
          duration: Duration(milliseconds: 100),
          end: 1.0,
          begin: 0.0
        ),
      ]
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const SettingsHeader(),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    const SettingsLogoBlock(),
                    const SizedBox(height: 20),
                    SettingsCategory(
                      category: 'Контакты',
                      tiles: [
                        SettingsCategoryTile(
                          title: 'Сайтик колледжа',
                          description: 'Ну тут понятно',
                          icon: 'assets/icon/vuesax_linear_teacher.svg',
                          onClicked: () async =>  await launchUrl(Uri.parse('https://www.uksivt.ru/'), mode: LaunchMode.externalApplication)
                        ),
                        const SizedBox(height: 10),
                        SettingsCategoryTile(
                          title: 'Есть идеи или предложения?',
                          description: 'Отпишите мне в телеграмчике',
                          icon: 'assets/icon/vuesax_linear_send-2.svg',
                          onClicked: () async =>  await launchUrl(Uri.parse('https://t.me/mdktdys'), mode: LaunchMode.externalApplication)
                        ),
                        const SizedBox(height: 10),
                        SettingsCategoryTile(
                          title: 'Актуальные замены!',
                          description: 'Получайте уведомления о заменах\nв тг канальчике ;)',
                          icon: 'assets/icon/vuesax_linear_message-programming.svg',
                          onClicked: () async =>  await launchUrl(Uri.parse('https://t.me/bot_uksivt'), mode: LaunchMode.externalApplication)
                        )
                      ],
                    ),
                    const SizedBox(height: 3),
                    const ThemeSwitchBlock(),
                    const SizedBox(height: 5),
                    const DevTools(),
                    const SettingsVersionBlock(),
                    const SizedBox(height: 120),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BaseBlank extends StatelessWidget {
  final Widget child;

  const BaseBlank({required this.child, super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: child
    );
  }
}

class DevTools extends ConsumerWidget {
  const DevTools({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final MainProvider provider =  context.watch<MainProvider>();
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Прочее',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
                fontSize: 20,
                color:
                    Theme.of(context).colorScheme.primary,),
          ),
        ),
        const SizedBox(height: 5),
        BaseBlank(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Партиклы',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Ubuntu',
                ),
              ),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                      value: provider.falling,
                      onChanged: (final value) =>
                          provider.switchFalling(),),
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
              const Text('DEV',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Ubuntu',
              ),),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                    value: provider.isDev,
                    onChanged: (final value) => provider.switchDev(),
                  ),
                ),
              ),
            ],
          ),
        ),
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
  Widget build(final BuildContext context) {
    final bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Тема',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
                fontSize: 20,
                color:
                    Theme.of(context).colorScheme.primary,),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(20)),),
          child: SegmentedButtonTheme(
            data: Theme.of(context).segmentedButtonTheme,
            child: SegmentedButton(
                onSelectionChanged: (final p0) {
                  ref.read(lightThemeProvider).setThemeMode(p0.first);
                },
                segments: const [
                  ButtonSegment(value: 1, icon: Icon(Icons.dark_mode)),
                  ButtonSegment(value: 2, icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: 3, icon: Icon(Icons.phone_android)),
                ],
                selected: {
                  ref.watch(lightThemeProvider).themeModeIndex,
                },),
          ),
        ),
        const SizedBox(height: 8),
        Container(
            height: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(20)),),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: themes.map((final theme) {    
                return Row(
                  children: [
                    ThemeTile(
                        ref: ref,
                        scheme: theme.$2,
                        flexScheme: theme.$1,
                        isDark: isDark,),
                        const SizedBox(width: 5),
                  ],
                );
              }).toList(),),
            ),
          ),
        ],
      );
  }
}

class ThemeTile extends StatelessWidget {
  final FlexSchemeData scheme;
  final FlexScheme flexScheme;
  final bool isDark;

  const ThemeTile(
      {required this.ref, required this.scheme, required this.flexScheme, required this.isDark, super.key,});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
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
          border: isCurrent ? Border.all(color: Theme.of(context).colorScheme.inversePrimary, width: 4) :  null, )
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
                    ),
                  ],),
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
                    ),
                  ],),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
