import 'dart:convert';


class ZamenaFileLink {
  int id;
  String link;
  DateTime date;
  ZamenaFileLink({
    required this.id,
    required this.link,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'link': link,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ZamenaFileLink.fromMap(Map<String, dynamic> map) {
    return ZamenaFileLink(
      id: map['id'] as int,
      link: map['link'] as String,
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZamenaFileLink.fromJson(String source) => ZamenaFileLink.fromMap(json.decode(source) as Map<String, dynamic>);
}
