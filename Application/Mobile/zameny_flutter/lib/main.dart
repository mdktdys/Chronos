import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/app.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
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
    const Portal(child: MyApp()),
  );
}

Future<void> getTime() async {
  var res = await Dio()
      .get('http://worldtimeapi.org/api/timezone/Asia/Yekaterinburg');
  if (res.statusCode == 200) {
    DateTime networkTime = DateTime.parse(res.data['datetime'])
        .add(Duration(seconds: res.data['raw_offset']));
    Duration networkOffset = networkTime.difference(DateTime.now());
    GetIt.I.get<Data>().networkOffset = networkOffset;
  }
}
