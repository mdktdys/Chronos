import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Data.dart';

Department getDepartmentById(int departmentID) {
  final dat = GetIt.I.get<Data>();
  return dat.departments.where((element) => element.id == departmentID).first;
}

LessonTimings getLessonTimings(int lesson) {
  final dat = GetIt.I.get<Data>();
  return dat.timings.where((timimng) => timimng.number == lesson).first;
}

Cabinet getCabinetById(int cabinetID) {
  final dat = GetIt.I.get<Data>();
  return dat.cabinets.where((cabinet) => cabinet.id == cabinetID).first;
}

Teacher getTeacherById(int teacherID) {
  final dat = GetIt.I.get<Data>();
  return dat.teachers.where((teacher) => teacher.id == teacherID).first;
}

Course? getCourseById(int CourseID) {
  final dat = GetIt.I.get<Data>();
  return dat.courses.where((course) => course.id == CourseID).toList().firstOrNull;
}

String getMonthName(int monthNumber) {
  List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

  
  if (monthNumber >= 1 && monthNumber <= 12) {
    return months[monthNumber - 1];
  } else {
    return "err";
  }
}

String getDayName(int day) {
  switch (day) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Invalid";
  }
}

Color getCourseColor(String color) {
  return Color.fromARGB(
      int.parse(color.split(',')[0]),
      int.parse(color.split(',')[1]),
      int.parse(color.split(',')[2]),
      int.parse(color.split(',')[3]));
}
