import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/shared/tools.dart';
import 'package:zameny_flutter/models/models.dart';

abstract class Api {
  static Future<List<Lesson>> loadWeekSchedule(
      {required final int groupID,
      required final DateTime start,
      required final DateTime end,}) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('Paras')
        .select('id,group,number,course,teacher,cabinet,date')
        .eq('group', groupID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    final Group group = getGroupById(groupID)!;
    group.lessons = [];
    final List<Lesson> weekLessons = [];
    for (final element in data) {
      final Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
      group.lessons.add(lesson);
    }
    return weekLessons;
  }

  static Future<List<Lesson>> loadWeekTeacherSchedule(
      {required final int teacherID,
      required final DateTime start,
      required final DateTime end,}) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client.from('Paras').select('id,group,number,course,teacher,cabinet,date').eq('teacher', teacherID).lte('date', end.toIso8601String()).gte('date', start.toIso8601String());

    final List<Lesson> weekLessons = [];
    for (final element in data) {
      final Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  static Future<List<Lesson>> loadWeekCabinetSchedule(
      {required final int cabinetID,
      required final DateTime start,
      required final DateTime end,}) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('Paras')
        .select('id,group,number,course,teacher,cabinet,date')
        .eq('cabinet', cabinetID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    final List<Lesson> weekLessons = [];
    for (final element in data) {
      final Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  static Future<void> loadGroups() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    final List<dynamic> data = await client.from('Groups').select();

    dat.groups = [];
    for (final element in data) {
      final Group groupName = Group.fromMap(element);
      dat.groups.add(groupName);
    }
  }

  static Future<void> loadTeachers() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    List<dynamic> data = List.empty();

    data = await client.from('Teachers').select();

    dat.teachers = [];
    for (final element in data) {
      final Teacher teacher = Teacher.fromMap(element);
      dat.teachers.add(teacher);
    }
  }

  static Future<void> loadCabinets() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();
    final List<dynamic> data = await client.from('Cabinets').select();

    dat.cabinets = [];
    for (final element in data) {
      final Cabinet cab = Cabinet.fromMap(element);
      dat.cabinets.add(cab);
    }
  }

  static Future<void> loadHolidays(final DateTime start, final DateTime end) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    final List<dynamic> data = await client
        .from('Holidays')
        .select()
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    for (final element in data) {
      final Holiday holiday = Holiday.fromMap(element);
      dat.holidays.add(holiday);
    }
  }

  static Future<void> loadLiquidation(
      final List<int> groupsID, final DateTime start, final DateTime end,) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    final List<dynamic> data = await client
        .from('Liquidation')
        .select()
        .inFilter('group', groupsID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());
    for (final element in data) {
      final Liquidation liquidation = Liquidation.fromMap(element);
      dat.liquidations.add(liquidation);
    }
  }

  static Future<void> loadTimings() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    final List<dynamic> data = await client.from('timings').select();
    dat.timings = [];
    for (final element in data) {
      final LessonTimings timing = LessonTimings.fromMap(element);
      dat.timings.add(timing);
    }
    dat.timings.sort(((final a, final b) => a.number - b.number));
  }

  static Future<void> loadZamenasFull(
      final List<int> groupsID, final DateTime start, final DateTime end,) async {
    final dat = GetIt.I.get<Data>();

    // //тестова проверка на уже существующие
    // if (dat.zamenasFull.any((element) =>
    //     element.date.isBefore(end) && element.date.isAfter(start),)) {
    //   return;
    // }

    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client
        .from('ZamenasFull')
        .select()
        .inFilter('group', groupsID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());
    for (final element in data) {
      final ZamenaFull zamena = ZamenaFull.fromMap(element);
      dat.zamenasFull.add(zamena);
    }
  }

  static Future<List<ZamenaFileLink>> loadZamenaFileLinksByDate(
      {required final DateTime date,}) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date,created_at')
        .eq('date',date);

    final List<ZamenaFileLink> res = [];
    for (final element in data) {
      final ZamenaFileLink zamenaLink = ZamenaFileLink.fromMap(element);
      res.add(zamenaLink);
    }
    return res;
  }

  static Future<void> loadZamenaFileLinks(
      {required final DateTime start, required final DateTime end,}) async {
    final dat = GetIt.I.get<Data>();

    //тестова проверка на уже существующие
    if (dat.zamenaFileLinks.any((final element) =>
        element.date.isBefore(end) && element.date.isAfter(start),)) {
      return;
    }

    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date,created_at')
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String());

    for (final element in data) {
      final ZamenaFileLink zamenaLink = ZamenaFileLink.fromMap(element);
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

  static Future<List<ZamenaFull>> getFullZamenasByDate(final DateTime date) async {
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data =
        await client.from('ZamenasFull').select().eq('date', date);
    final List<ZamenaFull> zamenaBuffer = [];
    for (final element in data) {
      final ZamenaFull zamena = ZamenaFull.fromMap(element);
      zamenaBuffer.add(zamena);
    }
    return zamenaBuffer;
  }

  static Future<List<Zamena>> getZamenasByDate({required final DateTime date}) async {
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client
        .from('Zamenas')
        .select()
        .eq('date', date.toIso8601String())
        .order('id',ascending: true);
    final List<Zamena> zamenaBuffer = [];
    for (final element in data) {
      final Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
    }
    return zamenaBuffer;
  }

  static Future<List<Zamena>> loadZamenas(
      {required final List<int> groupsID,
      required final DateTime start,
      required final DateTime end,}) async {
    if (groupsID.isEmpty == true) {
      return [];
    }
    final client = GetIt.I.get<SupabaseClient>();
    GetIt.I.get<Data>();
    final List<dynamic> data = await client
        .from('Zamenas')
        .select()
        .inFilter('group', groupsID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    final List<Zamena> zamenaBuffer = [];
    for (final element in data) {
      final Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
    }
    return zamenaBuffer;
  }

  static Future<List<Zamena>> loadTeacherZamenas(
      {required final int teacherID,
      required final DateTime start,
      required final DateTime end,}) async {
    final client = GetIt.I.get<SupabaseClient>();
    GetIt.I.get<Data>();
    final List<dynamic> data = await client
        .from('Zamenas')
        .select()
        .eq('teacher', teacherID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    final List<Zamena> zamenaBuffer = [];
    for (final element in data) {
      final Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
      // if (!dat.zamenas.any((element) => element.id == zamena.id)) {
      //   dat.zamenas.add(zamena);
      // }
    }
    return zamenaBuffer;
  }

  static Future<List<Zamena>> loadCabinetZamenas(
      {required final int cabinetID,
      required final DateTime start,
      required final DateTime end,}) async {
    final client = GetIt.I.get<SupabaseClient>();
    GetIt.I.get<Data>();
    final List<dynamic> data = await client
        .from('Zamenas')
        .select()
        .eq('cabinet', cabinetID)
        .lte('date', end.toIso8601String())
        .gte('date', start.toIso8601String())
        .order('date');

    final List<Zamena> zamenaBuffer = [];
    for (final element in data) {
      final Zamena zamena = Zamena.fromMap(element);
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

  static Future<void> loadCourses() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    final List<dynamic> data = await client.from('Courses').select();

    dat.courses = [];
    for (final element in data) {
      final Course course = Course.fromMap(element);
      dat.courses.add(course);
    }
  }

  static Future<void> loadDepartments() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    final List<dynamic> data = await client.from('Departments').select();

    dat.departments = [];
    for (final element in data) {
      final Department department = Department.fromMap(element);
      dat.departments.add(department);
    }
  }
}
