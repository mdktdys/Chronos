
import 'dart:convert';

import 'package:flutter/material.dart';

class Department {
  int id;
  String name;
  Department({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) =>
      Department.fromMap(json.decode(source) as Map<String, dynamic>);

  IconData getIcon() {
    if (id == 1) {
      return Icons.code;
    }
    if (id == 2) {
      return Icons.architecture;
    }
    if (id == 5) {
      return Icons.bar_chart;
    }
    if (id == 4) {
      return Icons.balance_outlined;
    }
    if (id == 3) {
      return Icons.child_friendly;
    }
    return Icons.question_mark;
  }
}
