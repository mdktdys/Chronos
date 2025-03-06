import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/features/timetable/timetable_screen.dart';
import 'package:zameny_flutter/features/timetable/widgets/current_timing_timer.dart';
import 'package:zameny_flutter/features/timetable/widgets/time_options.dart';
import 'package:zameny_flutter/features/timetable/widgets/time_table_header.dart';
import 'package:zameny_flutter/features/timetable/widgets/timetable.dart';

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
