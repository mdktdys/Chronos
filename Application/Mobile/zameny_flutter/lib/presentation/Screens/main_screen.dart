import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/presentation/Screens/timetable_screen.dart';
import 'package:zameny_flutter/presentation/Widgets/main_screen/bottom_navigation_item.dart';
import 'schedule_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Stack(children: [
            Center(
              child: PageView(
                onPageChanged: (value) => provider.pageChanged(value),
                controller: provider.pageController,
                children: const [
                  TimeTableWrapper(),
                  ScheduleWrapper(),
                  ZamenaScreen(),
                  SettingsScreen()
                ],
              ),
            ),
            const BottomBar(),
          ]),
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return Align(
        alignment: Alignment.bottomCenter,
        child: ClipRect(
          child: SizedBox(
            height: 90,
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
                      border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                          top: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1)),
                    ),
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: List.generate(model.length, (index) {
                          return Expanded(
                            child: BottomNavigationItem(
                              activeicon: model[index].activeicon,
                              enabled: model[index].enabled,
                              index: index,
                              onTap: (index) {
                                provider.setPage(index);
                              },
                              icon: model[index].icon,
                              text: model[index].title,
                            ),
                          );
                        })),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        )
      );
  }
}

class BottomBarModel {
  final String icon;
  final String title;
  final bool enabled;
  final String activeicon;

  BottomBarModel({
    required this.activeicon,
    required this.icon,
    required this.title,
    required this.enabled
  });
}

List<BottomBarModel> model = [
  BottomBarModel(
      activeicon: "assets/icon/boldnotification.svg",
      icon: "assets/icon/notification.svg",
      title: "Звонки",
      enabled: true),
  BottomBarModel(
      icon: "assets/icon/vuesax_linear_note.svg",
      title: "Расписание",
      activeicon: "assets/icon/note.svg",
      enabled: true),
  BottomBarModel(
      activeicon: "assets/icon/zamena_bold.svg",
      icon: "assets/icon/zamena.svg",
      title: "Замены",
      enabled: true),
  BottomBarModel(
      activeicon: "assets/icon/setting-2.svg",
      icon: "assets/icon/vuesax_linear_setting-2.svg",
      title: "Настройки",
      enabled: true)
];