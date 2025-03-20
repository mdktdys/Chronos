import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';

final norificationProvider = ChangeNotifierProvider<NotificationManager>((final ref) {
  return NotificationManager();
});

class NotificationManager extends ChangeNotifier {
  String? fcmToken;

  Future<void> subscribe(final SearchType type, final int id, final String token) async {
    await Future.delayed(Duration.zero);
    return;
  }

  NotificationManager() {
    fcmToken = GetIt.I.get<SharedPreferences>().getString('FCM');

    // if (fcmToken != null) {
    //   FirebaseApi().initPushNotifications(context);
    // }

    notifyListeners();
  }

  Future<void> enableNotifications(final BuildContext context) async {
    // fcmToken = await FirebaseApi().initNotifications(context);
    notifyListeners();
  }
}

abstract class FirebaseApi {
  late final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    await _firebaseMessaging.requestPermission(provisional: kIsWeb ? false : true);
    final String? fCMToken = await _firebaseMessaging.getToken(vapidKey: 'BNkpZqKNiMicNxbQP139ob4Jk7br__2pEAMln-0WvI3yudGcaPSNnICvYvQ2ooEstZQVut1hOhuZX2YFqK-LqL0',);
    return fCMToken;

    // GetIt.I.get<Talker>().info('$fCMToken');

    // GetIt.I.get<SharedPreferences>().setString('FCM', fCMToken ?? '');

    // try {
    //   await GetIt.I.get<SupabaseClient>().from('MessagingClients').insert(
    //       {'token': fCMToken, 'clientID': kIsWeb ? 1 : 2, 'subType': -1, 'subID': -1},);
    //   GetIt.I.get<Talker>().info('Subscribed to global channel');

    //   initPushNotifications(context);

    //   return fCMToken;
    // } catch (e) {
    //   GetIt.I.get<Talker>().critical(e.toString());
    //   return fCMToken;
    // } 
  }

  Future<void> handleMessage(final RemoteMessage? message, final BuildContext context) async {
    log("message");
    
    GetIt.I.get<Talker>().debug(message);
    await Future.delayed(Duration.zero);
    if (message == null){
      return;
    }

    if(!context.mounted){
      return;
    }

    await showDialog(context: context, builder: (final context) {
      return Text(message.data.toString());
    }, );

    GetIt.I.get<Talker>().debug(message.data.toString());
  }

  Future initPushNotifications(final BuildContext context) async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic('main');
      FirebaseMessaging.onBackgroundMessage((final message) => handleMessage(message,context));

      // FirebaseMessaging.instance.getInitialMessage().then((final message) => handleMessage(message, context));
      // FirebaseMessaging.onMessageOpenedApp.listen((final message) => handleMessage(message, context));
    } else {}
  }
}
