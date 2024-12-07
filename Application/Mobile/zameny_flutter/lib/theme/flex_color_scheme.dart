import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<(FlexScheme scheme,FlexSchemeData color )> themes = [
  (FlexScheme.amber,FlexColor.amber),
  (FlexScheme.aquaBlue,FlexColor.aquaBlue),
  (FlexScheme.bahamaBlue,FlexColor.bahamaBlue),
  (FlexScheme.barossa,FlexColor.barossa),
  (FlexScheme.bigStone,FlexColor.bigStone),
  (FlexScheme.blue,FlexColor.blue),
  (FlexScheme.blueM3,FlexColor.blueM3),
  (FlexScheme.blueWhale,FlexColor.blueWhale),
  (FlexScheme.blumineBlue,FlexColor.blumineBlue),
  (FlexScheme.brandBlue,FlexColor.brandBlue),
  (FlexScheme.cyanM3,FlexColor.cyanM3),
  (FlexScheme.damask,FlexColor.damask),
  (FlexScheme.deepBlue,FlexColor.deepBlue),
  (FlexScheme.deepOrangeM3,FlexColor.deepOrangeM3),
  (FlexScheme.deepPurple,FlexColor.deepPurple),
  (FlexScheme.dellGenoa,FlexColor.dellGenoa),
  (FlexScheme.ebonyClay,FlexColor.ebonyClay),
  (FlexScheme.espresso,FlexColor.espresso),
  (FlexScheme.flutterDash,FlexColor.flutterDash),
  (FlexScheme.gold,FlexColor.gold),
  (FlexScheme.green,FlexColor.green),
  (FlexScheme.greenM3,FlexColor.greenM3),
  (FlexScheme.greyLaw,FlexColor.greyLaw),
  (FlexScheme.hippieBlue,FlexColor.hippieBlue),
  (FlexScheme.indigo,FlexColor.indigo),
  (FlexScheme.jungle,FlexColor.jungle),
  (FlexScheme.mallardGreen,FlexColor.mallardGreen),
  (FlexScheme.mandyRed,FlexColor.mandyRed),
  (FlexScheme.red,FlexColor.red),
  (FlexScheme.sakura,FlexColor.sakura),
];

final lightThemeProvider = ChangeNotifierProvider<ThemeSettings>((final ref) {
  return ThemeSettings(ref);
});

class ThemeSettings extends ChangeNotifier with WidgetsBindingObserver {
  final Ref ref;
  ThemeData? theme;
  int themeModeIndex = 3;
  FlexScheme scheme = FlexScheme.material;
  ThemeMode themeMode = ThemeMode.system;

   ThemeSettings(this.ref) {
    // Подписка на изменения системы (например, изменение темы)
    WidgetsBinding.instance.addObserver(this);
    _loadSettings(); // Загрузка сохраненных настроек при инициализации
  }

  @override
  void dispose() {
    // Удаление наблюдателя при уничтожении
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Вызывается при изменении яркости системы (темная или светлая тема)
    if (themeMode == ThemeMode.system) {
      _updateTheme();
    }
  }

  // Установка режима темы: тёмный - 1, светлый - 2, системный - 3
  void setThemeMode(final int index) {
    themeModeIndex = index;
    switch (index) {
      case 1:
        themeMode = ThemeMode.dark;
        break;
      case 2:
        themeMode = ThemeMode.light;
        break;
      case 3:
        themeMode = ThemeMode.system;
        break;
      default:
    }
    _updateTheme();
    saveSettings();
  }

  void _updateTheme() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final bool isSystemDarkMode = brightness == Brightness.dark;

    switch (themeMode) {
      case ThemeMode.dark:
        theme = FlexThemeData.dark(
          useMaterial3: true,
          scheme: scheme,
        ).applyCustomTextTheme();
        break;
      case ThemeMode.light:
        theme = FlexThemeData.light(
          useMaterial3: true,
          scheme: scheme,
        ).applyCustomTextTheme();
        break;
      case ThemeMode.system:
        theme = isSystemDarkMode
            ? FlexThemeData.dark(
                useMaterial3: true,
                scheme: scheme,
              ).applyCustomTextTheme()
            : FlexThemeData.light(
                useMaterial3: true,
                scheme: scheme,
              ).applyCustomTextTheme();
        break;
      default:
    }
    notifyListeners();
  }

  // Обновление цветовой схемы
  void setScheme(final FlexSchemeData newScheme, final FlexScheme flexScheme) {
    scheme = flexScheme;
    _updateTheme();
    saveSettings();
  }

  // Сохранение настроек в SharedPreferences
  Future<void> saveSettings() async {
    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setInt('themeModeIndex', themeModeIndex);
    await prefs.setString('scheme', scheme.toString());
  }

  // Загрузка настроек из SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = GetIt.I.get<SharedPreferences>();
    themeModeIndex = prefs.getInt('themeModeIndex') ?? 3;
    scheme = _getSchemeFromString(prefs.getString('scheme') ?? FlexScheme.material.toString());

    setThemeMode(themeModeIndex);
    _updateTheme();
  }

  // Метод для преобразования строки в FlexScheme
  FlexScheme _getSchemeFromString(final String schemeString) {
    return FlexScheme.values.firstWhere(
      (final scheme) => scheme.toString() == schemeString,
      orElse: () => FlexScheme.material,
    );
  }
}

extension TextThemeTools on ThemeData{
  ThemeData applyCustomTextTheme() {
    return copyWith(
        extensions: [
          CustomTextStyles(theme: this)
        ],
        // textTheme: CustomTextTheme(theme: this)
        // textTheme: textTheme.copyWith(
        //   displayMedium: TextStyle(
        //     color: colorScheme.primary,
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     fontFamily: 'Ubuntu',
        // ),
    );
  }
}


// class CustomTextTheme extends TextTheme{
//   final ThemeData theme;

//   CustomTextTheme({required this.theme});

//   late final TextStyle primary60016 = TextStyle(
//     color: theme.colorScheme.primary,
//     fontWeight: FontWeight.bold,
//     fontSize: 24,
//   );
// }

class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  // final TextStyle primary60016;
  // final TextStyle secondaryBold24;

  final ThemeData theme;

  CustomTextStyles({required this.theme});

  @override
  CustomTextStyles copyWith({
    final ThemeData? theme_,
  }) {
    return CustomTextStyles(
      theme: theme_??theme
    );
  }

  @override
  CustomTextStyles lerp(final ThemeExtension<CustomTextStyles>? other, final double t) {
    if (other is! CustomTextStyles) {
      return this;
    } 
    return CustomTextStyles(
      theme: other.theme
    );
  }

    late final TextStyle ubuntuCanvasColorBold14 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 14,
    color: theme.canvasColor,
  );

  late final TextStyle ubuntuInverseSurfaceBold18 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 18,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurfaceBold16 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 16,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurfaceBold14 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 14,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurfaceBold20 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 20,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurfaceBold24 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 24,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuPrimaryBold24 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 24,
    color: theme.colorScheme.primary,
  );

  late final TextStyle ubuntuInverseSurface40014 = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    fontSize: 14,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuWhite500 = const TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: 'Ubuntu',
    color: Colors.white,
  );

  late final TextStyle ubuntuInverseSurface = TextStyle(
    fontFamily: 'Ubuntu',
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurface12 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 12,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurface10 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 10,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurface16 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 16,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurface18 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 18,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurface20 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 20,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInverseSurface24 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 20,
    color: theme.colorScheme.inverseSurface,
  );

  late final TextStyle ubuntuInversePrimary20 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 20,
    color: theme.colorScheme.inversePrimary,
  );

  late final TextStyle ubuntuOnSurface = TextStyle(
    fontFamily: 'Ubuntu',
    color: theme.colorScheme.onSurface,
  );

  late final TextStyle ubuntuBold14 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 14,
  );

  late final TextStyle ubuntuBold22 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 22,
  );

    late final TextStyle ubuntuBold12 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 12,
  );

  late final TextStyle ubuntuWhiteBold24 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 24,
    color: Colors.white,
  );

  late final TextStyle ubuntuWhiteBold14 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 14,
    color: Colors.white,
  );

  late final TextStyle ubuntuWhite20 = const TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 20,
    color: Colors.white,
  );

  late final TextStyle ubuntuPrimaryBold20 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 20,
    color: theme.colorScheme.primary,
  );

  late final TextStyle ubuntu16 = const TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 16,
  );

  late final TextStyle ubuntu18 = const TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 18,
  );

  late final TextStyle ubuntuBold18 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 18,
  );

  late final TextStyle ubuntuBold16 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 18,
  );

  late final TextStyle ubuntu12 = const TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 12,
  );

  late final TextStyle ubuntu40012 = const TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    fontSize: 12,
  );

  late final TextStyle ubuntu20 = const TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 20,
  );

  late final TextStyle ubuntu = const TextStyle(
    fontFamily: 'Ubuntu',
  );

  late final TextStyle ubuntu400 = const TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
  );

  late final TextStyle monospace12 = const TextStyle(
    fontFamily: 'Monospace',
    color: Colors.grey,
    fontSize: 12,
  );
}

extension CustomTextStylesExtension on BuildContext {
  CustomTextStyles get styles {
    return Theme.of(this).extension<CustomTextStyles>()!;
  }
}
