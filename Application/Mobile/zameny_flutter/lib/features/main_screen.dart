import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/views/main_screen_desktop.dart';
import 'package:zameny_flutter/features/schedule/presentation/views/mobile/main_screen_mobile.dart';
import 'package:zameny_flutter/shared/layouts/adaptive_layout.dart';
import 'package:zameny_flutter/shared/providers/bottom_sheets_provider.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class MainScreen extends ConsumerWidget {
  final int page;

  const MainScreen({
    required this.page,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.read(bottomSheetsProvider).setupContext(context);
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      FlutterNativeSplash.remove();
      ref.read(mainProvider).setPage(page);
    });

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: AdaptiveLayout(
              desktop: () => const DesktopView(),
              mobile: () => const MobileView(),
            )
          ),
        ],
      ),
    );
  }
}
