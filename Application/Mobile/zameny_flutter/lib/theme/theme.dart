import 'package:flutter/material.dart';


class ThemeProvider extends ChangeNotifier{
  ThemeData _theme = darkTheme;
  ThemeData get theme => _theme;

  void toggleTheme(){
    final isDark = _theme == darkTheme;
    if(isDark){
      _theme = lightTheme;
    }else{
      _theme = darkTheme;
    }
    notifyListeners();
  }
}

class MyTheme {
  final backgroundColor = const Color.fromARGB(255, 18, 21, 37);
  final accentColor = const Color.fromARGB(255, 30, 118, 233);

  final TextStyle defaultText =
      const TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Ubuntu');

  final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  );
}

ThemeData lightTheme = ThemeData(
  primaryColorLight: Colors.black,
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color.fromARGB(255, 30, 118, 233),
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.red,
        background: Colors.white,
        onBackground: Colors.white,
        surface: Colors.red,
        onSurface: Colors.white70),
    useMaterial3: true);

ThemeData darkTheme = ThemeData(
  primaryColorLight: Colors.white,
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color.fromARGB(255, 30, 118, 233),
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.red,
        background: Color.fromARGB(255, 18, 21, 37),
        onBackground: Colors.white,
        surface: Colors.red,
        onSurface: Colors.white70),
    useMaterial3: true);
