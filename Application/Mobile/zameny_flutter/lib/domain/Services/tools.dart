import 'dart:math';
import 'dart:ui';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/domain/Services/Data.dart';
import 'package:zameny_flutter/models/models.dart';


DateTime formatTimeToDateTime(String time) {
  //sample 11:05:20
  final String hours = time.split(':')[0];
  final String minuts = time.split(':')[1];
  final DateTime current = DateTime.now()  ;
  return DateTime(current.year, current.month, current.day, int.parse(hours),
      int.parse(minuts),);
}

String getTimeFromDateTime(DateTime date) {
  final String hours = date.hour < 9 ? '0${date.hour}' : '${date.hour}';
  final String minutes = date.minute < 9 ? '0${date.minute}' : '${date.minute}';
  return '$hours:$minutes';
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
  final DateTime januaryFirst = DateTime(year);
  final int firstMondayOffset = (DateTime.monday - januaryFirst.weekday + 7) % 7;
  final DateTime firstMonday = januaryFirst.add(Duration(days: firstMondayOffset));
  final int daysToAdd = (week - 1) * 7;
  return firstMonday.add(Duration(days: daysToAdd));
}

String getMonthName(int monthNumber) {
  final List<String> months = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];

  if (monthNumber >= 1 && monthNumber <= 12) {
    return months[monthNumber - 1];
  } else {
    return 'err';
  }
}

String getDayName(int day) {
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

Color getCourseColor(String color) {
  return Color.fromARGB(
      int.parse(color.split(',')[0]),
      int.parse(color.split(',')[1]),
      int.parse(color.split(',')[2]),
      int.parse(color.split(',')[3]),);
}

 Color getColorForText(String text) {
    final hash = text.hashCode;
    final random = Random(hash);

    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    final int maxValue = max(red, max(green, blue));
    if (maxValue == red) {
      red = 230;
    } else if (maxValue == green) {
      green = 230;
    } else {
      blue = 230;
    }

    return Color.fromARGB(255, red, green, blue);
  }

  