import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  switchTheme: SwitchThemeData(
      overlayColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 18, 21, 37)),
      trackOutlineColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 30, 118, 233).withOpacity(0.1),),
      thumbColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 30, 118, 233)),
      trackColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 18, 21, 37)),),
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
      surface: Color.fromARGB(255, 18, 21, 37),
      onSurface: Color.fromARGB(26, 158, 158, 158),),
);

ThemeData lightThemeAccented = ThemeData.dark().copyWith(
  switchTheme: SwitchThemeData(
      overlayColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 18, 21, 37)),
      trackOutlineColor: WidgetStatePropertyAll(Colors.grey.withOpacity(0.1)),
      thumbColor: WidgetStatePropertyAll(Colors.grey.withOpacity(0.1)),
      trackColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 18, 21, 37)),),
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
      surface: Color.fromARGB(255, 30, 118, 233),
      onSurface: Colors.grey,),
);
