import 'dart:math' as math;

import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';
class DaySchedule {
  final List<ZamenaFileLink>? zamenaLinks;
  final ZamenaFull? zamenaFull;
  final List<Paras> paras;
  final DateTime date;

  DaySchedule({
    required this.zamenaLinks,
    required this.zamenaFull,
    required this.paras,
    required this.date,
  });
  
  factory DaySchedule.fake(final DateTime date) {
    final math.Random random = math.Random();

    return DaySchedule(
      zamenaFull: null,
      zamenaLinks: [],
      date: date,
      paras: List.generate(random.nextInt(8), (final int index) {
        return Paras.fake(number: index);
      }).toList()
    );
  }
}
