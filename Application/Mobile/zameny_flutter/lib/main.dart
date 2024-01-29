import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart' as pr;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Providers/theme_provider.dart';
import 'package:zameny_flutter/presentation/Screens/main_screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ojbsikxdqcbuvamygezd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qYnNpa3hkcWNidXZhbXlnZXpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE4MDY4OTgsImV4cCI6MjAxNzM4Mjg5OH0.jV7YiBEePGjybsL8qqXWeQ9PX8_3yctpq14Gfwh39JM',
  );

  SupabaseClient client = Supabase.instance.client;
  GetIt.I.registerSingleton<SupabaseClient>(client);

  Talker talker = Talker();
  GetIt.I.registerSingleton<Talker>(talker);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  GetIt.I.registerSingleton<PackageInfo>(packageInfo);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Data data = Data.fromShared(context);
    GetIt.I.registerSingleton<Data>(data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return pr.MultiProvider(
      providers: [
        pr.ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider.fromData(),
        ),
      ],
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
        return MaterialApp(
          title: "",
          debugShowCheckedModeBanner: false,
          theme: pr.Provider.of<ThemeProvider>(context).theme,
          home: BlocProvider(
            create: (context) => ScheduleBloc(),
            child: const MainScreen(),
          ),
        );
      },
    );
  }
}
