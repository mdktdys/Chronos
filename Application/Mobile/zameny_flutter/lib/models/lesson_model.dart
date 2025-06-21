// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:zameny_flutter/core/model.dart';
import 'package:zameny_flutter/models/zamena_model.dart';

class LessonFilter extends Filter {
  int? id;
  int? number;
  int? group;
  DateTime? startDate;
  DateTime? endDate;
  int? course;
  int? teacher;
  int? cabinet;

  LessonFilter({
    this.id,
    this.number,
    this.group,
    this.startDate,
    this.endDate,
    this.course,
    this.teacher,
    this.cabinet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'group': group,
      'start_date': startDate?.millisecondsSinceEpoch,
      'end_date': endDate?.millisecondsSinceEpoch,
      'course': course,
      'teacher': teacher,
      'cabinet': cabinet,
    };
  }
}

class Lesson extends Model {
  int id;
  int number;
  int group;
  DateTime date;
  int course;
  int teacher;
  int cabinet;

  Lesson({
    required this.id,
    required this.number,
    required this.group,
    required this.date,
    required this.course,
    required this.teacher,
    required this.cabinet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'group': group,
      'date': date,
      'course': course,
      'teacher': teacher,
      'cabinet': cabinet,
    };
  }

  factory Lesson.fake({
    required final int number
  }) {
    return Lesson(
      id: 1,
      number: number,
      group: 1,
      course: 1,
      teacher: 1,
      cabinet: 1,
      date: DateTime.now()
    );
  }

  factory Lesson.fromMap(final Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as int,
      number: map['number'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date']),
      course: map['course'] as int,
      teacher: map['teacher'] as int,
      cabinet: map['cabinet'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lesson.fromJson(final String source) => Lesson.fromMap(json.decode(source) as Map<String, dynamic>);

  Lesson copyWith({
    final int? id,
    final int? number,
    final int? group,
    final DateTime? date,
    final int? course,
    final int? teacher,
    final int? cabinet,
  }) {
    return Lesson(
      id: id ?? this.id,
      number: number ?? this.number,
      group: group ?? this.group,
      date: date ?? this.date,
      course: course ?? this.course,
      teacher: teacher ?? this.teacher,
      cabinet: cabinet ?? this.cabinet,
    );
  }

  factory Lesson.fromZamena(final Zamena zamena) {
    return Lesson(
      id: zamena.id,
      number: zamena.lessonTimingsID,
      group: zamena.groupID,
      date: zamena.date,
      course: zamena.courseID,
      teacher: zamena.teacherID,
      cabinet: zamena.cabinetID
    );
  }
}
