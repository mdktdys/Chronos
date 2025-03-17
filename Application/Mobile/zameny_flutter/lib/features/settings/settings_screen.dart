import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/config/theme/theme_provider.dart';
import 'package:zameny_flutter/config/theme/themes.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/settings_category_tile.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/settings_category_widget.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/theme_tile.dart';
import 'package:zameny_flutter/features/settings/widgets/settings_header.dart';
import 'package:zameny_flutter/features/settings/widgets/settings_logo_block.dart';
import 'package:zameny_flutter/features/settings/widgets/settings_version_block.dart';
import 'package:zameny_flutter/features/timetable/timetable_screen.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class SettingsScreenWrapper extends ConsumerWidget {
  const SettingsScreenWrapper({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return const ScreenAppearBuilder(
      showNavbar: true,
      child: SettingsScreen(),
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
            constraints: BoxConstraints(maxWidth: Constants.maxWidthDesktop),
            child: Column(
              spacing: 10,
              children: [
                const SettingsHeader(),
                const SettingsLogoBlock(),
                SettingsCategory(
                  category: 'Контакты',
                  tiles: [
                    SettingsCategoryTile(
                      title: 'Сайтик колледжа',
                      description: 'Ну тут понятно',
                      icon: Images.teacherHat,
                      onClicked: () async =>  await launchUrl(Uri.parse('https://www.uksivt.ru/'), mode: LaunchMode.externalApplication)
                    ),
                    SettingsCategoryTile(
                      title: 'Есть идеи или предложения?',
                      description: 'Отпишите мне в телеграмчике',
                      icon: Images.send,
                      onClicked: () async =>  await launchUrl(Uri.parse('https://t.me/mdktdys'), mode: LaunchMode.externalApplication)
                    ),
                    SettingsCategoryTile(
                      title: 'Актуальные замены!',
                      description: 'Получайте уведомления о заменах\nв тг канальчике ;)',
                      icon: Images.code,
                      onClicked: () async =>  await launchUrl(Uri.parse('https://t.me/bot_uksivt'), mode: LaunchMode.externalApplication)
                    )
                  ],
                ),
                const ThemeSwitchBlock(),
                const DevTools(),
                const SettingsVersionBlock(),
                const SizedBox(height: 120),
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
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
    final provider = ref.watch(mainProvider);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Прочее',
            style: context.styles.ubuntuPrimaryBold20,
          ),
        ),
        const SizedBox(height: 5),
        BaseBlank(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Партиклы',
                style: context.styles.ubuntuBold14,
              ),
              SizedBox(
                height: 38,
                child: FittedBox(
                  child: Switch(
                      value: provider.falling,
                      onChanged: (final value) => provider.switchFalling(),
                    ),
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
              Text(
                'DEV',
                style: context.styles.ubuntuBold14,
              ),
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
            style: context.styles.ubuntuPrimaryBold20,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
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
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.all(Radius.circular(20)),),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: themes.map((final theme) {    
                return Row(
                  children: [
                    ThemeTile(
                      scheme: theme.$2,
                      flexScheme: theme.$1,
                      isDark: isDark,
                    ),
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
