import 'dart:convert';
import 'package:ai_app/core/constants/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatStreamApiProvider {
  final Dio _dio;

  ChatStreamApiProvider() : _dio = Dio() {
    initDio();
  }

  void initDio() {
    _dio.options.baseUrl = Aiapi.hFBASEURL;
    _dio.options.headers = {
      'Authorization': 'Bearer ${Aiapi.hFAPIKEY}',
      'Content-Type': 'application/json',
    };
    debugPrint(
        "base URL :  ${_dio.options.baseUrl} , apiKey : ${Aiapi.hFAPIKEY} ");
  }

  Stream<String> chatstream(
    String message,
    String imageUrl,
    List<Map<String, dynamic>> history,
  ) async* {
    initDio();

    final List<Map<String, dynamic>> finalMessages = List.from(history);

    dynamic userContent;
    if (imageUrl.isNotEmpty) {
      userContent = [
        {"type": "text", "text": message},
        {
          "type": "image_url",
          "image_url": {"url": imageUrl}
        }
      ];
    } else {
      userContent = message;
    }

    finalMessages.add({
      "role": "user",
      "content": userContent,
    });

    final response = await _dio.post<ResponseBody>(
      '/chat/completions',
      data: {
        "model": AiNames.hFMODELID ?? "",
        "messages": finalMessages,
        "stream": true,
        "max_tokens": 1000,
        "chat_template_kwargs": {"enable_thinking": false},
      },
      options: Options(
        responseType: ResponseType.stream,
        
        validateStatus: (status) => true,
      ),
    );

    
    if (response.statusCode != 200) {
      final errorStream = response.data!.stream;
      final errorBytes = await errorStream.toList();
      final errorString = utf8.decode(errorBytes.expand((e) => e).toList());

      debugPrint("❌ HF Server Error (${response.statusCode}): $errorString");
      throw Exception("خطای سرور: $errorString");
    }

    final stream = response.data!.stream;
    yield* stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
  }
}
