import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
