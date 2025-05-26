import 'package:flutter/material.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/widgets/covorking_timetable_block.dart';
import 'package:zameny_flutter/widgets/current_timing_timer.dart';
import 'package:zameny_flutter/widgets/screen_appear_builder.dart.dart';
import 'package:zameny_flutter/widgets/time_options.dart';
import 'package:zameny_flutter/widgets/time_table_header.dart';
import 'package:zameny_flutter/widgets/timetable.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return ScreenAppearBuilder(
      showNavbar: true,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
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
                      SizedBox(height: 8),
                      CovorkingTimeTableBlock(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
