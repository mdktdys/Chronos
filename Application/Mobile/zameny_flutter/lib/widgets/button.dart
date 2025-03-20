import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class Button extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onClicked;

  factory Button.primary({
    required final String text,
    required final VoidCallback onClicked,
    required final BuildContext context
  }){
    return Button(
      text: text,
      color: Theme.of(context).colorScheme.primary,
      onClicked: onClicked,
      textStyle: context.styles.ubuntuWhite20,
    );
  }

  const Button({
    required this.color,
    required this.text,
    this.onClicked,
    this.textStyle,
    super.key
  });

  @override
  Widget build(final BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onClicked,
        child: Container(
          alignment: Alignment.center,
          height: 56,
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
