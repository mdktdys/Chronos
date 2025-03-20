import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/modules/schedule/presentation/views/main_screen_desktop.dart';
import 'package:zameny_flutter/modules/schedule/presentation/views/mobile/main_screen_mobile.dart';
import 'package:zameny_flutter/widgets/adaptive_layout.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return AdaptiveLayout(
      mobile: () => const MobileView(),
      desktop: () => const DesktopView(),
    );
  }
}
