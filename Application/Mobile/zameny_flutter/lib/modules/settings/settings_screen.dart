import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/enums/department_forms_enum.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_tile.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_widget.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_header.dart';
import 'package:zameny_flutter/widgets/base_container.dart';
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
                      )
                    ],
                  ),
                  SettingsCategory(
                    category: 'Заказать справку',
                    tiles: [
                      BaseContainer(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: DepartmentForms.values.map((final DepartmentForms department) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: Bounceable(
                                        hitTestBehavior: HitTestBehavior.translucent,
                                        onTap: () async =>  await launchUrl(
                                          Uri.parse(department.formUrl),
                                          mode: LaunchMode.externalApplication
                                        ),
                                        child: Text(
                                          department.title,
                                          textAlign: TextAlign.left,
                                          // style: context.styles.ubuntuBold16
                                        ),
                                      ),
                                    ),
                                    Bounceable(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: department.formUrl));
                                      },
                                      child: SvgPicture.asset(
                                        Images.copy,
                                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.3), BlendMode.srcIn),
                                      ),
                                    ),
                                  ],
                                ),
                                if (department != DepartmentForms.computer)
                                  const Divider(
                                    indent: 10,
                                    endIndent: 10,
                                  )
                              ],
                            );
                          }).toList()
                        )
                      )
                    ]
                  ),
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
