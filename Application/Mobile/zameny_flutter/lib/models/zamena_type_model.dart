import 'dart:convert';

import 'package:zameny_flutter/features/schedule/presentation/widgets/schedule_turbo_search.dart';

class ZamenasType {
  int id;
  int group;
  DateTime date;
  bool full;
  ZamenasType({
    required this.id,
    required this.group,
    required this.date,
    
    required this.full,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'group': group,
      'date': date.millisecondsSinceEpoch,
      'full': full,
    };
  }

  factory ZamenasType.fromMap(final Map<String, dynamic> map) {
    return ZamenasType(
      id: map['id'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date'] as String),
      full: map['full'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZamenasType.fromJson(final String source) =>
      ZamenasType.fromMap(json.decode(source) as Map<String, dynamic>);
}


class Cabinet extends SearchItem {
  Cabinet({
    required super.id,
    required super.name,
    super.typeId = 3,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Cabinet.fromMap(final Map<String, dynamic> map) {
    return Cabinet(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cabinet.fromJson(final String source) =>
      Cabinet.fromMap(json.decode(source) as Map<String, dynamic>);
}
