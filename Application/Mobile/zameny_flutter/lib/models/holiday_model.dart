import 'dart:convert';

class Holiday {
  int id;
  String name;
  DateTime date;
  Holiday({
    required this.id,
    required this.name,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Holiday.fromMap(final Map<String, dynamic> map) {
    return Holiday(
      id: map['id'] as int,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Holiday.fromJson(final String source) =>
      Holiday.fromMap(json.decode(source) as Map<String, dynamic>);
}
