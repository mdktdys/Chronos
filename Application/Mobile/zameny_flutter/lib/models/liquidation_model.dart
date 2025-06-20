import 'dart:convert';

class Liquidation {
  int id;
  int group;
  DateTime date;
  Liquidation({
    required this.id,
    required this.group,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'group': group,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Liquidation.fromMap(final Map<String, dynamic> map) {
    return Liquidation(
      id: map['id'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Liquidation.fromJson(final String source) => Liquidation.fromMap(json.decode(source) as Map<String, dynamic>);
}
