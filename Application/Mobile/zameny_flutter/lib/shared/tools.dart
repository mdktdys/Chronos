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

  
