import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';

/// ۱. مدل ساختاریافته برای فریم‌های صوتی
class LiveAudioFrame {
  final Uint8List bytes;
  final int sampleRate;
  final int channels;

  LiveAudioFrame({
    required this.bytes,
    this.sampleRate = 24000,
    this.channels = 1,
  });
}

/// ۲. کلاس دیتاسورس بهینه‌شده برای تست پذیری بالا
class FirebaseAiDatasource {
  LiveSession? _session;

  final Stream<Uint8List> fakeMicStream = Stream<Uint8List>.periodic(
    const Duration(milliseconds: 100),
    (_) => Uint8List(3200),
  ).take(30);

  final LiveGenerativeModel _liveModel =
      FirebaseAI.googleAI().liveGenerativeModel(
    model: 'gemini-2.5-flash-native-audio-preview-12-2025',
    systemInstruction: Content.text(
      'You are a friendly assistant. Reply in Persian.',
    ),
    liveGenerationConfig: LiveGenerationConfig(
      responseModalities: [ResponseModalities.audio],
    ),
  );

  Future<void> connect() async {
    if (_session != null) return;
    _session = await _liveModel.connect();
  }

  void startSendingAudio() {
    fakeMicStream.listen(
      (Uint8List chunk) {
        final audioContent = Content.multi([
          InlineDataPart('audio/pcm;rate=16000', chunk),
        ]);
        _session?.send(input: audioContent, turnComplete: false);
      },
      onDone: () {
        _session?.send(turnComplete: true);
      },
    );
  }

  void listenToGoogleResponse({
    required Function(LiveAudioFrame frame) onAudioReceived,
    required Function(String text) onTextReceived,
    required Function() onComplete,
  }) {
    _session?.receive().listen(
      (LiveServerResponse response) {
        final LiveServerMessage message = response.message;

        if (message is LiveServerContent) {
          final Content? modelTurn = message.modelTurn;
          if (modelTurn == null) return;

          for (final part in modelTurn.parts) {
            if (part is InlineDataPart) {
              onAudioReceived(LiveAudioFrame(bytes: part.bytes));
            } else if (part is TextPart) {
              onTextReceived(part.text);
            }
          }

          if (message.turnComplete == true) {
            onComplete();
          }
        }
      },
      onError: (error) {
        fail("❌ استریم وب‌ساکت با خطا مواجه شد: $error");
      },
    );
  }
}

/// ۳. بدنه اصلی اجرای تست
void main() {
  // بیدار کردن موتور تست فلاتر
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      // شبیه‌سازی کانال‌های ارتباطی نیتیو فایربیس
      setupFirebaseCoreMocks();

      // ۱. خواندن فایل کانفیگ محلی شما
      final file = File('firebase.json');
      final jsonString = await file.readAsString();
      final Map<String, dynamic> config = jsonDecode(jsonString);

      // ۲. تلاش برای مقداردهی با شکار هوشمند ارور تکراری بودن
      try {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: config['apiKey'] ?? config['api_key'] ?? '',
            appId: config['appId'] ?? config['app_id'] ?? '',
            messagingSenderId:
                config['messagingSenderId'] ?? config['sender_id'] ?? '',
            projectId: config['projectId'] ?? config['project_id'] ?? '',
          ),
        );
        print("🔥 فایربیس با موفقیت برای اولین بار کانفیگ شد.");
      } on FirebaseException catch (e) {
        if (e.code == 'duplicate-app') {
          print("🔄 فایربیس از قبل در حافظه تست زنده بود. با موفقیت هدایت شد.");
        } else {
          rethrow; // اگر ارور دیگری بود بفرست جلو تا خراب نشود
        }
      }

      print("🚀 Ready! پروسه آماده اتصال به سرور زنده جمینای...");
    } catch (e) {
      fail("❌ خطا در تنظیمات اولیه محیط تست فایربیس: $e");
    }
  });

  group('تست‌های یکپارچه‌سازی پکیج Firebase AI Live', () {
    test(
        'باید به سرور متصل شود، ویس فرضی بفرستد و استریم پاسخ را با موفقیت بگیرد',
        () async {
      final datasource = FirebaseAiDatasource();
      final conversationCompleter = Completer<void>();

      bool hasReceivedAudio = false;
      bool hasReceivedText = false;

      // قدم اول: اتصال فیزیکی به وب‌ساکت گوگل
      await datasource.connect();

      // قدم دوم: باز کردن لوله لیسنر خروجی
      datasource.listenToGoogleResponse(
        onAudioReceived: (LiveAudioFrame frame) {
          hasReceivedAudio = true;
          expect(frame.bytes.isNotEmpty, true);
        },
        onTextReceived: (String text) {
          hasReceivedText = true;
          expect(text.isNotEmpty, true);
        },
        onComplete: () {
          if (!conversationCompleter.isCompleted) {
            conversationCompleter.complete();
          }
        },
      );

      // قدم سوم: شلیک صدا به سمت سرور
      datasource.startSendingAudio();

      // قدم چهارم: انتظار برای دریافت پاسخ کامل شبکه (تا سقف ۳۰ ثانیه)
      await conversationCompleter.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          fail(
              "🛑 خطای تایم‌اوت! سرور جمینای در زمان مشخص شده پاسخ کاملی ارسال نکرد.");
        },
      );

      // قدم پنجم: ارزیابی نهایی موفقیت تست
      expect(hasReceivedAudio, true,
          reason: "باید حداقل یک چانک صوتی دریافت می‌شد");
      expect(hasReceivedText, true,
          reason: "باید حداقل یک تیکه متن زیرنویس دریافت می‌شد");
    });
  });
}
