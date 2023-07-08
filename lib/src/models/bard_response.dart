import 'dart:convert';

import 'package:collection/collection.dart';

import 'choice.dart';

class BardResponse {
  String? content;
  String? conversationId;
  String? responseId;
  List<dynamic>? factualityQueries;
  List<dynamic>? textQuery;
  List<Choice>? choices;

  BardResponse({
    this.content,
    this.conversationId,
    this.responseId,
    this.factualityQueries,
    this.textQuery,
    this.choices,
  });

  factory BardResponse.fromMap(Map<String, dynamic> data) => BardResponse(
        content: data['content']?.toString(),
        conversationId: data['conversation_id']?.toString(),
        responseId: data['response_id']?.toString(),
        factualityQueries: List<dynamic>.from(data['factualityQueries'] ?? []),
        textQuery: List<dynamic>.from(data['textQuery'] ?? []),
        choices: (data['choices'] as List<dynamic>?)
            ?.map((e) => Choice.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        if (content != null) 'content': content,
        if (conversationId != null) 'conversation_id': conversationId,
        if (responseId != null) 'response_id': responseId,
        if (factualityQueries != null) 'factualityQueries': factualityQueries,
        if (textQuery != null) 'textQuery': textQuery,
        if (choices != null) 'choices': choices?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BardResponse].
  factory BardResponse.fromJson(String data) {
    return BardResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BardResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! BardResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      content.hashCode ^
      conversationId.hashCode ^
      responseId.hashCode ^
      factualityQueries.hashCode ^
      textQuery.hashCode ^
      choices.hashCode;
}
