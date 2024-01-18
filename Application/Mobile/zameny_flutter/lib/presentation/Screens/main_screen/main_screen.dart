import 'dart:ui';

import 'package:flutter/material.dart';

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
    pageController = PageController(initialPage: 0);

    super.initState();
  }

  _setPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(children: [
        PageView(
          controller: pageController,
          children: const [ScheduleScreen(), ExamsScreen(), SettingsScreen()],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    border: const Border(
                        top: BorderSide(
                            color: Color.fromARGB(255, 30, 118, 233),
                            width: 1))),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BottomNavigationItem(
                          index: 0,
                          onTap: _setPage,
                          icon: Icons.school_rounded,
                          text: "Schedule",
                        ),
                        BottomNavigationItem(
                          index: 1,
                          onTap: _setPage,
                          icon: Icons.code_rounded,
                          text: "Exams",
                        ),
                        BottomNavigationItem(
                          index: 2,
                          onTap: _setPage,
                          icon: Icons.settings,
                          text: "Settings",
                        ),
                      ],
                    ),
                  ),
                ))),
      ]),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final int index;
  final Function onTap;
  final IconData icon;
  final String text;
  const BottomNavigationItem(
      {super.key,
      required this.index,
      required this.onTap,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          onTap.call(index);
        },
        child: Container(
            height: 50,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 30, 118, 233),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 28, 95, 182),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 6,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                )
              ]),
            )),
      ),
    );
  }
}
