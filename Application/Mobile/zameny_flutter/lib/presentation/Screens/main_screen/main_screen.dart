import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ota_update/ota_update.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';

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
    context.read<ScheduleBloc>().add(LoadInitial());
    super.initState();

    _checkupdate();
  }

  _checkupdate() async {
    Update? update = await Api().checkUpdate();
    if (update != null) {
      showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.background,
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 80,
                            shadows: [
                              Shadow(
                                  color: Theme.of(context).colorScheme.primary,
                                  blurRadius: 12)
                            ],
                          ),
                          Text(
                            "New update!",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Ubuntu',
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      )),
                  Expanded(
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              update.desc,
                              style:
                                  const TextStyle(fontFamily: 'Ubuntu', fontSize: 18),
                            ),
                          ))),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.2)),
                                padding: const EdgeInsets.all(8),
                                child: const Center(
                                    child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              OtaUpdate()
                                  .execute(update.link,
                                      destinationFilename:
                                          'flutter_hello_world.apk')
                                  .listen((event) {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: const Text("Downloading...",style: TextStyle(color: Colors.white),),backgroundColor: Theme.of(context).colorScheme.background,));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary),
                              padding: const EdgeInsets.all(8),
                              child: const Center(
                                child: Text("Download",
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            );
          });
      try {} catch (err) {
        GetIt.I.get<Talker>().critical(err);
      }
    }
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
      body: SafeArea(
        child: Center(
          child: Stack(children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: PageView(
                  controller: pageController,
                  children: const [ScheduleScreen(), ExamsScreen(), SettingsScreen()],
                ),
              ),
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
        ),
      ),
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
