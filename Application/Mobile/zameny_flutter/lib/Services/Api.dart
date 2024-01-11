import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';

class Api {
  Future<void> loadTeachers() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Teachers').select('*');

    dat.teachers = [];
    data.forEach((element) {
      Teacher teacher = Teacher.fromMap(element);
      dat.teachers.add(teacher);
    });
  }

  Future<void> loadCabinets() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Cabinets').select('*');

    dat.cabinets = [];
    data.forEach((element) {
      Cabinet cab = Cabinet.fromMap(element);
      dat.cabinets.add(cab);
    });
  }

  Future<void> loadTimings() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('scheduleTimetable').select('*');

    data.forEach((element) {
      LessonTimings timing = LessonTimings.fromMap(element);
      dat.timings.add(timing);
    });
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

    data.forEach((element) {
      ZamenasType zamenaType = ZamenasType.fromMap(element);
      dat.zamenaTypes.add(zamenaType);
    });
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
    data.forEach((element) {
      Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
      if (!dat.zamenas.any((element) => element.id == zamena.id)) {
        dat.zamenas.add(zamena);
      }
    });
    return zamenaBuffer;
  }

  Future<void> loadDefaultSchedule({required int groupID}) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data =
        await client.from('defaultLessons').select('*').eq('group', groupID);

    Group group = dat.groups.where((element) => element.id == groupID).first;
    group.lessons = [];
    data.forEach((element) {
      Lesson lesson = Lesson.fromMap(element);
      group.lessons.add(lesson);
    });
  }

  Future<void> loadCourses(List<int> coursesID) async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data =
        await client.from('Courses').select('*').in_('id', coursesID);

    dat.courses = [];
    data.forEach((element) {
      Course course = Course.fromMap(element);
      dat.courses.add(course);
    });
  }

  Future<void> loadGroups() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Groups').select('*');

    dat.groups = [];
    data.forEach((element) {
      Group groupName = Group.fromMap(element);
      dat.groups.add(groupName);
    });
  }

  Future<void> loadDepartments() async {
    final client = GetIt.I.get<SupabaseClient>();
    final dat = GetIt.I.get<Data>();

    List<dynamic> data = await client.from('Departments').select('*');

    dat.departments = [];
    data.forEach((element) {
      Department department = Department.fromMap(element);
      dat.departments.add(department);
    });
  }
}
