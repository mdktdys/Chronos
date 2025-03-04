import 'dart:math';
import 'dart:ui';

import 'package:get_it/get_it.dart';

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/services/Data.dart';

DateTime formatTimeToDateTime(final String time) {
  //sample 11:05:20
  final String hours = time.split(':')[0];
  final String minuts = time.split(':')[1];
  final DateTime current = DateTime.now()  ;
  return DateTime(current.year, current.month, current.day, int.parse(hours),
      int.parse(minuts),);
}

String getTimeFromDateTime(final DateTime date) {
  final String hours = date.hour < 9 ? '0${date.hour}' : '${date.hour}';
  final String minutes = date.minute < 9 ? '0${date.minute}' : '${date.minute}';
  return '$hours:$minutes';
}

Department getDepartmentById(final int departmentID) {
  final dat = GetIt.I.get<Data>();
  return dat.departments.where((final element) => element.id == departmentID).first;
}

LessonTimings getLessonTimings(final int lesson) {
  final dat = GetIt.I.get<Data>();
  return dat.timings.where((final timimng) => timimng.number == lesson).first;
}

// Cabinet getCabinetById(final int cabinetID) {
//   final dat = GetIt.I.get<Data>();
//   return dat.cabinets.where((final cabinet) => cabinet.id == cabinetID).first;
// }

// Teacher getTeacherById(final int teacherID) {
//   final dat = GetIt.I.get<Data>();
//   return dat.teachers.where((final teacher) => teacher.id == teacherID).first;
// }

// Group? getGroupById(final int groupID) {
//   final dat = GetIt.I.get<Data>();
//   return dat.groups.where((final group) => group.id == groupID).firstOrNull;
// }

// Course? getCourseById(final int courseID) {
//   final dat = GetIt.I.get<Data>();
//   return dat.courses
//       .where((final course) => course.id == courseID)
//       .toList()
//       .firstOrNull;
// }

DateTime getFirstDayOfWeek(final int year, final int week) {
  final DateTime januaryFirst = DateTime(year);
  final int firstMondayOffset = (DateTime.monday - januaryFirst.weekday + 7) % 7;
  final DateTime firstMonday = januaryFirst.add(Duration(days: firstMondayOffset));
  final int daysToAdd = (week - 1) * 7;
  return firstMonday.add(Duration(days: daysToAdd));
}

String getMonthName(final int monthNumber) {
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

Color getCourseColor(final String color) {
  return Color.fromARGB(
      int.parse(color.split(',')[0]),
      int.parse(color.split(',')[1]),
      int.parse(color.split(',')[2]),
      int.parse(color.split(',')[3]),);
}

 Color getColorForText(final String text) {
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

  
