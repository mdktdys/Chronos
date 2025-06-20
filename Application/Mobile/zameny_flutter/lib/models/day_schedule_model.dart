import 'dart:math' as math;

import 'package:zameny_flutter/models/models.dart';

class DaySchedule {
  final List<ZamenaFileLink>? zamenaLinks;
  final ZamenaFull? zamenaFull;
  final TelegramZamenaLinks? telegramLink;
  final List<Paras> paras;
  final DateTime date;
  final List<Holiday> holidays;

  DaySchedule({
    required this.zamenaLinks,
    required this.zamenaFull,
    required this.paras,
    required this.date,
    required this.holidays,
    this.telegramLink,
  });
  
  factory DaySchedule.fake(final DateTime date) {
    final math.Random random = math.Random();

    return DaySchedule(
      holidays: [],
      zamenaFull: null,
      zamenaLinks: [],
      date: date,
      paras: List.generate(random.nextInt(8), (final int index) {
        return Paras.fake(number: index);
      }).toList()
    );
  }
}
