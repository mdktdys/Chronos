import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/mobile_bottom_bar.dart';
import 'package:zameny_flutter/features/settings/settings_screen.dart';
import 'package:zameny_flutter/features/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/new/screens/time_table_screen/time_table_screen.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class MobileView extends ConsumerWidget {
  const MobileView({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return Stack(
      children: [
        PageView(
          onPageChanged: (final value) => provider.pageChanged(value, context),
          physics: provider.pageViewScrollEnabled
            ? null
            : const NeverScrollableScrollPhysics(),
          controller: provider.pageController,
          children: const [
            TimeTableScreenWrapper(),
            ScheduleScreen(),
            ZamenaScreenWrapper(),
            // MapScreen(),
            SettingsScreenWrapper(),
          ],
        ),
        const AnimatedBottomBar(),
      ],
    );
  }
}
