import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';

class Api {
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
    GetIt.I.get<Talker>().debug(dat.cabinets);
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
  }

  Future<void> loadZamenasTypes(
      {required int groupID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client
        .from('ZamenasType')
        .select('*')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    for (var element in data) {
      ZamenasType zamenaType = ZamenasType.fromMap(element);
      dat.zamenaTypes.add(zamenaType);
    }
  }

  Future<List<Zamena>> loadZamenas(
      {required int groupID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = await client
        .from('Zamenas')
        .select('*')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    List<Zamena> zamenaBuffer = [];
    for (var element in data) {
      Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
      if (!dat.zamenas.any((element) => element.id == zamena.id)) {
        dat.zamenas.add(zamena);
      }
    }
    return zamenaBuffer;
  }

  Future<void> loadDefaultSchedule({required int groupID}) async {
    final dat = GetIt.I.get<Data>();
    try {
      if (groupID == -1) {
        throw Exception("invalid group selected");
      }
      final client = GetIt.I.get<SupabaseClient>();

      List<dynamic> data =
          await client.from('defaultLessons').select('*').eq('group', groupID);

      Group group = dat.groups.where((element) => element.id == groupID).first;
      group.lessons = [];
      for (var element in data) {
        Lesson lesson = Lesson.fromMap(element);
        group.lessons.add(lesson);
      }
    } catch (err) {
      Group group = dat.groups.where((element) => element.id == groupID).first;
      group.lessons = [];
    }
  }

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