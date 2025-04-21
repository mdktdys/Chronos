import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

final lightThemeProvider = ChangeNotifierProvider<ThemeSettings>((final ref) {
  return ThemeSettings(ref);
});

class ThemeSettings extends ChangeNotifier with WidgetsBindingObserver {
  FlexScheme scheme = FlexScheme.material;
  ThemeMode themeMode = ThemeMode.system;
  int themeModeIndex = 3;
  ThemeData? theme;
  final Ref ref;

  Brightness get brightness {
    return theme?.brightness == Brightness.dark 
      ? Brightness.light
      : Brightness.dark;
  }

  ThemeSettings(this.ref) {
    final prefs = GetIt.I.get<SharedPreferences>();
    themeModeIndex = prefs.getInt('themeModeIndex') ?? 3;

    scheme = FlexScheme.values.firstWhere(
      (final scheme) => scheme.toString() == (prefs.getString('scheme') ?? FlexScheme.material.toString()),
      orElse: () => FlexScheme.material,
    );

    setThemeMode(themeModeIndex);
    _updateTheme();

    WidgetsBinding.instance.addObserver(this);  
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (themeMode == ThemeMode.system) {
      _updateTheme();
    }
  }

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
    final bool isSystemDarkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

    if (themeMode == ThemeMode.dark || (ThemeMode.system == themeMode && isSystemDarkMode)) {
      theme = FlexThemeData.dark(
        appBarStyle: FlexAppBarStyle.surface,
        useMaterial3: true,
        scheme: scheme,
      ).applyCustomTextTheme();
    }

    if (themeMode == ThemeMode.light || (ThemeMode.system == themeMode && !isSystemDarkMode)) {
      theme = FlexThemeData.light(
        appBarStyle: FlexAppBarStyle.surface,
        useMaterial3: true,
        scheme: scheme,
      ).applyCustomTextTheme();
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: theme!.colorScheme.surface));
    notifyListeners();
  }

  void setScheme(final FlexScheme flexScheme) {
    scheme = flexScheme;

    _updateTheme();
    saveSettings();
  }

  Future<void> saveSettings() async {
    final prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setInt('themeModeIndex', themeModeIndex);
    await prefs.setString('scheme', scheme.toString());
  }
}
