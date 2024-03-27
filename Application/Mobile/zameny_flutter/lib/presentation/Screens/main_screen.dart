import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/timetable_screen.dart';
import 'package:zameny_flutter/presentation/Widgets/main_screen/bottom_navigation_item.dart';
import 'schedule_screen.dart';
import 'settings_screen.dart';

class MainScreenWrapper extends StatelessWidget {
  const MainScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Stack(children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: PageView(
                  onPageChanged: (value) => provider.pageChanged(value),
                  controller: provider.pageController,
                  children: const [
                    TimeTableWrapper(),
                    ScheduleWrapper(),
                    //ExamsScreen(),
                    SettingsScreen()
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(10),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: const Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 30, 118, 233),
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                        color:
                                            Color.fromARGB(255, 30, 118, 233),
                                        width: 1)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: BottomNavigationItem(
                                      enabled: true,
                                      index: 0,
                                      onTap: () => provider.setPage(0),
                                      icon: "assets/icon/notification.svg",
                                      text: "Звонки",
                                    ),
                                  ),
                                  Expanded(
                                    child: BottomNavigationItem(
                                      enabled: true,
                                      index: 1,
                                      onTap: () => provider.setPage(1),
                                      icon:
                                          "assets/icon/vuesax_linear_note.svg",
                                      text: "Расписание",
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: BottomNavigationItem(
                                  //     enabled: false,
                                  //     index: 2,
                                  //     onTap: _setPage,
                                  //     icon:
                                  //         "assets/icon/vuesax_linear_award.svg",
                                  //     text: "Экзамены",
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: BottomNavigationItem(
                                      enabled: true,
                                      index: 2,
                                      onTap: () => provider.setPage(2),
                                      icon:
                                          "assets/icon/vuesax_linear_setting-2.svg",
                                      text: "Настройки",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ))),
          ]),
        ),
      ),
    );
  }
}
