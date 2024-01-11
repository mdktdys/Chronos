import 'package:flutter/material.dart';

class MyTheme {
  final backgroundColor = const Color.fromARGB(255, 18, 21, 37);
  final accentColor = const Color.fromARGB(255, 30, 118, 233);

  final TextStyle defaultText = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontFamily: 'Ubuntu');

  final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  );
}
