
import 'dart:convert';

import 'package:zameny_flutter/domain/Services/tools.dart';

class LessonTimings {
  int number;
  DateTime start;
  DateTime end;
  DateTime saturdayStart;
  DateTime saturdayEnd;
  DateTime obedStart;
  DateTime obedEnd;
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
      start: formatTimeToDateTime(map['start'] as String),
      end: formatTimeToDateTime(map['end'] as String),
      saturdayStart:formatTimeToDateTime(map['saturdayStart'] as String),
      saturdayEnd: formatTimeToDateTime(map['saturdayEnd'] as String),
      obedStart: formatTimeToDateTime(map['obedStart'] as String),
      obedEnd: formatTimeToDateTime(map['obedEnd'] as String),
    );
  }

  factory LessonTimings.fromJson(String source) =>
      LessonTimings.fromMap(json.decode(source) as Map<String, dynamic>);
}