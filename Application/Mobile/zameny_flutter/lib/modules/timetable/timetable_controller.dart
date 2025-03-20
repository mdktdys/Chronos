import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zameny_flutter/modules/timetable/time_table_provider.dart';
part 'timetable_controller.g.dart';

@riverpod
TimetableController timetableController(final Ref ref) {
  return TimetableController(ref: ref);
}

class TimetableController {
  late final TimeTableNotifier notifier;
  Ref ref;

  TimetableController({required this.ref}) {
    notifier = ref.read(timeTableNotifierProvider.notifier);
  }

  void toggleObed() {
    notifier.toggleObed();
  }

  void toggleSaturday() {
    notifier.toggleSaturday();
  }
}
