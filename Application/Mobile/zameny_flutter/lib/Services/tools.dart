import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/models/course_model.dart';
import 'package:zameny_flutter/models/department_model.dart';
import 'package:zameny_flutter/models/group_model.dart';
import 'package:zameny_flutter/models/lesson_timings_model.dart';
import 'package:zameny_flutter/models/teacher_model.dart';
import 'package:zameny_flutter/models/zamena_type_model.dart';

Department getDepartmentById(final int departmentID) {
  final dat = GetIt.I.get<Data>();
  return dat.departments.where((final element) => element.id == departmentID).first;
}


LessonTimings getLessonTimings(final int lesson) {
  final dat = GetIt.I.get<Data>();
  return dat.timings.where((final timimng) => timimng.number == lesson).first;
}

Cabinet getCabinetById(final int cabinetID) {
  final dat = GetIt.I.get<Data>();
  return dat.cabinets.where((final cabinet) => cabinet.id == cabinetID).first;
}

Teacher getTeacherById(final int teacherID) {
  final dat = GetIt.I.get<Data>();
  return dat.teachers.where((final teacher) => teacher.id == teacherID).first;
}

Group? getGroupById(final int groupID) {
  final dat = GetIt.I.get<Data>();
  return dat.groups.where((final group) => group.id == groupID).firstOrNull;
}

Course? getCourseById(final int courseID) {
  final dat = GetIt.I.get<Data>();
  return dat.courses.where((final course) => course.id == courseID).toList().firstOrNull;
}

DateTime getFirstDayOfWeek(final int year, final int week) {
  final DateTime januaryFirst = DateTime(year);
  final int firstMondayOffset = (DateTime.monday - januaryFirst.weekday + 7) % 7;
  final DateTime firstMonday = januaryFirst.add(Duration(days: firstMondayOffset));
  final int daysToAdd = (week - 1) * 7;
  return firstMonday.add(Duration(days: daysToAdd));
}

String getMonthName(final int monthNumber) {
  final List<String> months = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
];

  
  if (monthNumber >= 1 && monthNumber <= 12) {
    return months[monthNumber - 1];
  } else {
    return 'err';
  }
}

String getDayName(final int day) {
  switch (day) {
    case 1:
      return 'Понедельник';
    case 2:
      return 'Вторник';
    case 3:
      return 'Среда';
    case 4:
      return 'Четверг';
    case 5:
      return 'Пятница';
    case 6:
      return 'Суббота';
    case 7:
      return 'Воскресенье';
    default:
      return 'Invalid';
  }
}

Color getCourseColor(final String color) {
  return Color.fromARGB(
      int.parse(color.split(',')[0]),
      int.parse(color.split(',')[1]),
      int.parse(color.split(',')[2]),
      int.parse(color.split(',')[3]),);
}
