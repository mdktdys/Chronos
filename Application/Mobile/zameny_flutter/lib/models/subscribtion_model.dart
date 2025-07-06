import 'dart:convert';

import 'package:zameny_flutter/models/model.dart';

class MessagingClient extends Model {
  final int targetId;
  final int targetTypeId;

  MessagingClient({
    required this.targetId,
    required this.targetTypeId
  });

  MessagingClient copyWith({
    final int? targetId,
    final int? targetTypeId,
  }) {
    return MessagingClient(
      targetId: targetId ?? this.targetId,
      targetTypeId: targetTypeId ?? this.targetTypeId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subID': targetId,
      'subType': targetTypeId,
    };
  }

  factory MessagingClient.fromMap(final Map<String, dynamic> map) {
    return MessagingClient(
      targetId: map['subID'] as int,
      targetTypeId: map['subType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessagingClient.fromJson(final String source) => MessagingClient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant final MessagingClient other) {
    if (identical(this, other)) {
      return true;
    }

    return
      other.targetId == targetId &&
      other.targetTypeId == targetTypeId;
  }

  @override
  int get hashCode => targetId.hashCode ^ targetTypeId.hashCode;
}
