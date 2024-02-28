
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart' as pr;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/Services/Models/zamenaFileLink.dart';
import 'package:zameny_flutter/presentation/Providers/search_provider.dart';

class Update {
  int id;
  int version;
  String link;
  String desc;
  Update({
    required this.id,
    required this.version,
    required this.link,
    required this.desc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'version': version,
      'link': link,
      'desc': desc,
    };
  }

  factory Update.fromMap(Map<String, dynamic> map) {
    return Update(
      id: map['id'] as int,
      version: map['version'] as int,
      link: map['link'] as String,
      desc: map['desc'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Update.fromJson(String source) =>
      Update.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Api {

  Future<void> loadZamenaFileLinks(
      {required DateTime start, required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    dat.zamenaFileLinks = [];
    for (var element in data) {
      ZamenaFileLink zamenaLink = ZamenaFileLink.fromMap(element);
      dat.zamenaFileLinks.add(zamenaLink);
    }
    GetIt.I.get<Talker>().debug(dat.cabinets);
  }

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

    Future<void> loadGroups(BuildContext context) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Groups').select('*');

    dat.groups = [];
    for (var element in data) {
      Group groupName = Group.fromMap(element);
      dat.groups.add(groupName);
    }

    pr.Provider.of<SearchProvider>(context, listen: false).updateSearchItems();
  }


  Future<void> loadTeachers(BuildContext context) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = List.empty();

    data = await client.from('Teachers').select('*');

    dat.teachers = [];
    for (var element in data) {
      Teacher teacher = Teacher.fromMap(element);
      dat.teachers.add(teacher);
    }

    pr.Provider.of<SearchProvider>(context, listen: false).updateSearchItems();
  }

  Future<void> loadCabinets(BuildContext context) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = await client.from('Cabinets').select('*');

    dat.cabinets = [];
    for (var element in data) {
      Cabinet cab = Cabinet.fromMap(element);
      dat.cabinets.add(cab);
    }

    pr.Provider.of<SearchProvider>(context, listen: false).updateSearchItems();
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
      {required int groupID,
      required DateTime start,
      required DateTime end}) async {
    if (groupID == -1) {
      return [];
    }
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = await client
        .from('Zamenas')
        .select('*')
        .eq('group', groupID)
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

  Future<List<Zamena>> loadTeacherZamenas(
      {required int teacherID,
      required DateTime start,
      required DateTime end}) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
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
    final dat = GetIt.I.get<Data>();
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
