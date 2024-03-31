import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Services/tools.dart';
import 'package:zameny_flutter/domain/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/domain/Models/models.dart';

class ScheduleProvider extends ChangeNotifier {
  int groupIDSeek = -1;
  int teacherIDSeek = -1;
  int cabinetIDSeek = -1;
  SearchType searchType = SearchType.group;
  DateTime navigationDate = DateTime.now();
  DateTime septemberFirst = DateTime(2023, 9, 1); // 1 сентября
  int currentWeek = 1;
  int todayWeek = 1;

  ScheduleProvider(BuildContext context) {
    groupIDSeek = GetIt.I.get<Data>().seekGroup ?? -1;
    teacherIDSeek = GetIt.I.get<Data>().teacherGroup ?? -1;

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

  chas() async {
    DateTime from = DateTime(2023, 1, 1);
    DateTime to = DateTime.now();
    List<dynamic> res = await GetIt.I
        .get<SupabaseClient>()
        .from('Zamenas')
        .select('*')
        .gt('date', from)
        .lte('date', to);
    GetIt.I.get<Talker>().good(res);
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
    DateTime monday = week.subtract(Duration(days: week.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime getEndOfWeek(DateTime week) {
    DateTime sunday = week
        .subtract(Duration(days: week.weekday - 1))
        .add(const Duration(days: 6));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
  }

  void groupSelected(int groupID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedGroup', groupID);
    groupIDSeek = groupID;
    data.seekGroup = groupID;
    data.latestSearch = SearchType.group;
    searchType = SearchType.group;
    loadWeekSchedule(context);
  }

  void loadWeekSchedule(BuildContext context) async {
    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadGroupWeek(
        groupID: groupIDSeek, dateStart: startOfWeek, dateEnd: endOfWeek));
    notifyListeners();
  }

  void teacherSelected(int teacherID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedTeacher', teacherID);
    teacherIDSeek = teacherID;
    data.teacherGroup = teacherID;
    data.latestSearch = SearchType.teacher;
    searchType = SearchType.teacher;
    loadWeekTeahcerSchedule(context);
  }

  void cabinetSelected(int cabinetID, BuildContext context) {
    final data = GetIt.I.get<Data>();
    GetIt.I.get<SharedPreferences>().setInt('SelectedCabinet', cabinetID);
    cabinetIDSeek = cabinetID;
    data.seekCabinet = cabinetID;
    data.latestSearch = SearchType.cabinet;
    searchType = SearchType.cabinet;
    loadCabinetWeekSchedule(context);
  }

  void loadCabinetWeekSchedule(BuildContext context) async {
    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadCabinetWeek(
          cabinetID: cabinetIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
    notifyListeners();
  }

  void loadWeekTeahcerSchedule(BuildContext context) async {
    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(LoadTeacherWeek(
          teacherID: teacherIDSeek,
          dateStart: startOfWeek,
          dateEnd: endOfWeek,
        ));
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

  String searchDiscribtion() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == SearchType.teacher) {
      Teacher teacher = getTeacherById(dat.teacherGroup!);
      return teacher.name;
    }
    if (dat.latestSearch == SearchType.cabinet) {
      Cabinet cabinet = getCabinetById(dat.seekCabinet!);
      return cabinet.name;
    }
    if (dat.latestSearch == SearchType.group) {
      Group? group = getGroupById(dat.seekGroup!);
      return group == null ? "Error" : group.name;
    }
    return "Not found";
  }

  String getSearchTypeNamed() {
    final Data dat = GetIt.I.get<Data>();
    if (dat.latestSearch == SearchType.teacher) {
      return "Преподаватель";
    }
    if (dat.latestSearch == SearchType.cabinet) {
      return "Кабинет";
    }
    if (dat.latestSearch == SearchType.group) {
      return "Группа";
    }
    return "Not found";
  }
}
