import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/timetable/widgets/timings_tile.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/shared/providers/time_table_provider.dart';

class TimeTable extends ConsumerWidget {
  const TimeTable({
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final timings = ref.watch(timingProvider);

    return timings.when(
      data: (final data) => Column(
        mainAxisSize: MainAxisSize.min,
        children: data.map((final LessonTimings timing) {
          return TimingTile(timing: timing);
        }).toList(),
      ),
      error: (final error, final stackTrace) => const SizedBox(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
