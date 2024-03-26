import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'dart:math';

class TimeTableProvider extends ChangeNotifier {
  double getHeight() {
    Talker talker = GetIt.I.get<Talker>();

    int startOfDay = DateTime(2024, 3, 26, 7, 50).millisecondsSinceEpoch;
    int endOfDay = DateTime(2024, 3, 26, 19, 50).millisecondsSinceEpoch;
    int totalDuration = endOfDay - startOfDay;

    int currentTime = DateTime.now().millisecondsSinceEpoch;

    int progress = currentTime - startOfDay;

    talker.debug(progress);
    talker.debug(progress/ totalDuration);

    return min(1.0, progress/ totalDuration);
}

}
