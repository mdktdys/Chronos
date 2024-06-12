import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Updater extends ChangeNotifier {
  AppUpdateInfo? _updateInfo;
  AppUpdateResult? result;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      GetIt.I.get<Talker>().info(_updateInfo);
      GetIt.I.get<Talker>().info(_updateInfo!.updateAvailability);
      if (_updateInfo!.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        if (_updateInfo!.flexibleUpdateAllowed) {
          result = await InAppUpdate.startFlexibleUpdate();
          GetIt.I.get<Talker>().info(result);
          InAppUpdate.completeFlexibleUpdate();
          GetIt.I.get<Talker>().info("Updated");
        }

        if (_updateInfo!.immediateUpdateAllowed) {
          result = await InAppUpdate.performImmediateUpdate();
          GetIt.I.get<Talker>().info(result);
        }
      }
    } catch (e) {
      GetIt.I.get<Talker>().critical(e.toString());
    }
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
