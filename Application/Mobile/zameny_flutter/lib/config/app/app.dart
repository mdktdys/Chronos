import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/routes/app_router.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/shared/providers/in_app_update/in_app_update_provider.dart';

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.watch(inAppUpdateProvider).checkForUpdate();
    return Portal(
      child: MaterialApp.router(
      themeMode: ref.watch(lightThemeProvider).themeMode,
      theme: ref.watch(lightThemeProvider).theme,
      debugShowCheckedModeBanner: false,
      title: 'Замены уксивтика',
      routerConfig: router,
      builder: (final BuildContext context, final child) {
        
        WidgetsBinding.instance.addPostFrameCallback((final _) {
          FlutterNativeSplash.remove();
        });
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
