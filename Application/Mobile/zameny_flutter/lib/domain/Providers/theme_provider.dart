import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData theme = darkTheme;

  int getCurrentIndex() {
    return theme == darkTheme ? 0 : 1;
  }

  ThemeProvider.fromData() {
    int? loaded = GetIt.I.get<SharedPreferences>().getInt("Theme");
    theme = loaded == null
        ? darkTheme
        : loaded == 0
            ? darkTheme
            : lightTheme;
  }

  void toggleTheme() {
    final isDark = theme == darkTheme;
    if (isDark) {
      theme = lightTheme;
    } else {
      theme = darkTheme;
    }
    GetIt.I.get<SharedPreferences>().setInt("Theme", isDark ? 0 : 1);
    notifyListeners();
  }
}
