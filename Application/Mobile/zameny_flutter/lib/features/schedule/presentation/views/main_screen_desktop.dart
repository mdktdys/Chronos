import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/schedule/presentation/views/schedule_screen.dart';
import 'package:zameny_flutter/features/schedule/presentation/widgets/desktop_side_bar.dart';
import 'package:zameny_flutter/features/settings/settings_screen.dart';
import 'package:zameny_flutter/features/timetable/timetable_screen.dart';
import 'package:zameny_flutter/features/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class DesktopView extends ConsumerWidget {
  const DesktopView({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(width: 64),
            Expanded(
              child: PageView(
                onPageChanged: (final int value) => provider.pageChanged(value, context),
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
            ),
          ],
        ),
        const DesktopSideBar(),
      ],
    );
  }
}
