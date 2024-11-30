import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart';

import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/domain/Providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/app/views/main_screen.dart';
import 'package:zameny_flutter/presentation/Widgets/snowfall.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // ref.watch(inAppUpdateProvider).checkForUpdate();
    final Brightness brightness = ref.watch(lightThemeProvider).theme?.brightness == Brightness.dark 
      ? Brightness.light
      : Brightness.dark;
    return ProviderScope(
      child: MaterialApp(
      builder: (final context, final child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        title: 'Замены уксивтика',
        debugShowCheckedModeBanner: false,
        theme: ref.watch(lightThemeProvider).theme,
        themeMode: ref.watch(lightThemeProvider).themeMode,
        home: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: ref.watch(lightThemeProvider).theme?.canvasColor,
            statusBarIconBrightness: brightness,
            systemNavigationBarIconBrightness: brightness,
          ),
          child: ChangeNotifierProvider(
              create: (final context) => MainProvider(),
              child: BlocProvider(
              create: (final context) => ScheduleBloc(),
              child: const Scaffold(
                body: Stack(
                  children: [
                    MainScreen(),
                    SnowFall(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
