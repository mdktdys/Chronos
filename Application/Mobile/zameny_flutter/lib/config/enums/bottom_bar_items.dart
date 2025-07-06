import 'package:zameny_flutter/config/images.dart';

class BottomBarModel {
  final int index;
  final String icon;
  final String title;
  final bool enabled;
  final String activeicon;
  final String path;

  BottomBarModel({
    required this.index,
    required this.activeicon,
    required this.icon,
    required this.title,
    required this.enabled,
    required this.path,
  });
}

List<BottomBarModel> model = [
  BottomBarModel(
    index: 0,
    activeicon: Images.notificationBold,
    icon: Images.notification,
    title: 'Звонки',
    path: 'timetable',
    enabled: true,
  ),
  BottomBarModel(
    index: 1,
    icon: Images.note,
    title: 'Расписание',
    activeicon: Images.noteBold,
    path: 'schedule',
    enabled: true,
  ),
  BottomBarModel(
    index: 2,
    activeicon: Images.zamenaBold,
    icon: Images.zamena,
    title: 'Замены',
    path: 'zamenas',
    enabled: true,
  ),
  BottomBarModel(
    index: 3,
    activeicon: Images.locationBold,
    icon: Images.location,
    title: 'Карта',
    path: 'map',
    enabled: true,
  ),
  BottomBarModel(
    index: 4,
    activeicon: Images.settingsBold,
    icon: Images.settings,
    title: 'Настройки',
    path: 'settings',
    enabled: true,
  ),
  // BottomBarModel(
  //   index: 4,
  //   enabled: true,
  //   activeicon: 'assets/icon/brush_bold.svg',
  //   icon: 'assets/icon/brush.svg',
  //   title: 'Пиксель',
  //   path: 'pixel',
  // )
];
