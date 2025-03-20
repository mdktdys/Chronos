import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/modules/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/mobile_bottom_bar.dart';
import 'package:zameny_flutter/modules/settings/settings_screen.dart';
import 'package:zameny_flutter/modules/timetable/time_table_screen.dart';
import 'package:zameny_flutter/modules/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';

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
            TimeTableScreen(),
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
