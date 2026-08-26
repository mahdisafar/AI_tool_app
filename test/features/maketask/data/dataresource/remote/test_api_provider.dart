import 'dart:io';

import 'package:ai_app/core/constants/constant.dart' show Aiapi;
import 'package:ai_app/features/feature_maketaks/data/datasources/api_provider.dart';
import 'package:dart_openai/dart_openai.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    dotenv.testLoad(fileInput: File("assets/config.env").readAsStringSync());
  });
  group("maketaskmodel", () {
    test("عیب‌یابی درخواست API", () async {
      final api = ApiProvider();

      try {
        print("API KEY: ${Aiapi.apikeyGapGpt}");
        print("BASE URL: ${Aiapi.baseUrlGapGpt}");
        final response = await api.makeTask(
            "خرید خانه از املاک پوربیرک و تنظیم سند چک نباید یادم بره ");

        print("--- شروع بررسی پاسخ ---");

        // استخراج متن اصلی پاسخ
        final aiMessage = response.choices.first.message.content?.first.text;

        print("شناسه پاسخ: ${response.id}");
        // فیلد model را حذف کن چون باعث خطا می‌شود
        print("محتوای تولید شده توسط هوش مصنوعی: \n$aiMessage");

        expect(aiMessage, isNotNull);
      } on RequestFailedException catch (e) {
        print("❌ ارور مستقیم از سرور:");
        print("پیام سرور: ${e.message}");
        print("کد وضعیت (Status Code): ${e.statusCode}");
      } catch (e) {
        print("❌ خطای متفرقه: $e");
      }
    });
  });
}
