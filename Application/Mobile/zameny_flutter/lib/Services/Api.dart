import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart' as pr;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/Services/Models/zamenaFileLink.dart';
import 'package:zameny_flutter/presentation/Providers/search_provider.dart';

class Api {
  Future<List<Lesson>> loadWeekSchedule(
      {required int groupID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();

    List<dynamic> data = await client
        .from('Paras')
        .select('id,group,number,course,teacher,cabinet,date')
        .eq('group', groupID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    List<Lesson> weekLessons = [];
    for (var element in data) {
      Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  Future<List<Lesson>> loadWeekTeacherSchedule(
      {required int teacherID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();

    List<dynamic> data = await client
        .from('Paras')
        .select('id,group,number,course,teacher,cabinet,date')
        .eq('teacher', teacherID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    List<Lesson> weekLessons = [];
    for (var element in data) {
      Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  Future<List<Lesson>> loadWeekCabinetSchedule(
      {required int cabinetID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();

    List<dynamic> data = await client
        .from('Paras')
        .select('id,group,number,course,teacher,cabinet,date')
        .eq('cabinet', cabinetID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    List<Lesson> weekLessons = [];
    for (var element in data) {
      Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  Future<void> loadGroups() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Groups').select('*');

    dat.groups = [];
    for (var element in data) {
      Group groupName = Group.fromMap(element);
      dat.groups.add(groupName);
    }
  }

  Future<void> loadTeachers() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = List.empty();

    data = await client.from('Teachers').select('*');

    dat.teachers = [];
    for (var element in data) {
      Teacher teacher = Teacher.fromMap(element);
      dat.teachers.add(teacher);
    }
  }

  Future<void> loadCabinets() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = await client.from('Cabinets').select('*');

    dat.cabinets = [];
    for (var element in data) {
      Cabinet cab = Cabinet.fromMap(element);
      dat.cabinets.add(cab);
    }
  }

  Future<void> loadHolidays(DateTime start, DateTime end) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client
        .from('Holidays')
        .select('*')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    for (var element in data) {
      Holiday holiday = Holiday.fromMap(element);
      dat.holidays.add(holiday);
    }
  }

  Future<void> loadLiquidation(
      List<int> groupsID, DateTime start, DateTime end) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client
        .from('Liquidation')
        .select('*')
        .in_('group', groupsID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());
    for (var element in data) {
      Liquidation liquidation = Liquidation.fromMap(element);
      dat.liquidations.add(liquidation);
    }
  }

  Future<void> loadTimings() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('scheduleTimetable').select('*');
    dat.timings = [];
    for (var element in data) {
      LessonTimings timing = LessonTimings.fromMap(element);
      dat.timings.add(timing);
    }
    dat.timings.sort(((a, b) => a.number - b.number));
  }

  Future<void> loadZamenasFull(
      List<int> groupsID, DateTime start, DateTime end) async {
    final dat = GetIt.I.get<Data>();

    //тестова проверка на уже существующие
    if (dat.zamenasFull.any((element) =>
        element.date.isBefore(end) && element.date.isAfter(start))) {
      return;
    }

    final client = GetIt.I.get<SupabaseClient>();
    List<dynamic> data = await client
        .from("ZamenasFull")
        .select("*")
        .in_("group", groupsID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());
    GetIt.I.get<Talker>().debug(data);
    for (var element in data) {
      ZamenaFull zamena = ZamenaFull.fromMap(element);
      dat.zamenasFull.add(zamena);
    }
  }

  Future<void> loadZamenaFileLinks(
      {required DateTime start, required DateTime end}) async {
    final dat = GetIt.I.get<Data>();

    //тестова проверка на уже существующие
    if (dat.zamenaFileLinks.any((element) =>
        element.date.isBefore(end) && element.date.isAfter(start))) {
      return;
    }

    final client = GetIt.I.get<SupabaseClient>();

    List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date,created_at')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    for (var element in data) {
      GetIt.I.get<Talker>().debug(element);
      ZamenaFileLink zamenaLink = ZamenaFileLink.fromMap(element);
      dat.zamenaFileLinks.add(zamenaLink);
    }
  }

  // Future<void> loadZamenasTypes(
  //     {required int groupID,
  //     required DateTime start,
  //     required DateTime end}) async {
  //   final client = GetIt.I.get<SupabaseClient>();
  //   final dat = GetIt.I.get<Data>();

  //   List<dynamic> data = await client
  //       .from('ZamenasType')
  //       .select('*')
  //       .lte('date', end.toIso8601String())
  //       .gte('date', start.toIso8601String())
  //       .order('date');

  //   for (var element in data) {
  //     ZamenasType zamenaType = ZamenasType.fromMap(element);
  //     dat.zamenaTypes.add(zamenaType);
  //   }
  // }

  Future<List<Zamena>> loadZamenas(
      {required List<int> groupsID,
      required DateTime start,
      required DateTime end}) async {
    if (groupsID.isEmpty == -1) {
      return [];
    }
    final client = GetIt.I.get<SupabaseClient>();
    GetIt.I.get<Data>();
    List<dynamic> data = await client
        .from('Zamenas')
        .select('*')
        .in_('group', groupsID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    List<Zamena> zamenaBuffer = [];
    for (var element in data) {
      Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
    }
    return zamenaBuffer;
  }

  Future<List<Zamena>> loadTeacherZamenas(
      {required int teacherID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();
    GetIt.I.get<Data>();
    List<dynamic> data = await client
        .from('Zamenas')
        .select('*')
        .eq('teacher', teacherID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    List<Zamena> zamenaBuffer = [];
    for (var element in data) {
      Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
      // if (!dat.zamenas.any((element) => element.id == zamena.id)) {
      //   dat.zamenas.add(zamena);
      // }
    }
    return zamenaBuffer;
  }

  Future<List<Zamena>> loadCabinetZamenas(
      {required int cabinetID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();
    GetIt.I.get<Data>();
    List<dynamic> data = await client
        .from('Zamenas')
        .select('*')
        .eq('cabinet', cabinetID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    List<Zamena> zamenaBuffer = [];
    for (var element in data) {
      Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
      // if (!dat.zamenas.any((element) => element.id == zamena.id)) {
      //   dat.zamenas.add(zamena);
      // }
    }
    return zamenaBuffer;
  }

  // Future<void> loadDefaultSchedule({required int groupID}) async {
  //   final dat = GetIt.I.get<Data>();
  //   try {
  //     if (groupID == -1) {
  //       throw Exception("invalid group selected");
  //     }
  //     final client = GetIt.I.get<SupabaseClient>();

  //     List<dynamic> data =
  //         await client.from('defaultLessons').select('*').eq('group', groupID);

  //     Group group = dat.groups.where((element) => element.id == groupID).first;
  //     group.lessons = [];
  //     for (var element in data) {
  //       Lesson lesson = Lesson.fromMap(element);
  //       group.lessons.add(lesson);
  //     }
  //   } catch (err) {
  //     Group group = dat.groups.where((element) => element.id == groupID).first;
  //     group.lessons = [];
  //   }
  // }

  Future<void> loadCourses() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Courses').select('*');

    dat.courses = [];
    for (var element in data) {
      Course course = Course.fromMap(element);
      dat.courses.add(course);
    }
  }

  Future<void> loadDepartments() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Departments').select('*');

    dat.departments = [];
    for (var element in data) {
      Department department = Department.fromMap(element);
      dat.departments.add(department);
    }
  }
}
