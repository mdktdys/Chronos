import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfall/flutterfall.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/configs/images.dart';
import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/presentation/Screens/main_screen.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

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

  @override
  Widget build(_) {
    // ref.watch(inAppUpdateProvider).checkForUpdate();
    return ProviderScope(
            child: MaterialApp(
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
                title: "Замены уксивтика",
                debugShowCheckedModeBanner: false,
                theme: ref.watch(lightThemeProvider).theme,
                themeMode: ref.watch(lightThemeProvider).themeMode,
                home: AnnotatedRegion(
                  value: SystemUiOverlayStyle(statusBarColor: ref.watch(lightThemeProvider).theme?.canvasColor, statusBarIconBrightness: ref.watch(lightThemeProvider).theme?.brightness == Brightness.dark ? Brightness.light : Brightness.dark, systemNavigationBarIconBrightness: ref.watch(lightThemeProvider).theme?.brightness == Brightness.dark ? Brightness.light : Brightness.dark ),
                  child: BlocProvider(
                      create: (context) => ScheduleBloc(),
                      child: Scaffold(
                          body: Stack(
                            children: [
                                const MainScreenWrapper(),
                              IgnorePointer(
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: MediaQuery.sizeOf(context).height,
                                  child: const FlutterFall(
                                    particleImage: [Images.autumnLeaves]),
                                ),
                              ),
                            ],
                          ))
                          ),
                ))
      
    );
  }
}


                // color: pr.Provider.of<ThemeProvider>(context)
                //     .theme
                //     .colorScheme
                //     .surface,