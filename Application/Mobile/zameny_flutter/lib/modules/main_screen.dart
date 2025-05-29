import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/modules/schedule/presentation/views/main_screen_desktop.dart';
import 'package:zameny_flutter/modules/schedule/presentation/views/mobile/main_screen_mobile.dart';
import 'package:zameny_flutter/new/providers/bottom_sheets_provider.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/widgets/adaptive_layout.dart';

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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: AdaptiveLayout(
        desktop: () => const DesktopView(),
        mobile: () => const MobileView(),
      ),
    );
  }
}
