import 'dart:convert';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';

class Teacher extends SearchItem {
  String name;
  // List<Lesson> lessons = [];

  Teacher({
    required super.id,
    required this.name,
    super.typeId = 1
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Teacher.fromMap(final Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(final String source) => Teacher.fromMap(json.decode(source) as Map<String, dynamic>);
}
