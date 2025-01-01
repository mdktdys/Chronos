import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/shared/providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/features/schedule/presentation/views/main_screen_desktop.dart';
import 'package:zameny_flutter/features/schedule/presentation/views/mobile/main_screen_mobile.dart';
import 'package:zameny_flutter/shared/providers/adaptive.dart';
import 'package:zameny_flutter/shared/providers/bottom_sheets_provider.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';
import 'package:zameny_flutter/shared/widgets/snowfall.dart';

class ApplicationBase extends ConsumerWidget {
  final int page;

  const ApplicationBase({
    required this.page,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((final _) => ref.read(mainProvider).setPage(page));
    final Brightness brightness = ref.watch(lightThemeProvider).theme?.brightness == Brightness.dark 
      ? Brightness.light
      : Brightness.dark;

    return AnnotatedRegion(  
      value: SystemUiOverlayStyle(
        statusBarColor: ref.watch(lightThemeProvider).theme?.canvasColor,
        systemNavigationBarIconBrightness: brightness,
        statusBarIconBrightness: brightness,
      ),
      child: BlocProvider(
        create: (final BuildContext context) => ScheduleBloc(),
        child: const Scaffold(
          body: Stack(
            children: [
              MainScreen(),
              SnowFall(),
            ],
          ),
        ),
      ),
    );
  }
}


class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.read(bottomSheetsProvider).setupContext(context);
    
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (final BuildContext context, final BoxConstraints constraints) {
            return Adaptive.isDesktop(context)
              ? const DesktopView()
              : const MobileView();
          },
        ),
      ),
    );
  }
}
