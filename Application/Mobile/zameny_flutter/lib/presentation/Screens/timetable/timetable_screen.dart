import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/presentation/Screens/app/providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/timetable/widgets/time_options.dart';
import 'package:zameny_flutter/presentation/Screens/timetable/widgets/timetable.dart';
import 'package:zameny_flutter/presentation/Widgets/timetable_screen/current_timing_timer.dart';
import 'package:zameny_flutter/presentation/Widgets/timetable_screen/time_table_header.dart';

class TimeTableWrapper extends ConsumerWidget {
  const TimeTableWrapper({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((final _){
      ref.read(mainProvider).updateScrollDirection(ScrollDirection.forward);
    });
    return const TimeTableScreen().animate(
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

class TimeTableScreen extends ConsumerWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TimeTableHeader(),
                  SizedBox(height: 10),
                  CurrentTimingTimer(),
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
