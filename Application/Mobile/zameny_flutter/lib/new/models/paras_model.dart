import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/models/zamena_full_model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';

class Paras {
  int? number;
  List<Lesson>? lesson;
  List<Zamena>? zamena;
  List<ZamenaFull>? zamenaFull;

  Paras({
    this.lesson,
    this.zamena,
    this.zamenaFull,
    this.number,
  });

  factory Paras.fake() {
    return Paras(
      number: 1,
      lesson: [
        Lesson.fake(number: 1),
        Lesson.fake(number: 2),
        Lesson.fake(number: 3)
      ]
    );
  }
}
