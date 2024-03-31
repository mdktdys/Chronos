import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/app.dart';
import 'package:zameny_flutter/secrets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: API_URL,
    anonKey: API_ANON_KEY,
  );

  SupabaseClient client = Supabase.instance.client;
  GetIt.I.registerSingleton<SupabaseClient>(client);

  Talker talker = TalkerFlutter.init();
  GetIt.I.registerSingleton<Talker>(talker);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  runApp(
    const MyApp(),
  );
}
