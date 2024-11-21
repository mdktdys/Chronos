import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/export_course_tile.dart';
import 'package:zameny_flutter/secrets.dart';

import 'package:zameny_flutter/domain/Providers/sharing/sharing.dart';

class ScheduleProvider extends ChangeNotifier {
  int groupIDSeek = -1;
  int teacherIDSeek = -1;
  int cabinetIDSeek = -1;
  SearchType searchType = SearchType.group;
  DateTime navigationDate =
      DateTime.now();
  DateTime septemberFirst = DateTime(2024, 9, 2); // 1 сентября
  int currentWeek = 1;
  int todayWeek = 1;

  ScheduleProvider(BuildContext context) {
    groupIDSeek = GetIt.I.get<Data>().seekGroup ?? -1;
    teacherIDSeek = GetIt.I.get<Data>().teacherGroup ?? -1;
    cabinetIDSeek = GetIt.I.get<Data>().seekCabinet ?? -1;
    searchType = GetIt.I.get<Data>().latestSearch;

    currentWeek = ((navigationDate.difference(septemberFirst).inDays +
                septemberFirst.weekday) ~/
            7) +
        1;
    todayWeek = currentWeek;

    navigationDate = navigationDate.weekday == 7
        ? navigationDate.add(const Duration(days: 7))
        : navigationDate;
    currentWeek = navigationDate.weekday == 7 ? currentWeek + 1 : currentWeek;
  }

  int getWeekNumber(DateTime date) {
    return ((date.difference(septemberFirst).inDays + septemberFirst.weekday) ~/
            7) +
        1;
  }

  Future<void> exportSchedulePNG(BuildContext context, WidgetRef ref) async {
    List<Lesson> lessons = [];
    String searchName = '';
    switch (searchType) {
      case SearchType.cabinet:
        {
          return;
        }
      case SearchType.teacher:
        {
          final Teacher teacher = getTeacherById(teacherIDSeek);
          lessons = teacher.lessons;
          lessons.sort((a, b) => a.number > b.number ? 1 : -1);

          searchName = teacher.name;
        }
      case SearchType.group:
        {
          final Group group = getGroupById(groupIDSeek)!;
          lessons = group.lessons;
          searchName = group.name;
        }
      default:
        {
          return;
        }
    }
    final mondayLessons =
        lessons.where((element) => element.date.weekday == 1).toList();
    final tuesdayLessons =
        lessons.where((element) => element.date.weekday == 2).toList();
    final wednesdayLessons =
        lessons.where((element) => element.date.weekday == 3).toList();
    final thursdayLessons =
        lessons.where((element) => element.date.weekday == 4).toList();
    final fridayLessons =
        lessons.where((element) => element.date.weekday == 5).toList();
    final saturdayLessons =
        lessons.where((element) => element.date.weekday == 6).toList();

    final ScreenshotController controller = ScreenshotController();
    final savedFile = await controller.captureFromWidget(
        pixelRatio: 4,
        context: context,
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 600,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Расписание $searchName',
                    style: const TextStyle(
                        fontFamily: 'Ubuntu',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Понедельник ${navigationDate.day}.${navigationDate.month}',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 20,),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: mondayLessons.isNotEmpty
                                        ? mondayLessons.map((e) {
                                            const bool saturdayTime = false;
                                            const bool obedTime = false;
                                            final Course course =
                                                getCourseById(e.course)!;
                                            return ExportCourseTile(
                                                type: searchType,
                                                course: course,
                                                e: e,
                                                obedTime: obedTime,
                                                saturdayTime: saturdayTime,);
                                          }).toList()
                                        : [const ExportCourseTileEmpty()],),
                              ],),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Четверг',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 20,),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: thursdayLessons.isNotEmpty
                                        ? thursdayLessons.map((e) {
                                            const bool saturdayTime = false;
                                            const bool obedTime = false;
                                            final Course course =
                                                getCourseById(e.course)!;
                                            return ExportCourseTile(
                                                type: searchType,
                                                course: course,
                                                e: e,
                                                obedTime: obedTime,
                                                saturdayTime: saturdayTime,);
                                          }).toList()
                                        : [const ExportCourseTileEmpty()],),
                              ],),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Вторник',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 20,),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: tuesdayLessons.isNotEmpty
                                        ? tuesdayLessons.map((e) {
                                            const bool saturdayTime = false;
                                            const bool obedTime = false;
                                            final Course course =
                                                getCourseById(e.course)!;
                                            return ExportCourseTile(
                                                type: searchType,
                                                course: course,
                                                e: e,
                                                obedTime: obedTime,
                                                saturdayTime: saturdayTime,);
                                          }).toList()
                                        : [const ExportCourseTileEmpty()],),
                              ],),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Пятница',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 20,),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: fridayLessons.isNotEmpty
                                        ? fridayLessons.map((e) {
                                            const bool saturdayTime = false;
                                            const bool obedTime = false;
                                            final Course course =
                                                getCourseById(e.course)!;
                                            return ExportCourseTile(
                                                type: searchType,
                                                course: course,
                                                e: e,
                                                obedTime: obedTime,
                                                saturdayTime: saturdayTime,);
                                          }).toList()
                                        : [const ExportCourseTileEmpty()],),
                              ],),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Среда',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 20,),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: wednesdayLessons.isNotEmpty
                                        ? wednesdayLessons.map((e) {
                                            const bool saturdayTime = false;
                                            const bool obedTime = false;
                                            final Course course =
                                                getCourseById(e.course)!;
                                            return ExportCourseTile(
                                                type: searchType,
                                                course: course,
                                                e: e,
                                                obedTime: obedTime,
                                                saturdayTime: saturdayTime,);
                                          }).toList()
                                        : [const ExportCourseTileEmpty()],),
                              ],),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Суббота',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 20,),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: saturdayLessons.isNotEmpty
                                        ? saturdayLessons.map((e) {
                                            const bool saturdayTime = true;
                                            const bool obedTime = false;
                                            final Course course =
                                                getCourseById(e.course)!;
                                            return ExportCourseTile(
                                                type: searchType,
                                                course: course,
                                                e: e,
                                                obedTime: obedTime,
                                                saturdayTime: saturdayTime,);
                                          }).toList()
                                        : [const ExportCourseTileEmpty()],),
                              ],),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),);

    final String name = 'Расписание $searchName';
    ref.watch(sharingProvier).shareFile(text: name, files: [savedFile]);
  }

  void toggleWeek(int days, BuildContext context) {
    currentWeek += days;
    if (currentWeek < 1) {
      currentWeek = 1;
    } else {
      navigationDate = navigationDate.add(Duration(days: days > 0 ? 7 : -7));
    }
    dateSwitched(context);
  }

  DateTime getStartOfWeek(DateTime week) {
    final DateTime monday = week.subtract(Duration(days: week.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime getEndOfWeek(DateTime week) {
    final DateTime sunday = week
        .subtract(Duration(days: week.weekday - 1))
        .add(const Duration(days: 6));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
  }

  void groupSelected(int groupID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedGroup', groupID);
    GetIt.I.get<SharedPreferences>().setString('SearchType', 'Group');
    groupIDSeek = groupID;
    data.seekGroup = groupID;
    data.latestSearch = SearchType.group;
    searchType = SearchType.group;
    loadWeekSchedule(context);
  }

  void loadWeekSchedule(BuildContext context) async {
    final DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    final DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    final DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    final DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadGroupWeek(
        groupID: groupIDSeek, dateStart: startOfWeek, dateEnd: endOfWeek,),);
    notifyListeners();
  }

  void teacherSelected(int teacherID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedTeacher', teacherID);
    GetIt.I.get<SharedPreferences>().setString('SearchType', 'Teacher');
    teacherIDSeek = teacherID;
    data.teacherGroup = teacherID;
    data.latestSearch = SearchType.teacher;
    searchType = SearchType.teacher;
    loadWeekTeahcerSchedule(context);
  }

  void cabinetSelected(int cabinetID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedCabinet', cabinetID);
    GetIt.I.get<SharedPreferences>().setString('SearchType', 'Cabinet');
    cabinetIDSeek = cabinetID;
    data.seekCabinet = cabinetID;
    data.latestSearch = SearchType.cabinet;
    searchType = SearchType.cabinet;
    loadCabinetWeekSchedule(context);
  }

  void loadCabinetWeekSchedule(BuildContext context) async {
    final DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    final DateTime sunday = monday.add(const Duration(days: 6));

    final DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    final DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadCabinetWeek(
          cabinetID: cabinetIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ),);
    notifyListeners();
  }

  void loadWeekTeahcerSchedule(BuildContext context) async {
    final DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    final DateTime sunday = monday.add(const Duration(days: 6));

    final DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    final DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadTeacherWeek(
          teacherID: teacherIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ),);
    notifyListeners();
  }

  void dateSwitched(context) async {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == SearchType.teacher) {
      teacherSelected(dat.teacherGroup!, context);
    }
    if (dat.latestSearch == SearchType.cabinet) {
      cabinetSelected(dat.seekCabinet!, context);
    }
    if (dat.latestSearch == SearchType.group) {
      groupSelected(dat.seekGroup!, context);
    }
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  String searchDiscribtion() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == SearchType.teacher) {
      final Teacher teacher = getTeacherById(dat.teacherGroup!);
      return "${teacher.name}${IS_DEV? ' ${teacher.id}' : ''}";
    }
    if (dat.latestSearch == SearchType.cabinet) {
      final Cabinet cabinet = getCabinetById(dat.seekCabinet!);
      return "${cabinet.name}${IS_DEV? ' ${cabinet.id}' : ''}";
    }
    if (dat.latestSearch == SearchType.group) {
      final Group? group = getGroupById(dat.seekGroup!);
      return "${group?.name}${IS_DEV? ' ${group?.id}' : ''}";
    }
    return 'Not found';
  }

  String getSearchTypeNamed() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == SearchType.teacher) {
      return 'Преподаватель';
    }
    if (dat.latestSearch == SearchType.cabinet) {
      return 'Кабинет';
    }
    if (dat.latestSearch == SearchType.group) {
      return 'Группа';
    }
    return 'Not found';
  }
}
