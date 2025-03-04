extension DatetimeExtension on DateTime {
  String weekdayName() {
    const Map<int, String> weekdayName = {
      1: 'Понедельник',
      2: 'Вторник',
      3: 'Среда',
      4: 'Четверг',
      5: 'Пятница',
      6: 'Суббота',
      7: 'Воскресенье'
    };
    return weekdayName[weekday] ?? '';
  }
}
