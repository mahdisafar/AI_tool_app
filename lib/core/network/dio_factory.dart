import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';

class DioFactory {
  static Dio getAiDio(String baseUrl, String apiKey) {
    Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      validateStatus: (status) => status! < 500,
      headers: {
        'Authorization':
            'Bearer ${apiKey.trim()}', // اضافه کردن trim برای حذف هرگونه فاصله احتمالی
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // --- بای‌پس کردن SSL ---
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // --- اینترسپتور برای دیباگ دقیق ---
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint("\n--- 📝 AI REQUEST ---");
        debugPrint("🔗 URL: ${options.baseUrl}${options.path}");
        debugPrint("🔑 Auth: ${options.headers['Authorization']}");
        debugPrint("📦 Body: ${options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("\n--- 📥 SERVER RESPONSE ---");
        debugPrint("📊 Status: ${response.statusCode}");
        debugPrint(
            "📄 Data: ${response.data}"); // اینجا کل پاسخ را بدون هیچ پیش‌فرضی چاپ می‌کنیم
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint("\n--- ❌ DIO ERROR ---");
        debugPrint("⚠️ Status: ${e.response?.statusCode}");
        debugPrint("📄 Message: ${e.message}");
        return handler.next(e);
      },
    ));

    return dio;
  }
}
