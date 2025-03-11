import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/config/constants.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
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
                  SizedBox(height: 8),
                  CovorkingTimeTableBlock(),
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

class CovorkingTimeTableBlock extends ConsumerWidget {
  const CovorkingTimeTableBlock({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          'Коворкинг',
          style: context.styles.ubuntuPrimaryBold18,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ПН - ЧТ 8:00-18:00',
                style: context.styles.ubuntu,
                textAlign: TextAlign.left,
              ),
              Text(
                'ПТ 8:00-17:00',
                style: context.styles.ubuntu,
                textAlign: TextAlign.left,
              ),
              Text(
                'СБ Выходной',
                style: context.styles.ubuntu,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        )
      ],
    );
  }
}
