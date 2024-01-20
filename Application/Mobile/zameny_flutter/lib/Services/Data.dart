import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/Services/Models/zamenaFileLink.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Data {
  final VERSION = 2;

  List<Teacher> teachers = [];
  List<Group> groups = [];
  List<Course> courses = [];
  List<Cabinet> cabinets = [];
  List<LessonTimings> timings = [];
  List<Department> departments = [];
  List<Zamena> zamenas = [];
  List<ZamenasType> zamenaTypes = [];
  List<ZamenaFileLink> zamenaFileLinks = [];

  int? seekGroup = -1;

  Data.fromShared(context) {
    seekGroup = GetIt.I.get<SharedPreferences>().getInt('SelectedGroup') ?? -1;
  }
}



class Department {
  int id;
  String name;
  Department({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) =>
      Department.fromMap(json.decode(source) as Map<String, dynamic>);

  IconData getIcon() {
    if (id == 1) {
      return Icons.code;
    }
    if (id == 2) {
      return Icons.architecture;
    }
    if (id == 5) {
      return Icons.bar_chart;
    }
    if (id == 4) {
      return Icons.balance_outlined;
    }
     if (id == 3) {
      return Icons.child_friendly;
    }
    return Icons.question_mark;
  }
}



class LessonTimings {
  int number;
  DateTime? start;
  DateTime? end;
  LessonTimings({
    required this.number,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'start': start,
      'end': end,
    };
  }

  factory LessonTimings.fromMap(Map<String, dynamic> map) {
    return LessonTimings(
      number: map['number'] as int,
      start: DateFormat.Hms().parse(map['start']),
      end: DateFormat('HH:mm:ss').parse(map['end']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonTimings.fromJson(String source) =>
      LessonTimings.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Course {
  int id;
  String name;
  String color;

  Course({required this.id, required this.name, required this.color});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int,
      name: map['name'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Teacher {
  int id;
  String name;
  Teacher({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ZamenasType {
  int id;
  int group;
  DateTime date;
  bool full;
  ZamenasType({
    required this.id,
    required this.group,
    required this.date,
    required this.full,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'group': group,
      'date': date.millisecondsSinceEpoch,
      'full': full,
    };
  }

  factory ZamenasType.fromMap(Map<String, dynamic> map) {
    return ZamenasType(
      id: map['id'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date'] as String),
      full: map['full'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZamenasType.fromJson(String source) =>
      ZamenasType.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Zamena {
  int id;
  int groupID;
  int teacherID;
  int courseID;
  int LessonTimingsID;
  int cabinetID;

  DateTime date;
  Zamena({
    required this.id,
    required this.groupID,
    required this.teacherID,
    required this.courseID,
    required this.LessonTimingsID,
    required this.date,
    required this.cabinetID
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'groupID': groupID,
      'teacherID': teacherID,
      'courseID': courseID,
      'LessonTimingsID': LessonTimingsID,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Zamena.fromMap(Map<String, dynamic> map) {
    return Zamena(
      id: map['id'] as int,
      groupID: map['group'] as int,
      teacherID: map['teacher'] as int,
      courseID: map['course'] as int,
      cabinetID: map['cabinet'] as int,
      LessonTimingsID: map['number'] as int,
      date: DateTime.parse((map['date'] as String)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Zamena.fromJson(String source) =>
      Zamena.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Cabinet {
  int id;
  String name;
  Cabinet({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Cabinet.fromMap(Map<String, dynamic> map) {
    return Cabinet(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cabinet.fromJson(String source) =>
      Cabinet.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Lesson {
  int id;
  int number;
  int group;
  DateTime date;
  int course;
  int teacher;
  int cabinet;

  Lesson({
    required this.id,
    required this.number,
    required this.group,
    required this.date,
    required this.course,
    required this.teacher,
    required this.cabinet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'group': group,
      'date': date,
      'course': course,
      'teacher': teacher,
      'cabinet': cabinet,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as int,
      number: map['number'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date']),
      course: map['course'] as int,
      teacher: map['teacher'] as int,
      cabinet: map['cabinet'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lesson.fromJson(String source) =>
      Lesson.fromMap(json.decode(source) as Map<String, dynamic>);
}

void setChoosedTheme(int index) {
  GetIt.I.get<SharedPreferences>().setInt("Theme", index);
}
