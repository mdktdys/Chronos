import 'package:flutter/material.dart';



extension TextThemeTools on ThemeData{
  ThemeData applyCustomTextTheme() {
    return copyWith(extensions: [CustomTextStyles(theme: this)]);
  }
}

extension CustomTextStylesExtension on BuildContext {
  CustomTextStyles get styles {
    return Theme.of(this).extension<CustomTextStyles>()!;
  }
}

class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
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

  late final TextStyle ubuntuInverseSurface14 = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 14,
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

  late final TextStyle ubuntuPrimaryBold14 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 14,
    color: theme.colorScheme.primary,
  );

  late final TextStyle ubuntuPrimaryBold18 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Ubuntu',
    fontSize: 18,
    color: theme.colorScheme.primary,
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

  late final TextStyle ubuntu14 = const TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 14,
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
