import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zameny_flutter/features/schedule/presentation/widgets/course_tile.dart';
import 'package:zameny_flutter/models/models.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Data {
  List<Teacher> teachers = [];
  List<Group> groups = [];
  List<Course> courses = [];
  List<Cabinet> cabinets = [];
  List<LessonTimings> timings = [];
  List<Department> departments = [];
  Set<ZamenaFileLink> zamenaFileLinks = {};
  Set<Holiday> holidays = {};
  int? seekGroup = -1;
  int? teacherGroup = -1;
  int? seekCabinet = -1;
  SearchType latestSearch = SearchType.group;

  Data() {
    seekGroup = GetIt.I.get<SharedPreferences>().getInt('SelectedGroup') ?? -1;
    teacherGroup = GetIt.I.get<SharedPreferences>().getInt('SelectedTeacher') ?? -1;
    seekCabinet = GetIt.I.get<SharedPreferences>().getInt('SelectedCabinet') ?? -1;
  }

  Data.fromShared() {
    seekGroup = GetIt.I.get<SharedPreferences>().getInt('SelectedGroup') ?? -1;
    teacherGroup = GetIt.I.get<SharedPreferences>().getInt('SelectedTeacher') ?? -1;
    seekCabinet = GetIt.I.get<SharedPreferences>().getInt('SelectedCabinet') ?? -1;

    switch (
        GetIt.I.get<SharedPreferences>().getString('SearchType') ?? 'Group') {
      case 'Group':
        {
          latestSearch = SearchType.group;
        }
      case 'Teacher':
        {
          latestSearch = SearchType.teacher;
        }
      case 'Cabinet':
        {
          latestSearch = SearchType.cabinet;
        }
    }
  }
}
