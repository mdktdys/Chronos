import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  switchTheme: const SwitchThemeData(
      overlayColor: MaterialStatePropertyAll(Colors.white),
      trackOutlineColor: MaterialStatePropertyAll(Colors.black),
      thumbColor: MaterialStatePropertyAll(Colors.black),
      trackColor: MaterialStatePropertyAll(Colors.white)),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
  primaryColorLight: Colors.black,
  colorScheme: const ColorScheme(
      inverseSurface: Colors.black,
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
      onSurface: Colors.grey),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  switchTheme: SwitchThemeData(
      overlayColor: const MaterialStatePropertyAll(Color.fromARGB(255, 18, 21, 37)),
      trackOutlineColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.1)),
      thumbColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.1)),
      trackColor: const MaterialStatePropertyAll(Color.fromARGB(255, 18, 21, 37))),
  primaryColorLight: Colors.white,
  colorScheme: const ColorScheme(
      inverseSurface: Colors.white,
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
      onSurface: Colors.grey),
);
