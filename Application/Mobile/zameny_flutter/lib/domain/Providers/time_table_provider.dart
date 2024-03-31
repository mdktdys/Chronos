import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TimeTableProvider extends ChangeNotifier {

  double getHeight() {
    Talker talker = GetIt.I.get<Talker>();

    DateTime now = DateTime.now();

    int startOfDay =
        DateTime(now.year, now.month, now.day, 7, 50).millisecondsSinceEpoch;
    int endOfDay =
        DateTime(now.year, now.month, now.day, 19, 50).millisecondsSinceEpoch;
    int totalDuration = endOfDay - startOfDay;

    int currentTime = now.millisecondsSinceEpoch;

    int progress = currentTime - startOfDay;

    talker.debug(startOfDay);
    talker.debug(endOfDay);
    talker.debug(progress);
    talker.debug(totalDuration);
    talker.debug(progress / totalDuration);

    return clampDouble(progress / totalDuration, 0, 1.0);
  }
}
