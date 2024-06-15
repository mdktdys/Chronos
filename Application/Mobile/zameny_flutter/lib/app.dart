import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/domain/Providers/in_app_update/in_app_update_provider.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:provider/provider.dart' as pr;
import 'package:zameny_flutter/presentation/Screens/main_screen.dart';
import 'domain/Providers/theme_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    Data data = Data.fromShared(context);
    GetIt.I.registerSingleton<Data>(data);
    super.initState();
  }

  // syncTime() async {
  //   await getTime();
  // }

  @override
  Widget build(BuildContext context) {
    return pr.MultiProvider(
      providers: [
        pr.ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider.fromData(),
        ),
      ],
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 18, 21, 37)));

        return ProviderScope(
            child: MaterialApp(
                builder: (context, child) {
                  ref.watch(inAppUpdateProvider).checkForUpdate();

                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
                color: pr.Provider.of<ThemeProvider>(context)
                    .theme
                    .colorScheme
                    .surface,
                title: "Замены уксивтика",
                debugShowCheckedModeBanner: false,
                theme: pr.Provider.of<ThemeProvider>(context).theme,
                home: BlocProvider(
                    create: (context) => ScheduleBloc(),
                    child: const Scaffold(
                        backgroundColor: Color.fromARGB(255, 18, 21, 37),
                        body: MainScreenWrapper()))));
      },
    );
  }
}
