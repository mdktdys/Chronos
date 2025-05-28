import 'dart:convert';

import 'package:zameny_flutter/shared/domain/models/search_item_model.dart';
import 'package:zameny_flutter/modules/schedule/presentation/widgets/course_tile.dart';

class Group extends SearchItem {
  int department;
  
  Group({
    required super.id,
    required super.name,
    required this.department,
    super.type = SearchType.group,
    super.typeId = 1
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Group.fromMap(final Map<String, dynamic> map) {
    return Group(
      id: map['id'] as int,
      name: map['name'] as String,
      department: map['department'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(final String source) => Group.fromMap(json.decode(source) as Map<String, dynamic>);
}
