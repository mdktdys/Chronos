
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/app.dart';
import 'package:zameny_flutter/configs/firebase_options.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Services/splashscreen/splashscreen.dart';
import 'package:zameny_flutter/secrets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final supabase = await Supabase.initialize(
    url: API_URL,
    anonKey: API_ANON_KEY,
  );

  final SupabaseClient client = supabase.client;
  GetIt.I.registerSingleton<SupabaseClient>(client);

  removeSplashScreen();

  // context.callMethod('rremoveSplashFromWeb');
  FlutterNativeSplash.remove();

  // await FirebaseApi().initNotifications();

  final Talker talker = TalkerFlutter.init();
  GetIt.I.registerSingleton<Talker>(talker);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  final Data data = Data.fromShared();
  GetIt.I.registerSingleton<Data>(data); 

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: Portal(
        child: Application(),
      ),
    ),
  );
}
