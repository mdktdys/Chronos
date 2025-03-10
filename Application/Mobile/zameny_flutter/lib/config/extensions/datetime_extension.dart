import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatyyyymmdd() {
    return DateFormat('yyyy.MM.dd').format(this);
  }

  String hhmm() {
    return DateFormat('HH:mm').format(this);
  }
}
