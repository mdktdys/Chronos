import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/enums/auth_status_enum.dart';
import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/spacing.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/modules/settings/providers/auth_provider.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_tile.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_category_widget.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_departments_block.dart';
import 'package:zameny_flutter/modules/settings/widgets/settings_header.dart';
import 'package:zameny_flutter/widgets/dev_tools_widget.dart';
import 'package:zameny_flutter/widgets/failed_load_widget.dart';
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                          title: 'Мобильное приложение',
                          description: 'ток андроеды',
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
                    // const TelegramLoginButton(),
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
      ),
    );
  }

  // Future<void> listenAuth(final String token) async {
  //   const int intervalMs = 2000;
  //   const int maxAttempts = (60 * 1000) ~/ intervalMs;

  //   for (int i = 0; i < maxAttempts; i++) {
  //     try {
  //       final response = await Dio().get(
  //         'https://api.uksivt.xyz/api/v1/telegram/status',
  //         queryParameters: {'token': token},
  //       );

  //       if (response.statusCode == 200 && response.data != null && response.data['access_token'] != null) {
  //         log('ПОЛУЧЕН ТОКЕН ${response.data['access_token']}');
  //         log('РЕФРЕШ ${response.data['refresh_token']}');
  //         return;
  //       }
  //     } catch (e) {
  //       log('Ошибка при проверке статуса: $e');
  //     }
  //     await Future.delayed(const Duration(milliseconds: intervalMs));
  //   }
  //   return; // таймаут
  // }
}


class TelegramLoginButton extends ConsumerWidget {
  const TelegramLoginButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('data'),
        BaseButton(
          text: 'Login with telegram',
          color: Colors.blue,
            onClicked: () async {
            await authNotifier.startAuth();
          },
        ),

        if (authState.status == AuthStatus.loading)
          const CircularProgressIndicator(),

        if (authState.status == AuthStatus.success) ...[
          const Text('Авторизация успешна!'),
          Text('Токен: ${authState.user.toString()}'),
        ],

        if (authState.status == AuthStatus.error)
          Text('Ошибка: ${authState.errorMessage}'),

        if (authState.status == AuthStatus.timeout)
          const Text('Время ожидания истекло, попробуйте снова.'),
      ],
    );
  }
}
