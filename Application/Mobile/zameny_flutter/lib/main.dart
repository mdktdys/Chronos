import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zameny_flutter/config/firebase_options.dart';
import 'package:zameny_flutter/main/app.dart';
import 'package:zameny_flutter/new/repository/fastapi_repository.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';
import 'package:zameny_flutter/secrets.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await registerServices();

  runApp(const ProviderScope(child: App()));
}

Future<void> registerServices() async {
  final Supabase supabase = await Supabase.initialize(
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

  final DataRepository repository = FastAPIDataRepository();
  GetIt.I.registerSingleton<DataRepository>(repository);

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
