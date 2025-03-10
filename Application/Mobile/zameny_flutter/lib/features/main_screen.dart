import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/views/main_screen_desktop.dart';
import 'package:zameny_flutter/features/schedule/presentation/views/mobile/main_screen_mobile.dart';
import 'package:zameny_flutter/shared/layouts/adaptive_layout.dart';
import 'package:zameny_flutter/shared/providers/bottom_sheets_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.read(bottomSheetsProvider).setupContext(context);
    
    return Scaffold(
      body: SafeArea(
        child: AdaptiveLayout(
          desktop: () => const DesktopView(),
          mobile: () => const MobileView(),
        )
      ),
    );
  }
}
