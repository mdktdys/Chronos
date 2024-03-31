import 'dart:ui';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/domain/Models/models.dart';

DateTime formatTimeToDateTime(String time) {
  //sample 11:05:20
  String hours = time.split(':')[0];
  String minuts = time.split(':')[1];
  DateTime current = DateTime.now();
  return DateTime(current.year, current.month, current.day, int.parse(hours),
      int.parse(minuts));
}

String getTimeFromDateTime(DateTime date) {
  String hours = date.hour < 9 ? '0${date.hour}' : '${date.hour}';
  String minutes = date.minute < 9 ? '0${date.minute}' : '${date.minute}';
  return "$hours:$minutes";
}

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

Group? getGroupById(int groupID) {
  final dat = GetIt.I.get<Data>();
  return dat.groups.where((group) => group.id == groupID).firstOrNull;
}

Course? getCourseById(int courseID) {
  final dat = GetIt.I.get<Data>();
  return dat.courses
      .where((course) => course.id == courseID)
      .toList()
      .firstOrNull;
}

DateTime getFirstDayOfWeek(int year, int week) {
  DateTime januaryFirst = DateTime(year, 1, 1);
  int firstMondayOffset = (DateTime.monday - januaryFirst.weekday + 7) % 7;
  DateTime firstMonday = januaryFirst.add(Duration(days: firstMondayOffset));
  int daysToAdd = (week - 1) * 7;
  return firstMonday.add(Duration(days: daysToAdd));
}

String getMonthName(int monthNumber) {
  List<String> months = [
    "Январь",
    "Февраль",
    "Март",
    "Апрель",
    "Май",
    "Июнь",
    "Июль",
    "Август",
    "Сентябрь",
    "Октябрь",
    "Ноябрь",
    "Декабрь"
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
      return "Понедельник";
    case 2:
      return "Вторник";
    case 3:
      return "Среда";
    case 4:
      return "Четверг";
    case 5:
      return "Пятница";
    case 6:
      return "Суббота";
    case 7:
      return "Воскресенье";
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
