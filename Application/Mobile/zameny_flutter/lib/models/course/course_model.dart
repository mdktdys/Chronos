import 'dart:convert';

import 'package:skeletonizer/skeletonizer.dart';

class Course {
  int id;
  String name;
  String? fullname;

  Course({
    required this.id,
    required this.name,
    this.fullname,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Course.fromMap(final Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int,
      name: (map['fullname'] ?? map['name']) as String,
      fullname: map['fullname'] as String?,
    );
  }

  factory Course.mock() {
    return Course(
      id: 1,
      name: BoneMock.name,
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
      fullname: fullname ?? this.fullname,
    );
  }
}
