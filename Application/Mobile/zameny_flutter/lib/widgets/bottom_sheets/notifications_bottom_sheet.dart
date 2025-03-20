import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/widgets/button.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Уведомления",
            textAlign: TextAlign.center,
            style: context.styles.ubuntuPrimaryBold24
          ),
          Button.primary(
            text: "Сохранить",
            onClicked: () => log("asd"),
            context: context,
          ),
        ],
      ),
    );
  }
}
