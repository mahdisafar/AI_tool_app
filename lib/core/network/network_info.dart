import 'package:dio/dio.dart';

import '../errors/exeptions.dart';

class ArvanErrorHandler {
  static Never handle(DioException e) {
    
    if (_isNetworkError(e)) {
      throw AppException(
        message:
            "مشکل در اتصال به اینترنت یا تایم‌اوت سرور. لطفا وضعیت شبکه خود را بررسی کنید.",
        isNetworkError: true,
      );
    }

    
    if (e.response != null) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      
      String? serverMessage;
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        
        serverMessage = data['error']['message']?.toString();
      }

      switch (status) {
        case 400:
          throw AppException(
              message: serverMessage ??
                  "درخواست نامعتبر است. پارامترها را چک کنید.");
        case 401:
          throw AppException(
              message: "کلید API (API Key) معتبر نیست یا منقضی شده است.");
        case 403:
          throw AppException(
              message: "دسترسی غیرمجاز. محدودیت سطح دسترسی یا فیلترینگ.");
        case 404:
          throw AppException(message: "مدل یا سرویس مورد نظر پیدا نشد.");
        case 429:
          throw AppException(
              message:
                  "تعداد درخواست‌های شما بیش از حد مجاز است (Rate Limit). کمی صبر کنید.");
        case 500:
          throw AppException(
              message: "خطای داخلی سرور آروان. لطفا بعداً تلاش کنید.");
        case 503:
          throw AppException(
              message:
                  "سرویس آروان در حال حاضر در دسترس نیست (تعمیرات یا ترافیک بالا).");
        default:
          throw AppException(
              message: serverMessage ?? "خطای ناشناخته سرور: $status");
      }
    }

    
    throw AppException(
      message: "یک خطای غیرمنتظره رخ داد. لطفا دوباره تلاش کنید.",
      isNetworkError: false,
    );
  }

  static bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.unknown;
  }

  static String getErrorMessage(DioException e) {
    
    if (_isNetworkError(e)) {
      return "مشکل در اتصال به اینترنت...";
    }
    if (e.response != null) {
      
      return "پیام استخراج شده یا پیام پیش‌فرض";
    }
    return "خطای ناشناخته";
  }
}
