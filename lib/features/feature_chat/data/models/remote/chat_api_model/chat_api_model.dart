import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/widgets.dart';

@immutable
class ChatApiModel {
  @override
  final String? id;
  final String? object;

  @override
  final DateTime? created;

  @override
  final String? model;
  final String? systemFingerprint;
  final List<OpenAIStreamChatCompletionChoiceModel>? choices;

  const ChatApiModel({
    this.id,
    this.object,
    this.created,
    this.model,
    this.systemFingerprint,
    this.choices,
  });
  @override
  String toString() {
    return 'ChatApiModel(id: $id, object: $object, created: $created, model: $model, systemFingerprint: $systemFingerprint, choices: $choices)';
  }

  factory ChatApiModel.fromStream(
          OpenAIStreamChatCompletionModel openAIResponse, String modelName) =>
      ChatApiModel(
          id: openAIResponse.id,
          created: openAIResponse.created,
          model: modelName,
          choices: openAIResponse.choices);

  static String _extractContent(List<Choice>? choices) {
    if (choices == null || choices.isEmpty) return "";
    final firstChoice = choices.first;
    if (firstChoice.delta == null) return "";
    return firstChoice.delta?.content ?? "";
  }

  @override
  int get hashCode =>
      id.hashCode ^
      object.hashCode ^
      created.hashCode ^
      model.hashCode ^
      systemFingerprint.hashCode ^
      choices.hashCode;
}

@immutable
class Choice {
  final int? index;
  final Delta? delta;
  final dynamic logprobs;
  final dynamic finishReason;

  const Choice({this.index, this.delta, this.logprobs, this.finishReason});

  @override
  String toString() {
    return 'Choice(index: $index, delta: $delta, logprobs: $logprobs, finishReason: $finishReason)';
  }

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Choice].

  /// `dart:convert`
  ///
  /// Converts [Choice] to a JSON string.

  Choice copyWith({
    int? index,
    Delta? delta,
    dynamic logprobs,
    dynamic finishReason,
  }) {
    return Choice(
      index: index ?? this.index,
      delta: delta ?? this.delta,
      logprobs: logprobs ?? this.logprobs,
      finishReason: finishReason ?? this.finishReason,
    );
  }

  @override
  int get hashCode =>
      index.hashCode ^
      delta.hashCode ^
      logprobs.hashCode ^
      finishReason.hashCode;
}

@immutable
class Delta {
  final String content;
  const Delta({required this.content});

  @override
  String toString() => 'Delta(content: $content)';

  /// `dart:convert`
  ///
  /// Converts [Delta] to a JSON string.

  Delta copyWith({
    required String content,
  }) {
    return Delta(content: content);
  }
}
