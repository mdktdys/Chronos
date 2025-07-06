import 'dart:convert';

class ParasFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? teacher;
  final int? group;
  final int? cabinet;

  ParasFilter(
    this.startDate,
    this.endDate,
    this.teacher,
    this.group,
    this.cabinet
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'teacher': teacher,
      'group': group,
      'cabinet': cabinet,
    };
  }

  factory ParasFilter.fromMap(final Map<String, dynamic> map) {
    return ParasFilter(
      map['startDate'] != null ? DateTime.parse(map['startDate'] as String) : null,
      map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      map['teacher'] != null ? map['teacher'] as int : null,
      map['group'] != null ? map['group'] as int : null,
      map['cabinet'] != null ? map['cabinet'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParasFilter.fromJson(final String source) => ParasFilter.fromMap(json.decode(source) as Map<String, dynamic>);
}
