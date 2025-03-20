import 'dart:convert';

import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';

class Teacher extends SearchItem {
  Teacher({
    required super.id,
    required super.name,
    super.type = SearchType.teacher,
    super.typeId = 2
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
