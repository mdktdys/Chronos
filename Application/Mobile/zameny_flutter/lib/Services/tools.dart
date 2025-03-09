import 'package:flutter/material.dart';

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
