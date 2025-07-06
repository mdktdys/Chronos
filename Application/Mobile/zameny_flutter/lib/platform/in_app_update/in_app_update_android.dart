import 'package:flutter/material.dart';

import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';
import 'package:flutter_rustore_update/pigeons/rustore.dart';

class Updater extends ChangeNotifier {
  Future<void> checkForUpdate() async {
    RustoreUpdateClient.info().then((final UpdateInfo info) {
      RustoreUpdateClient.listener((final value) {
        if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
          RustoreUpdateClient.completeUpdateFlexible().catchError((final err) {
          });
        }
      });
      RustoreUpdateClient.download().then((final value) {
      }).catchError((final err) {
      });

    }).catchError((final err) {
    });
  }
}
