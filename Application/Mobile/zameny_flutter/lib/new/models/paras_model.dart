import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/models/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';

class Paras {
  int? number;
  List<Lesson>? lesson;
  List<Zamena>? zamena;
  ZamenaFull? zamenaFull;

  Paras({
    this.lesson,
    this.zamena,
    this.zamenaFull,
    this.number,
  });
}
