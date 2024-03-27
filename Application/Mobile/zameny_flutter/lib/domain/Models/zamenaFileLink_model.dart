// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
import 'dart:convert';

class ZamenaFileLink {
  int id;
  String link;
  DateTime date;
  DateTime created;
  ZamenaFileLink({
    required this.id,
    required this.link,
    required this.date,
    required this.created,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'link': link,
      'date': date.millisecondsSinceEpoch,
      'created_at' : created.millisecondsSinceEpoch
    };
  }

  factory ZamenaFileLink.fromMap(Map<String, dynamic> map) {
    return ZamenaFileLink(
      id: map['id'] as int,
      link: map['link'] as String,
      date: DateTime.parse(map['date']),
      created: DateTime.parse(map['created_at'] as String).toUtc()
    );
  }

  String toJson() => json.encode(toMap());

  factory ZamenaFileLink.fromJson(String source) => ZamenaFileLink.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ZamenaFileLink other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.link == link &&
      other.date == date &&
      other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      link.hashCode ^
      date.hashCode ^
      created.hashCode;
  }
}
