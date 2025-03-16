import 'package:flutter/material.dart';

class MyTheme extends ThemeExtension<MyTheme> {
  final Color backgroundColor;

  MyTheme({
    required this.backgroundColor,
  });

  @override
  MyTheme copyWith({
    final Color? backgroundColor,
  }) {
    return MyTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  MyTheme lerp(final ThemeExtension<MyTheme> other, final double t) {
    if (other is! MyTheme) {
      return this;
    }
    return MyTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ?? other.backgroundColor,
    );
  }
}
