import 'dart:convert';

import 'package:collection/collection.dart';

class Choice {
  String? id;
  List<String>? content;

  Choice({this.id, this.content});

  factory Choice.fromMap(Map<String, dynamic> data) => Choice(
        id: data['id']?.toString(),
        content: List<String>.from(data['content'] ?? []),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        if (content != null) 'content': content,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Choice].
  factory Choice.fromJson(String data) {
    return Choice.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Choice] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Choice) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode;
}
