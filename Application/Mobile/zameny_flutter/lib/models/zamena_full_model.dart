import 'dart:convert';

class ZamenaFull {
  final int id;
  final int group;
  final DateTime date;

  ZamenaFull({required this.id, required this.group, required this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'group': group,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ZamenaFull.fromMap(final Map<String, dynamic> map) {
    return ZamenaFull(
      id: map['id'] as int,
      group: map['group'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZamenaFull.fromJson(final String source) =>
      ZamenaFull.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant final ZamenaFull other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id && other.group == group && other.date == date;
  }

  @override
  int get hashCode => id.hashCode ^ group.hashCode ^ date.hashCode;
}
