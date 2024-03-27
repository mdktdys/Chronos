import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TimeTableProvider extends ChangeNotifier {
  double getHeight() {
    Talker talker = GetIt.I.get<Talker>();

    int todayDay = DateTime.now().day;
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    int startOfDay =
        DateTime(year, month, todayDay, 7, 50).millisecondsSinceEpoch;
    int endOfDay =
        DateTime(year, month, todayDay, 19, 50).millisecondsSinceEpoch;
    int totalDuration = endOfDay - startOfDay;

    int currentTime = DateTime.now().millisecondsSinceEpoch;

    int progress = currentTime - startOfDay;

    talker.debug(progress);
    talker.debug(progress / totalDuration);

    return clampDouble(-progress / totalDuration, 0, 1.0);
  }
}
