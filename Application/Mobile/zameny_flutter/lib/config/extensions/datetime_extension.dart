import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatyyyymmdd() {
    return DateFormat('yyyy.MM.dd').format(this);
  }

  String hhmm() {
    return DateFormat('HH:mm').format(this);
  }

  bool betweenIgnoreYear(final DateTime start, final DateTime end) {
    // Convert to a uniform year (0) for comparison
    final DateTime thisDate = DateTime(0, month, day);
    final DateTime startDate = DateTime(0, start.month, start.day);
    final DateTime endDate = DateTime(0, end.month, end.day);

    // Check if date range crosses year boundary (e.g., November to February)
    if (startDate.isAfter(endDate)) {
      // When the range wraps around the year boundary
      return thisDate.isAfter(startDate) || thisDate.isBefore(endDate) || thisDate == startDate || thisDate == endDate;
    } else {
      // Standard range within the same year
      return (thisDate.isAfter(startDate) && thisDate.isBefore(endDate)) || thisDate == startDate || thisDate == endDate;
    }
  }

  bool sameDate(final DateTime other) {
    return year == other.year && month == other.month && other.day == day;
  }

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

  DateTime toStartOfDay() {
    return DateTime(year, month, day);
  }

  DateTime toEndOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  String toddmmyyhhmmss() {
    return DateFormat('dd.MM.y HH.mm.ss').format(this);
  }

  String toddmmyyhhmm() {
    return DateFormat('dd.MM.y HH:mm').format(this);
  }

  String toyyyymmdd() {
    return DateFormat('y-MM-dd').format(this);
  }

  String toddMM() {
    return "${DateFormat('dd.MM').format(this)} (${weekdayName()})";
  }

  String toMonth() {
    const Map<int, String> months = {
      1: 'Январь',
      2: 'Февраль',
      3: 'Март',
      4: 'Апрель',
      5: 'Май',
      6: 'Июнь',
      7: 'Июль',
      8: 'Август',
      9: 'Сентябрь',
      10: 'Октябрь',
      11: 'Ноябрь',
      12: 'Декабрь',
    };
    return months[month] ?? '';
  }
}
