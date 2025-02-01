import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zameny_flutter/features/timetable/widgets/timings_tile.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/new/providers/timings_provider.dart';
import 'package:zameny_flutter/new/widgets/skeletonized_provider.dart';
import 'package:zameny_flutter/shared/widgets/failed_load_widget.dart';

class TimeTable extends ConsumerWidget {
  const TimeTable({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {

    // return FailedLoadWidget(
    //   onClicked: () {
    //     ref.invalidate(timingsProvider);
    //   },
    //   error: 'sample',
    // );

    return SkeletonizedProvider<List<LessonTimings>>(
      provider: timingsProvider,
      fakeData: TimingsNotifier.fake,
      data: (final data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: data.map((final LessonTimings timing) {
            return TimingTile(timing: timing);
          }).toList(),
        );
      },
      error: (final o, final e) {
        return FailedLoadWidget(
          onClicked: () {
        ref.invalidate(timingsProvider);
      },
          error: 'error'
        );
        return const Text('data');
      },
    );
  }
}
