import 'package:flutter/material.dart';

import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';
import 'package:flutter_rustore_update/pigeons/rustore.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Updater extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> checkForUpdate() async {
    GetIt.I.get<Talker>().info("mobile update check");
    RustoreUpdateClient.info().then((final UpdateInfo info) {
      GetIt.I.get<Talker>().info(info);

      RustoreUpdateClient.listener((final value) {
         GetIt.I.get<Talker>().info("listener installStatus ${value.installStatus}");
         GetIt.I.get<Talker>().info("listener bytesDownloaded ${value.bytesDownloaded}");
         GetIt.I.get<Talker>().info("listener totalBytesToDownload ${value.totalBytesToDownload}");
         GetIt.I.get<Talker>().info("listener installErrorCode ${value.installErrorCode}");
      
        if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
          RustoreUpdateClient.completeUpdateFlexible().catchError((final err) {
            GetIt.I.get<Talker>().info("completeUpdateFlexible err $err");
          });
        }
      });

      RustoreUpdateClient.download().then((final value) {
         GetIt.I.get<Talker>().info("download code ${value.code}");
      }).catchError((final err) {
         GetIt.I.get<Talker>().info("download err $err");
      });

    }).catchError((final err) {
      GetIt.I.get<Talker>().info(err);
    });
  }

  void showSnack(final String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
