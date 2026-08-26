import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:ai_app/core/constants/constant.dart'; // آدرس ثابت‌های خودت

void main() {
  dotenv.testLoad(fileInput: File("assets/config.env").readAsStringSync());

  group('Hugging Face Live Connection Tests (VPN & Check)', () {
    test('Connects to Hugging Face and Streams Data Successfully', () async {
      print("🚀 شروع تست زنده... در حال اتصال به هاگینگ فیس...");

      // ۱. مقداردهی اولیه به پکیج با کانفیگ‌های تو
      OpenAI.apiKey = Aiapi.hFAPIKEY ?? "";
      OpenAI.baseUrl = Aiapi.hFBASEURL ?? "";

      try {
        // ۲. ارسال درخواست واقعی به صورت استریم
        final stream = OpenAI.instance.chat.createStream(
          model: AiNames.hFMODELID ?? "",
          messages: [
            OpenAIChatCompletionChoiceMessageModel(
              role: OpenAIChatMessageRole.user,
              content: [
                OpenAIChatCompletionChoiceMessageContentItemModel.text(
                    "Hi, respond with only one word 'Hello'"),
              ],
            )
          ],
        );

        // ۳. گوش دادن به استریم و چاپ کردن کلمات دریافتی در کنسول
        print("⏳ منتظر دریافت اولین پاسخ از استریم...");

        bool receivedData = false;
        StringBuffer fullResponse = StringBuffer();

        await for (final chunk in stream) {
          final content = chunk.choices.first.delta.content?.first?.text;
          if (content != null) {
            receivedData = true;
            fullResponse.write(content);
            print(" دریافت تیکه متن: $content");
          }
        }

        print("\n 🔹 پاسخ کامل دریافت شده: ${fullResponse.toString()}");

        // ۴. ارزیابی نهایی تست
        expect(receivedData, isTrue,
            reason:
                "استریم هیچ دیتایی برنگردوند! احتمالا مشکلی در اتصال وجود داره.");
        print(
            "✅ تست با موفقیت پاس شد! هم توکن سالمه و هم VPN شما استریم رو رد می‌کنه.");
      } catch (e) {
        print("\n❌ تست با خطا مواجه شد!");
        print("نوع خطا: ${e.runtimeType}");
        print("متن خطا: $e");

        // اگر خطا خورد، تست رو عمداً فیل کن تا متوجه بشی
        fail("اتصال به API شکست خورد. متن خطا رو بالا بخون.");
      }
    });
  });
}
