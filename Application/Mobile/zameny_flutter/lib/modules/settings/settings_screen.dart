import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_tile.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_widget.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_departments_block.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_header.dart';
import 'package:zameny_flutter/widgets/dev_tools_widget.dart';
import 'package:zameny_flutter/widgets/screen_appear_builder.dart.dart';
import 'package:zameny_flutter/widgets/theme_switch_block_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ScreenAppearBuilder(
      showNavbar: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Spacing.listHorizontalPadding),
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Constants.maxWidthDesktop),
              child: Column(
                spacing: Spacing.list,
                children: [
                  const SizedBox.shrink(),
                  const SettingsHeader(),
                  // const SettingsLogoBlock(),
                  SettingsCategory(
                    category: 'Контакты',
                    tiles: [
                      SettingsCategoryTile(
                        title: 'Сайтик колледжа',
                        description: 'Ну тут понятно',
                        icon: Images.teacherHat,
                        onClicked: () async =>  await launchUrl(
                          Uri.parse(Constants.site),
                          mode: LaunchMode.externalApplication
                        )
                      ),
                      SettingsCategoryTile(
                        title: 'Есть идеи или предложения?',
                        description: 'Отпишите мне в телеграмчике',
                        icon: Images.send,
                        onClicked: () async =>  await launchUrl(
                          Uri.parse(Constants.telegramChannel),
                          mode: LaunchMode.externalApplication
                        )
                      ),
                      SettingsCategoryTile(
                        title: 'Актуальные замены!',
                        description: 'Получайте уведомления о заменах\nв тг канальчике ;)',
                        icon: Images.code,
                        onClicked: () async =>  await launchUrl(
                          Uri.parse(Constants.telegramBot),
                          mode: LaunchMode.externalApplication
                        )
                      ),
                      SettingsCategoryTile(
                        title: 'Хочется натива?',
                        description: 'Есть мобилка, ток андроеды',
                        icon: Images.rustore,
                        onClicked: () async =>  await launchUrl(
                          Uri.parse(Constants.rustore),
                          mode: LaunchMode.externalApplication
                        )
                      )
                    ],
                  ),
                  const SettingsDepartmentsBlock(),
                  const ThemeSwitchBlock(),
                  const DevTools(),
                  Text(
                    Constants.version,
                    textAlign: TextAlign.center,
                    style: context.styles.monospace12
                  ),
                  SizedBox(height: Constants.bottomSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
