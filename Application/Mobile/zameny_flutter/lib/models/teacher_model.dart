
import 'dart:convert';

import 'package:zameny_flutter/models/lesson_model.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/schedule_turbo_search.dart';

class Teacher extends SearchItem {
  int id;
  String name;
  List<Lesson> lessons = [];
  Teacher({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);
}
