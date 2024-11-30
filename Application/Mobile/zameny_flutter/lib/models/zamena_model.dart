import 'dart:convert';

class Zamena {
  int id;
  int groupID;
  int teacherID;
  int courseID;
  int lessonTimingsID;
  int cabinetID;
  DateTime date;

  Zamena({
    required this.id,
    required this.groupID,
    required this.teacherID,
    required this.courseID,
    required this.lessonTimingsID,
    required this.date,
    required this.cabinetID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'groupID': groupID,
      'teacherID': teacherID,
      'courseID': courseID,
      'LessonTimingsID': lessonTimingsID,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Zamena.fromMap(final Map<String, dynamic> map) {
    return Zamena(
      id: map['id'] as int,
      groupID: map['group'] as int,
      teacherID: map['teacher'] as int,
      courseID: map['course'] as int,
      cabinetID: map['cabinet'] as int,
      lessonTimingsID: map['number'] as int,
      date: DateTime.parse((map['date'] as String)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Zamena.fromJson(final String source) => Zamena.fromMap(json.decode(source) as Map<String, dynamic>);
}
