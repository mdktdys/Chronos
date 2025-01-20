import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/config/app/app.dart';
import 'package:zameny_flutter/config/firebase_options.dart';
import 'package:zameny_flutter/secrets.dart';
import 'package:zameny_flutter/services/Data.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final supabase = await Supabase.initialize(
    anonKey: API_ANON_KEY,
    url: API_URL,
  );

  final SupabaseClient client = supabase.client;
  GetIt.I.registerSingleton<SupabaseClient>(client);

  usePathUrlStrategy();

  final Talker talker = TalkerFlutter.init();
  GetIt.I.registerSingleton<Talker>(talker);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  final Data data = Data.fromShared();
  GetIt.I.registerSingleton<Data>(data); 

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: Application()));
}
