import 'dart:convert';

class Subscription {
  final int targetId;
  final int targetTypeId;

  Subscription({
    required this.targetId,
    required this.targetTypeId
  });

  Subscription copyWith({
    final int? targetId,
    final int? targetTypeId,
  }) {
    return Subscription(
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

  factory Subscription.fromMap(final Map<String, dynamic> map) {
    return Subscription(
      targetId: map['subID'] as int,
      targetTypeId: map['subType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subscription.fromJson(final String source) => Subscription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Subscription(targetId: $targetId, targetTypeId: $targetTypeId)';

  @override
  bool operator ==(covariant final Subscription other) {
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
