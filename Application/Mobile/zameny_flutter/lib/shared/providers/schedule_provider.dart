import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';

final scheduleSettingsProvider = ChangeNotifierProvider<ScheduleSettingsNotifier>((final ref) {
  return ScheduleSettingsNotifier();
});
class ScheduleSettingsNotifier extends ChangeNotifier {
  bool isShowZamena = true;

  void notify() {
    notifyListeners();
  }
}

final searchItemProvider = StateProvider<SearchItem?>((final Ref ref) {
  return null;
});

final navigationDateProvider = StateNotifierProvider<NavigationDateNotifier, DateTime>(
  (final ref) => NavigationDateNotifier(),
);

class NavigationDateNotifier extends StateNotifier<DateTime> {
  NavigationDateNotifier() : super(_initializeDate());

  void toggleWeek(final int days) {
    state = state.add(Duration(days: days));
  }

  static DateTime _initializeDate() {
    final DateTime date = DateTime.now();
    if (date.weekday == 7) {
      return date.add(const Duration(days: 1));
    }
    return date;
  }
}


class ScheduleProvider extends ChangeNotifier {
  Ref ref;

  ScheduleProvider({required this. ref});

  // Future<void> exportSchedulePNG(final BuildContext context, final WidgetRef ref) async {
  //   List<Lesson> lessons = [];
  //   String searchName = '';
  //   switch (searchType) {
  //     case SearchType.cabinet:
  //       {
  //         return;
  //       }
  //     case SearchType.teacher:
  //       {
  //         final Teacher teacher = getTeacherById(teacherIDSeek);
  //         lessons = teacher.lessons;
  //         lessons.sort((final a, final b) => a.number > b.number ? 1 : -1);

  //         searchName = teacher.name;
  //       }
  //     case SearchType.group:
  //       {
  //         final Group group = getGroupById(groupIDSeek)!;
  //         lessons = group.lessons;
  //         searchName = group.name;
  //       }
  //   }

  //   final mondayLessons = lessons.where((final element) => element.date.weekday == 1).toList();
  //   final tuesdayLessons = lessons.where((final element) => element.date.weekday == 2).toList();
  //   final wednesdayLessons = lessons.where((final element) => element.date.weekday == 3).toList();
  //   final thursdayLessons = lessons.where((final element) => element.date.weekday == 4).toList();
  //   final fridayLessons = lessons.where((final element) => element.date.weekday == 5).toList();
  //   final saturdayLessons = lessons.where((final element) => element.date.weekday == 6).toList();

  //   final ScreenshotController controller = ScreenshotController();
  //   final savedFile = await controller.captureFromWidget(
  //       pixelRatio: 4,
  //       context: context,
  //       Container(
  //         color: Theme.of(context).colorScheme.surface,
  //         padding: const EdgeInsets.all(16),
  //         child: SizedBox(
  //           width: 600,
  //           child: FittedBox(
  //             fit: BoxFit.scaleDown,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   'Расписание $searchName',
  //                   style: context.styles.ubuntuWhiteBold24
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Понедельник ${navigationDate.day}.${navigationDate.month}',
  //                                 style: context.styles.ubuntuWhite20,
  //                               ),
  //                               Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: mondayLessons.isNotEmpty
  //                                       ? mondayLessons.map((final e) {
  //                                           const bool saturdayTime = false;
  //                                           const bool obedTime = false;
  //                                           final Course course =
  //                                               getCourseById(e.course)!;
  //                                           return ExportCourseTile(
  //                                               type: searchType,
  //                                               course: course,
  //                                               e: e,
  //                                               obedTime: obedTime,
  //                                               saturdayTime: saturdayTime,);
  //                                         }).toList()
  //                                       : [const ExportCourseTileEmpty()],),
  //                             ],),
  //                         const SizedBox(
  //                           width: 20,
  //                         ),
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Четверг',
  //                                 style: context.styles.ubuntuWhite20,
  //                               ),
  //                               Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: thursdayLessons.isNotEmpty
  //                                       ? thursdayLessons.map((final e) {
  //                                           const bool saturdayTime = false;
  //                                           const bool obedTime = false;
  //                                           final Course course =
  //                                               getCourseById(e.course)!;
  //                                           return ExportCourseTile(
  //                                               type: searchType,
  //                                               course: course,
  //                                               e: e,
  //                                               obedTime: obedTime,
  //                                               saturdayTime: saturdayTime,);
  //                                         }).toList()
  //                                       : [const ExportCourseTileEmpty()],),
  //                             ],),
  //                       ],
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Вторник',
  //                                 style: context.styles.ubuntuWhite20,
  //                               ),
  //                               Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: tuesdayLessons.isNotEmpty
  //                                       ? tuesdayLessons.map((final e) {
  //                                           const bool saturdayTime = false;
  //                                           const bool obedTime = false;
  //                                           final Course course =
  //                                               getCourseById(e.course)!;
  //                                           return ExportCourseTile(
  //                                               type: searchType,
  //                                               course: course,
  //                                               e: e,
  //                                               obedTime: obedTime,
  //                                               saturdayTime: saturdayTime,);
  //                                         }).toList()
  //                                       : [const ExportCourseTileEmpty()],),
  //                             ],),
  //                         const SizedBox(
  //                           width: 20,
  //                         ),
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Пятница',
  //                                 style: context.styles.ubuntuWhite20,
  //                               ),
  //                               Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: fridayLessons.isNotEmpty
  //                                       ? fridayLessons.map((final e) {
  //                                           const bool saturdayTime = false;
  //                                           const bool obedTime = false;
  //                                           final Course course =
  //                                               getCourseById(e.course)!;
  //                                           return ExportCourseTile(
  //                                               type: searchType,
  //                                               course: course,
  //                                               e: e,
  //                                               obedTime: obedTime,
  //                                               saturdayTime: saturdayTime,);
  //                                         }).toList()
  //                                       : [const ExportCourseTileEmpty()],),
  //                             ],),
  //                       ],
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Среда',
  //                                 style: context.styles.ubuntuWhite20,
  //                               ),
  //                               Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: wednesdayLessons.isNotEmpty
  //                                       ? wednesdayLessons.map((final e) {
  //                                           const bool saturdayTime = false;
  //                                           const bool obedTime = false;
  //                                           final Course course =
  //                                               getCourseById(e.course)!;
  //                                           return ExportCourseTile(
  //                                               type: searchType,
  //                                               course: course,
  //                                               e: e,
  //                                               obedTime: obedTime,
  //                                               saturdayTime: saturdayTime,);
  //                                         }).toList()
  //                                       : [const ExportCourseTileEmpty()],),
  //                             ],),
  //                         const SizedBox(
  //                           width: 20,
  //                         ),
  //                         Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Суббота',
  //                                 style: context.styles.ubuntuWhite20,
  //                               ),
  //                               Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: saturdayLessons.isNotEmpty
  //                                       ? saturdayLessons.map((final e) {
  //                                           const bool saturdayTime = true;
  //                                           const bool obedTime = false;
  //                                           final Course course =
  //                                               getCourseById(e.course)!;
  //                                           return ExportCourseTile(
  //                                               type: searchType,
  //                                               course: course,
  //                                               e: e,
  //                                               obedTime: obedTime,
  //                                               saturdayTime: saturdayTime,);
  //                                         }).toList()
  //                                       : [const ExportCourseTileEmpty()],),
  //                             ],),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),);

  //   final String name = 'Расписание $searchName';
  //   ref.watch(sharingProvier).shareFile(text: name, files: [savedFile]);
  // }

  void searchItemSelected(final SearchItem item, final BuildContext context) {
    ref.read(searchItemProvider.notifier).state = item;
    context.goNamed('/', pathParameters: {
      'type': item.typeId.toString(),
      'id': item.id.toString()
    });
  }

}
