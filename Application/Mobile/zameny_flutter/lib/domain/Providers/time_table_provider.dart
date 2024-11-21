import 'package:flutter/foundation.dart';

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

  // double getHeight() {
  //   Talker talker = GetIt.I.get<Talker>();

  //   DateTime now = DateTime.now();

  //   int startOfDay =
  //       DateTime(now.year, now.month, now.day, 7, 50).millisecondsSinceEpoch;
  //   int endOfDay =
  //       DateTime(now.year, now.month, now.day, 19, 50).millisecondsSinceEpoch;
  //   int totalDuration = endOfDay - startOfDay;

  //   int currentTime = now.millisecondsSinceEpoch;

  //   int progress = currentTime - startOfDay;

  //   talker.debug(startOfDay);
  //   talker.debug(endOfDay);
  //   talker.debug(progress);
  //   talker.debug(totalDuration);
  //   talker.debug(progress / totalDuration);

  //   return clampDouble(progress / totalDuration, 0, 1.0);
  // }
}
