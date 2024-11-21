import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Updater extends ChangeNotifier {

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    try {
      GetIt.I.get<Talker>().info('web update check');
    } catch (e) {
      GetIt.I.get<Talker>().critical(e.toString());
    }
  }
}
