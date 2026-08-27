import 'dart:convert';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

@immutable
class MaketaskModel extends MaketaskEntity {
  final String? id;
  final String? object;
  final int? created;
  final String? model;
  final List<Choice>? choices;
  final Usage? usage;

  MaketaskModel({
    this.id,
    this.object,
    this.created,
    this.model,
    this.choices,
    this.usage,
  }) : super(
          id: id ?? "",
          model: model ?? "",
          
          messagecontent: _extractContent(choices),
        );

  
  static String _extractContent(List<Choice>? choices) {
    if (choices == null || choices.isEmpty) return "";
    final firstChoice = choices.first;
    if (firstChoice.message == null) return "";

    
    return firstChoice.message?.content ?? firstChoice.message?.reasoning ?? "";
  }

  @override
  String toString() {
    return 'MaketaskModel(id: $id, object: $object, created: $created, model: $model, choices: $choices, usage: $usage)';
  }

  factory MaketaskModel.fromOpenAI(
      OpenAIChatCompletionModel openAIResponse, String modelName) {
    return MaketaskModel(
      id: openAIResponse.id,
      model: modelName,
      created: openAIResponse.created.millisecondsSinceEpoch,
      choices: openAIResponse.choices
          .map((c) => Choice(
                index: c.index,
                message: Message(
                  role: c.message.role.name,
                  content: c.message.content?.first.text ?? "",
                ),
                finishReason: c.finishReason,
              ))
          .toList(),
      usage: Usage(
        promptTokens: openAIResponse.usage.promptTokens,
        completionTokens: openAIResponse.usage.completionTokens,
        totalTokens: openAIResponse.usage.totalTokens,
      ),
    );
  }

  factory MaketaskModel.fromMap(Map<String, dynamic> data) => MaketaskModel(
        id: data['id'] as String?,
        object: data['object'] as String?,
        created: data['created'] as int?,
        model: data['model'] as String?,
        choices: (data['choices'] as List<dynamic>?)
            ?.map((e) => Choice.fromMap(e as Map<String, dynamic>))
            .toList(),
        usage: data['usage'] == null
            ? null
            : Usage.fromMap(data['usage'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'object': object,
        'created': created,
        'model': model,
        'choices': choices?.map((e) => e.toMap()).toList(),
        'usage': usage?.toMap(),
      };

  factory MaketaskModel.fromJson(String data) {
    return MaketaskModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! MaketaskModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      object.hashCode ^
      created.hashCode ^
      model.hashCode ^
      choices.hashCode ^
      usage.hashCode;
}

class Usage {
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;

  const Usage({this.promptTokens, this.completionTokens, this.totalTokens});

  factory Usage.fromMap(Map<String, dynamic> data) => Usage(
        promptTokens: data['prompt_tokens'] as int?,
        completionTokens: data['completion_tokens'] as int?,
        totalTokens: data['total_tokens'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'prompt_tokens': promptTokens,
        'completion_tokens': completionTokens,
        'total_tokens': totalTokens,
      };

  @override
  int get hashCode =>
      promptTokens.hashCode ^ completionTokens.hashCode ^ totalTokens.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usage &&
          promptTokens == other.promptTokens &&
          completionTokens == other.completionTokens &&
          totalTokens == other.totalTokens;
}

class Message {
  final String? role;
  final String? content;
  final String? reasoning; 

  Message({this.role, this.content, this.reasoning});

  factory Message.fromMap(Map<String, dynamic> data) => Message(
        role: data['role'] as String?,
        content: data['content'] as String?,
        
        reasoning: data['reasoning_content'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'role': role,
        'content': content,
        'reasoning_content': reasoning,
      };

  @override
  int get hashCode => role.hashCode ^ content.hashCode ^ reasoning.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          role == other.role &&
          content == other.content &&
          reasoning == other.reasoning;
}

class Choice {
  final int? index;
  final Message? message;
  final String? finishReason;

  Choice({this.index, this.message, this.finishReason});

  factory Choice.fromMap(Map<String, dynamic> data) => Choice(
        index: data['index'] as int?,
        message: data['message'] == null
            ? null
            : Message.fromMap(data['message'] as Map<String, dynamic>),
        finishReason: data['finish_reason'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'index': index,
        'message': message?.toMap(),
        'finish_reason': finishReason,
      };

  @override
  int get hashCode => index.hashCode ^ message.hashCode ^ finishReason.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Choice &&
          index == other.index &&
          message == other.message &&
          finishReason == other.finishReason;
}
