import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zameny_flutter/domain/Providers/adaptive.dart';
import 'package:zameny_flutter/domain/Services/bottom_sheets_provider.dart';
import 'package:zameny_flutter/presentation/Screens/app/providers/main_provider.dart';
import 'package:zameny_flutter/presentation/Screens/schedule_screen.dart';
import 'package:zameny_flutter/presentation/Screens/settings/settings_screen.dart';
import 'package:zameny_flutter/presentation/Screens/timetable/timetable_screen.dart';
import 'package:zameny_flutter/presentation/Screens/zamena_screen/exams_screen.dart';
import 'package:zameny_flutter/presentation/Widgets/main_screen/bottom_navigation_item.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.read(bottomSheetsProvider).setupContext(context);
    
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (final BuildContext context, final BoxConstraints constraints) {
            if (!Adaptive.isDesktop(context)) {
              return const MobileView();
            }

            return const DesktopView();
          },
        ),
      ),
    );
  }
}

class DesktopView extends ConsumerWidget {
  const DesktopView({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return Row(
      children: [
        Container(
          width: 260,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)))),
          child: Column(
            children: model.map((final BottomBarModel tile) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.01),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    onTap: () {
                      provider.setPage(tile.index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tile.title, style: context.styles.ubuntu20,),
                          SvgPicture.asset(tile.icon, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),)
                        ],
                      ),
                    ),
                  )),
              );
            }).toList()
          )
        ),
        Expanded(
          child: PageView(
            onPageChanged: (final value) => provider.pageChanged(value),
            physics: provider.pageViewScrollEnabled
              ? null
              : const NeverScrollableScrollPhysics(),
            controller: provider.pageController,
            children: const [
              TimeTableScreenWrapper(),
              ScheduleWrapper(),
              ZamenaScreenWrapper(),
              // MapScreen(),
              SettingsScreenWrapper(),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileView extends ConsumerWidget {
  const MobileView({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return Stack(
      children: [
        PageView(
          onPageChanged: (final value) => provider.pageChanged(value),
          physics: provider.pageViewScrollEnabled
            ? null
            : const NeverScrollableScrollPhysics(),
          controller: provider.pageController,
          children: const [
            TimeTableScreenWrapper(),
            ScheduleWrapper(),
            ZamenaScreenWrapper(),
            // MapScreen(),
            SettingsScreenWrapper(),
          ],
        ),
        const AnimatedBottomBar(),
      ],
    );
  }
}

class AnimatedBottomBar extends ConsumerWidget {
  const AnimatedBottomBar({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool shouldShow = ref.watch(mainProvider).bottomBarShow;
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: !shouldShow,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: shouldShow ? 1 : 0,
          child: const BottomBar(),
        ),
      ),
    );
  }
}

class BottomBar extends ConsumerWidget {
  const BottomBar({
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    return ClipRect(
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
                    bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                    top: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(model.length, (final index) {
                      return Expanded(
                        child: BottomNavigationItem(
                          activeicon: model[index].activeicon,
                          enabled: model[index].enabled,
                          index: index,
                          onTap: (final int index) {
                            provider.setPage(index);
                          },
                          icon: model[index].icon,
                          text: model[index].title,
                        ),
                      );
                    }
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomBarModel {
  final int index;
  final String icon;
  final String title;
  final bool enabled;
  final String activeicon;

  BottomBarModel({
    required this.index,
    required this.activeicon,
    required this.icon,
    required this.title,
    required this.enabled,
  });
}

List<BottomBarModel> model = [
  BottomBarModel(
      index: 0,
      activeicon: 'assets/icon/boldnotification.svg',
      icon: 'assets/icon/notification.svg',
      title: 'Звонки',
      enabled: true,),
  BottomBarModel(
    index: 1,
      icon: 'assets/icon/vuesax_linear_note.svg',
      title: 'Расписание',
      activeicon: 'assets/icon/note.svg',
      enabled: true,),
  BottomBarModel(
      index: 2,
      activeicon: 'assets/icon/zamena_bold.svg',
      icon: 'assets/icon/zamena.svg',
      title: 'Замены',
      enabled: true,),
  // BottomBarModel(
  //     activeicon: 'assets/icon/vuesax_linear_location.svg',
  //     icon: 'assets/icon/vuesax_linear_location.svg',
  //     title: 'Карта',
  //     enabled: true,),
  BottomBarModel(
      index: 3,
      activeicon: 'assets/icon/setting-2.svg',
      icon: 'assets/icon/vuesax_linear_setting-2.svg',
      title: 'Настройки',
      enabled: true,),
];
