
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
    activeicon: 'assets/icon/boldnotification.svg',
    icon: 'assets/icon/notification.svg',
    title: 'Звонки',
    path: 'timetable',
    enabled: true,
  ),
  BottomBarModel(
    index: 1,
    icon: 'assets/icon/vuesax_linear_note.svg',
    title: 'Расписание',
    activeicon: 'assets/icon/note.svg',
    path: 'schedule',
    enabled: true,
  ),
  BottomBarModel( 
    index: 2,
    activeicon: 'assets/icon/zamena_bold.svg',
    icon: 'assets/icon/zamena.svg',
    title: 'Замены',
    path: 'zamenas',
    enabled: true,
  ),
  // BottomBarModel(
  //     index: 4,
  //     activeicon: 'assets/icon/vuesax_linear_location.svg',
  //     icon: 'assets/icon/vuesax_linear_location.svg',
  //     title: 'Карта',
  //     enabled: true,),
  BottomBarModel(
    index: 3,
    activeicon: 'assets/icon/setting-2.svg',
    icon: 'assets/icon/vuesax_linear_setting-2.svg',
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
