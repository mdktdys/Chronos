import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/Services/tools.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Widgets/CourseTile.dart';

class ScheduleProvider extends ChangeNotifier {
  int groupIDSeek = -1;
  int teacherIDSeek = -1;
  int cabinetIDSeek = -1;
  SearchType searchType = SearchType.group;
  late FlutterSoundPlayer? player;
  DateTime navigationDate = DateTime.now();
  DateTime septemberFirst = DateTime(2023, 9, 1); // 1 сентября
  int currentWeek = 1;
  int todayWeek = 1;

  ScheduleProvider(BuildContext context) {
    initPlayer();
    groupIDSeek = GetIt.I.get<Data>().seekGroup ?? -1;
    teacherIDSeek = GetIt.I.get<Data>().teacherGroup ?? -1;

    currentWeek = ((navigationDate.difference(septemberFirst).inDays +
                septemberFirst.weekday) ~/
            7) +
        1;

    todayWeek = currentWeek;
  }

  initPlayer() async {
    player = await FlutterSoundPlayer().openPlayer();
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
    if (player != null) {
      if (groupIDSeek == 2) {
        await player!.startPlayer(
            fromURI: "https://www.donland.ru/upload/uf/4e9/rf_gimn_melody.mp3",
            codec: Codec.mp3);
      } else {
        player?.stopPlayer();
      }
    }

    DateTime monday =
        navigationDate.subtract(Duration(days: navigationDate.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    // Устанавливаем время для понедельника и воскресенья
    DateTime startOfWeek = DateTime(monday.year, monday.month, monday.day);
    DateTime endOfWeek =
        DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

    context.read<ScheduleBloc>().add(FetchData(
        groupID: groupIDSeek,
        dateStart: startOfWeek,
        dateEnd: endOfWeek,
        context: context));
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
    if (player != null) {
      player?.stopPlayer();
    }
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
    if (player != null) {
      player?.stopPlayer();
    }
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
      return "Препод";
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
