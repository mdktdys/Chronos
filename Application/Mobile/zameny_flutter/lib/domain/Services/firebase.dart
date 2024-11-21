import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';

final norificationProvider = ChangeNotifierProvider<NotificationManager>((ref) {
  return NotificationManager();
});

class NotificationManager extends ChangeNotifier {
  String? fcmToken;

  Future<void> subscribe(SearchType type, int id, String token) async {
    await Future.delayed(Duration.zero);
    return;
  }

  NotificationManager() {
    fcmToken = GetIt.I.get<SharedPreferences>().getString('FCM');

    if (fcmToken != null) {
      FirebaseApi().initPushNotifications();
    }

    notifyListeners();
  }

  Future<void> enableNotifications() async {
    fcmToken = await FirebaseApi().initNotifications();
    notifyListeners();
  }
}

class FirebaseApi {
  late final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission(provisional: kIsWeb ? false : true);
    final fCMToken = await _firebaseMessaging.getToken(
        vapidKey:
            'BNkpZqKNiMicNxbQP139ob4Jk7br__2pEAMln-0WvI3yudGcaPSNnICvYvQ2ooEstZQVut1hOhuZX2YFqK-LqL0',);

    GetIt.I.get<Talker>().info('$fCMToken');

    GetIt.I.get<SharedPreferences>().setString('FCM', fCMToken ?? '');

    try {
      await GetIt.I.get<SupabaseClient>().from('MessagingClients').insert(
          {'token': fCMToken, 'clientID': kIsWeb ? 1 : 2, 'subType': -1, 'subID': -1},);
      GetIt.I.get<Talker>().info('Subscribed to global channel');

      initPushNotifications();

      return fCMToken;
    } catch (e) {
      GetIt.I.get<Talker>().critical(e.toString());
      return fCMToken;
    } 
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    GetIt.I.get<Talker>().debug(message);
    await Future.delayed(Duration.zero);
    if (message == null){
      return;
    }

    GetIt.I.get<Talker>().debug(message.data.toString());
  }

  Future initPushNotifications() async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic('main');
      FirebaseMessaging.onBackgroundMessage(handleMessage);
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    } else {}
  }
}
