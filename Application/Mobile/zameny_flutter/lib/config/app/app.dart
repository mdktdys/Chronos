import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/routes/app_router.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/shared/providers/in_app_update/in_app_update_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.watch(inAppUpdateProvider).checkForUpdate();
    final ThemeSettings themeProvider = ref.watch(lightThemeProvider);
    final ThemeData? theme = themeProvider.theme;

    final Brightness brightness = themeProvider.theme?.brightness == Brightness.dark 
      ? Brightness.light
      : Brightness.dark;

    return Portal(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: brightness,
          statusBarIconBrightness: brightness,
          statusBarColor: theme?.canvasColor,
        ),
        child: MaterialApp.router(
          routerConfig: ref.watch(routerProvider),
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.theme,
          title: 'Замены уксивтика',
        )
      ),
    );
  }
}
