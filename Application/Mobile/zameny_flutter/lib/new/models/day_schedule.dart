import 'package:zameny_flutter/models/zamenaFileLink_model.dart';
import 'package:zameny_flutter/new/models/paras_model.dart';

class DaySchedule {
  final List<ZamenaFileLink>? zamenaLinks;
  final List<Paras> paras;
  final DateTime date;

  DaySchedule({
    required this.zamenaLinks,
    required this.paras,
    required this.date,
  });
  
  factory DaySchedule.fake(final DateTime date) {
    return DaySchedule(
      zamenaLinks: [],
      paras: [
        Paras.fake(),
        Paras.fake(),
        Paras.fake()
      ],
      date: date
    );
  }
}
