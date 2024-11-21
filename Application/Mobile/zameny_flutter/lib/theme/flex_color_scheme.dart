import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
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

final lightThemeProvider = ChangeNotifierProvider<ThemeSettings>((ref) {
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
  void setThemeMode(int index) {
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
    // Определяем текущий системный режим (светлый или тёмный)
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final bool isSystemDarkMode = brightness == Brightness.dark;

    switch (themeMode) {
      case ThemeMode.dark:
        theme = FlexThemeData.dark(
          useMaterial3: true,
          scheme: scheme,
        );
        break;
      case ThemeMode.light:
        theme = FlexThemeData.light(
          useMaterial3: true,
          scheme: scheme,
        );
        break;
      case ThemeMode.system:
        // Устанавливаем тему в зависимости от системного режима
        theme = isSystemDarkMode
            ? FlexThemeData.dark(
                useMaterial3: true,
                scheme: scheme,
              )
            : FlexThemeData.light(
                useMaterial3: true,
                scheme: scheme,
              );
        break;
      default:
    }
    notifyListeners();
  }

  // Обновление цветовой схемы
  void setScheme(FlexSchemeData newScheme, FlexScheme flexScheme) {
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
  FlexScheme _getSchemeFromString(String schemeString) {
    return FlexScheme.values.firstWhere(
      (scheme) => scheme.toString() == schemeString,
      orElse: () => FlexScheme.material,
    );
  }
}