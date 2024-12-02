import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/presentation/Screens/timetable/widgets/timings_tile.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: GetIt.I.get<Data>().timings.map((final LessonTimings timing) {
        return TimingTile(timing: timing);
      }).toList(),
    );
  }
}
