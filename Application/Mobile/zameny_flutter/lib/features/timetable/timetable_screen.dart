import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/features/timetable/widgets/current_timing_timer.dart';
import 'package:zameny_flutter/features/timetable/widgets/time_options.dart';
import 'package:zameny_flutter/features/timetable/widgets/time_table_header.dart';
import 'package:zameny_flutter/features/timetable/widgets/timetable.dart';
import 'package:zameny_flutter/shared/providers/main_provider.dart';

class ScreenAppearBuilder extends ConsumerWidget {
  final bool showNavbar;
  final Widget child;
  
  const ScreenAppearBuilder({
    required this.child,
    this.showNavbar = false,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if(showNavbar) {
      WidgetsBinding.instance.addPostFrameCallback((final _){ref.read(mainProvider).updateScrollDirection(ScrollDirection.forward);});
    }
    return child.animate(
      effects: [
        const FadeEffect(
          duration: Duration(milliseconds: 100),
          end: 1.0,
          begin: 0.0
        ),
      ]
    );
  }
}

class TimeTableScreenWrapper extends StatelessWidget {
  const TimeTableScreenWrapper({super.key});

  @override
  Widget build(final BuildContext context) {
    return const ScreenAppearBuilder(
      showNavbar: true,
      child: TimeTableScreen(),
    );
  }
}

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.maxWidthDesktop),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TimeTableHeader(),
                  SizedBox(height: 10),
                  // CurrentTimingTimer(),
                  TimeOptions(),
                  SizedBox(height: 10),
                  TimeTable(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
