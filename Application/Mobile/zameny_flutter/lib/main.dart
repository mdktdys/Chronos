import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/app.dart';
import 'package:zameny_flutter/firebase_options.dart';
import 'package:zameny_flutter/secrets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:js';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Supabase.initialize(
    url: API_URL,
    anonKey: API_ANON_KEY,
  );

  context.callMethod("a");

  // context.callMethod('rremoveSplashFromWeb');
  //FlutterNativeSplash.remove();

  //await FirebaseApi().initNotifications();
  SupabaseClient client = Supabase.instance.client;
  GetIt.I.registerSingleton<SupabaseClient>(client);

  Talker talker = TalkerFlutter.init();
  GetIt.I.registerSingleton<Talker>(talker);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(child: Portal(child: MyApp())),
  );
}

// Future<void> getTime() async {
//   var res = await Dio()
//       .get('http://worldtimeapi.org/api/timezone/Asia/Yekaterinburg');
//   if (res.statusCode == 200) {
//     DateTime networkTime = DateTime.parse(res.data['datetime'])
//         .add(Duration(seconds: res.data['raw_offset']));
//     Duration networkOffset = networkTime.difference(DateTime.now());
//     GetIt.I.get<Data>().networkOffset = networkOffset;
//   }
// }
