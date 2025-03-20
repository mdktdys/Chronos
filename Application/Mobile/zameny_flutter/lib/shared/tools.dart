import 'dart:math';
import 'dart:ui';

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

  
