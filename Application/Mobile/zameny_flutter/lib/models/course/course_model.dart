import 'dart:convert';

import 'package:skeletonizer/skeletonizer.dart';

class Course {
  int id;
  String name;
  String color;
  String? fullname;

  Course({
    required this.id,
    required this.name,
    required this.color,
    this.fullname,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory Course.fromMap(final Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int,
      name: (map['fullname'] ?? map['name']) as String,
      color: map['color'] as String,
      fullname: map['fullname'] as String?,
    );
  }

  factory Course.mock() {
    return Course(
      id: 1,
      name: BoneMock.name,
      color: '255,255,255,255'
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(final String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);

  Course copyWith({
    final int? id,
    final String? name,
    final String? color,
    final String? fullname,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      fullname: fullname ?? this.fullname,
    );
  }
}
