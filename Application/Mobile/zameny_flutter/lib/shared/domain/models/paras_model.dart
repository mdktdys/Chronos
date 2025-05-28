import 'package:zameny_flutter/shared/domain/models/lesson_model.dart';
import 'package:zameny_flutter/shared/domain/models/zamena_full_model.dart';
import 'package:zameny_flutter/shared/domain/models/zamena_model.dart';

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

  factory Paras.fake({
    required final int number,
  }) {
    return Paras(
      number: number,
      lesson: [
        Lesson.fake(number: 1),
        Lesson.fake(number: 2),
        Lesson.fake(number: 3)
      ]
    );
  }
}
