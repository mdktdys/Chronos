
import 'dart:convert';

class LessonTimings {
  int number;
  String start;
  String end;
  String saturdayStart;
  String saturdayEnd;
  String obedStart;
  String obedEnd;
  LessonTimings({
    required this.number,
    required this.obedStart,
    required this.obedEnd,
    required this.start,
    required this.end,
    required this.saturdayStart,
    required this.saturdayEnd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'start': start,
      'end': end,
      'saturdayStart': saturdayStart,
      'saturdayEnd': saturdayEnd,
      'obedStart': obedStart,
      'obedEnd': obedEnd
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(covariant LessonTimings other) {
    if (identical(this, other)) return true;

    return other.number == number &&
        other.start == start &&
        other.end == end &&
        other.saturdayStart == saturdayStart &&
        other.saturdayEnd == saturdayEnd;
  }

  @override
  int get hashCode {
    return number.hashCode ^
        start.hashCode ^
        end.hashCode ^
        saturdayStart.hashCode ^
        saturdayEnd.hashCode;
  }

  factory LessonTimings.fromMap(Map<String, dynamic> map) {
    return LessonTimings(
      number: map['number'] as int,
      start: map['start'] as String,
      end: map['end'] as String,
      saturdayStart: map['saturdayStart'] as String,
      saturdayEnd: map['saturdayEnd'] as String,
      obedStart: map['obedStart'] as String,
      obedEnd: map['obedEnd'] as String,
    );
  }

  factory LessonTimings.fromJson(String source) =>
      LessonTimings.fromMap(json.decode(source) as Map<String, dynamic>);
}