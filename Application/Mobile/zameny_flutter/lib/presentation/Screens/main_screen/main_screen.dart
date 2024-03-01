import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zameny_flutter/presentation/Screens/timetable_screen/timetable_screen.dart';
import 'package:zameny_flutter/presentation/Widgets/bottom_navigation_item.dart';
import '../exams_screen/exams_screen/exams_screen.dart';
import '../schedule_screen/schedule_screen.dart';
import '../settings_screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedPageIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 1);
    super.initState();
  }

  _setPage(int index) {
    int selectedPageIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuint);
  }

  _pageChanged(int value) {
    int selectedPageIndex = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Stack(children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: PageView(
                  onPageChanged: (value) => _pageChanged(value),
                  controller: pageController,
                  children: const [
                    TimeTableScreen(),
                    ScheduleWrapper(),
                    ExamsScreen(),
                    SettingsScreen()
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: 70,
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
                                      index: 0,
                                      onTap: _setPage,
                                      icon: "assets/icon/notification.svg",
                                      text: "Звонки",
                                    ),
                                  ),
                                  Expanded(
                                    child: BottomNavigationItem(
                                      index: 1,
                                      onTap: _setPage,
                                      icon:
                                          "assets/icon/vuesax_linear_note.svg",
                                      text: "Расписание",
                                    ),
                                  ),
                                  Expanded(
                                    child: BottomNavigationItem(
                                      index: 2,
                                      onTap: _setPage,
                                      icon:
                                          "assets/icon/vuesax_linear_award.svg",
                                      text: "Экзамены",
                                    ),
                                  ),
                                  Expanded(
                                    child: BottomNavigationItem(
                                      index: 3,
                                      onTap: _setPage,
                                      icon:
                                          "assets/icon/vuesax_linear_setting-2.svg",
                                      text: "Настройки",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
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
