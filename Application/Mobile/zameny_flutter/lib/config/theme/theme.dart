import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  switchTheme: SwitchThemeData(
    overlayColor: const WidgetStatePropertyAll(Color(0xFF121525)),
    trackOutlineColor: WidgetStatePropertyAll(
      const Color(0xFF1E76E9).withValues(alpha: 0.1),
    ),
    thumbColor: const WidgetStatePropertyAll(Color(0xFF1E76E9)),
    trackColor: const WidgetStatePropertyAll(Color(0xFF121525)),
  ),
  primaryColorLight: Colors.white,
  colorScheme: const ColorScheme(
    inverseSurface: Colors.white,
    brightness: Brightness.dark,
    primary: Color(0xFF1E76E9),
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.red,
    surface: Color(0xFF121525),
    onSurface: Color(0x1A9E9E9E),
  ),
);

ThemeData lightThemeAccented = ThemeData.dark().copyWith(
  switchTheme: SwitchThemeData(
    overlayColor: const WidgetStatePropertyAll(Color(0xFF121525)),
    trackOutlineColor: WidgetStatePropertyAll(Colors.grey.withValues(alpha: 0.1)),
    thumbColor: WidgetStatePropertyAll(Colors.grey.withValues(alpha: 0.1)),
    trackColor: const WidgetStatePropertyAll(Color(0xFF121525)),
  ),
  primaryColorLight: Colors.white,
  colorScheme: const ColorScheme(
    inverseSurface: Colors.white,
    brightness: Brightness.dark,
    primary: Color(0xFF1E76E9),
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.red,
    surface: Color(0xFF1E76E9),
    onSurface: Colors.grey,
  ),
);
