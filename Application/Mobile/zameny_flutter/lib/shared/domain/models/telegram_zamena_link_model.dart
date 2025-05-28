// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TelegramZamenaLinks {
  final DateTime date;
  final DateTime created;

  TelegramZamenaLinks({
    required this.created,
    required this.date
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory TelegramZamenaLinks.fromMap(final Map<String, dynamic> map) {
    return TelegramZamenaLinks(
      date: DateTime.parse(map['date'] as String),
      created: DateTime.parse(map['created_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TelegramZamenaLinks.fromJson(final String source) => TelegramZamenaLinks.fromMap(json.decode(source) as Map<String, dynamic>);
}
