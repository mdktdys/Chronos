import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/domain/Models/models.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Data {
  List<Teacher> teachers = [];
  List<Group> groups = [];
  List<Course> courses = [];
  List<Cabinet> cabinets = [];
  List<LessonTimings> timings = [];
  List<Department> departments = [];
  List<Zamena> zamenas = [];
  List<ZamenasType> zamenaTypes = [];
  Set<ZamenaFileLink> zamenaFileLinks = {};
  Set<ZamenaFull> zamenasFull = {};
  Set<Holiday> holidays = {};
  Set<Liquidation> liquidations = {};
  int? seekGroup = -1;
  int? teacherGroup = -1;
  int? seekCabinet = -1;
  SearchType latestSearch = SearchType.group;
  Duration networkOffset = const Duration(milliseconds: 1); 

  Data.fromShared() {
    seekGroup = GetIt.I.get<SharedPreferences>().getInt('SelectedGroup') ?? -1;
    teacherGroup =
        GetIt.I.get<SharedPreferences>().getInt('SelectedTeacher') ?? -1;
    seekCabinet =
        GetIt.I.get<SharedPreferences>().getInt('SelectedCabinet') ?? -1;

    switch (
        GetIt.I.get<SharedPreferences>().getString('SearchType') ?? "Group") {
      case "Group":
        {
          latestSearch = SearchType.group;
        }
      case "Teacher":
        {
          latestSearch = SearchType.teacher;
        }
      case "Cabinet":
        {
          latestSearch = SearchType.cabinet;
        }
    }
  }
}

void setChoosedTheme(int index) {
  GetIt.I.get<SharedPreferences>().setInt("Theme", index);
}
