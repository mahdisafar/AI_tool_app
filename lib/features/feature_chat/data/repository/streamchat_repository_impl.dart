import 'dart:convert';
import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_chat/data/data_source/chat_stream_api_provider.dart';
import 'package:ai_app/features/feature_chat/domain/entities/chat_message_entity.dart';
import 'package:ai_app/features/feature_chat/domain/repositories/streamchat_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: Streamchatrepository)
class StreamchatRepositoryImpl extends Streamchatrepository {
  final ChatStreamApiProvider chat;

  StreamchatRepositoryImpl({required this.chat});

  @override
  Stream<DataState<String>> openchat(
    String message,
    String imageUrl,
    List<ChatMessageEntity> history,
  ) async* {
    try {
      final List<Map<String, dynamic>> mappedHistory = history.map((msg) {
        return {"role": msg.isUser ? "user" : "assistant", "content": msg.text};
      }).toList();

      debugPrint(" Calling Stream API via Dio...");

      final Stream<String> rawStream = chat.chatstream(
        message,
        imageUrl,
        mappedHistory,
      );

      bool hasData = false;

      await for (final line in rawStream) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();

          if (data == '[DONE]') {
            break;
          }

          try {
            final json = jsonDecode(data);
            if (json is Map<String, dynamic>) {
              hasData = true;

              final choices = json['choices'] as List<dynamic>?;
              if (choices != null && choices.isNotEmpty) {
                final delta = choices.first['delta'] as Map<String, dynamic>?;
                final extractedText = delta?['content'] as String?;

                if (extractedText != null && extractedText.isNotEmpty) {
                  yield DataSuccess(extractedText);
                }
              }
            }
          } catch (e) {
            debugPrint(" Parsing error (Ignored): $e, line: $line");
          }
        }
      }

      if (!hasData) {
        debugPrint("Stream was empty! Hugging Face sent 0 chunks.");
        yield DataFailed("stream was empty");
      }
    } catch (e) {
      debugPrint("Stream Exception: $e");
      yield DataFailed(e.toString());
    }
  }
}
