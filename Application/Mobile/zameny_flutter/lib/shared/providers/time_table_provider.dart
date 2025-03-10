import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/services/Api.dart';

final timingProvider = FutureProvider<List<LessonTimings>>((final ref) async {
  return await Api.getTimings();
});

final timeTableProvider = ChangeNotifierProvider<TimeTableProvider>((final ref) {
  return TimeTableProvider();
});

class TimeTableProvider extends ChangeNotifier {
  bool obed = false;
  bool saturday = false;

  void toggleObed() {
    obed = !obed;
    notifyListeners();
  }

  void toggleSaturday() {
    saturday = !saturday;
    notifyListeners();
  }
}
