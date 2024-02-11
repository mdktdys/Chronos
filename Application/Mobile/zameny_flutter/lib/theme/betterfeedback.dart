import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

class MyBetterFeedBack extends StatelessWidget {
  final Widget child;
  final ThemeData theme;
  const MyBetterFeedBack({super.key, required this.child, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      theme: FeedbackThemeData(
          bottomSheetDescriptionStyle:
              TextStyle(color: theme.colorScheme.inverseSurface),
          activeFeedbackModeColor: theme.colorScheme.primary,
          dragHandleColor: theme.colorScheme.inverseSurface,
          colorScheme: theme.colorScheme,
          background: theme.colorScheme.background.withOpacity(0.7),
          feedbackSheetColor: theme.colorScheme.background),
      child: child,
    );
  }
}
