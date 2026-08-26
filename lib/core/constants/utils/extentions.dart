import 'package:flutter/material.dart';

extension Short on String {
  String get shortdes {
    final words = this.trim().split(RegExp(r'[\s\u200c]+'));
    if (words.length > 20) {
      return "${words.take(20).join(' ')}...";
    } else {
      return this.trim();
    }
  }
}

extension Validator on String {
  bool get isclean {
    return !RegExp(r'\s+').hasMatch(this);
  }

  String get clean {
    // 1. trim: حذف فضاهای خالی اول و آخر
    // 2. replaceAll: حذف هر نوع فضای خالی (Space, Tab, Enter) در کل متن
    // 3. toLowerCase: تبدیل به حروف کوچک
    return this.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase();
  }

  String get finalword {
    return this.trim().toLowerCase();
  }
}

extension MediaQueries on BuildContext {
  // گرفتن عرض کل صفحه
  double get width => MediaQuery.of(this).size.width;

  // گرفتن ارتفاع کل صفحه
  double get height => MediaQuery.of(this).size.height;

  // گرفتن درصد از عرض (مثلاً 0.5 عرض صفحه رو میده)
  double widthPct(double percent) => MediaQuery.of(this).size.width * percent;

  // گرفتن درصد از ارتفاع
  double heightPct(double percent) => MediaQuery.of(this).size.height * percent;

  // چک کردن اینکه آیا گوشی در حالت افقی (Landscape) هست یا نه
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}

// این را در فایل دیگری تعریف کنید و import کنید.
extension BoxConstraintsExtensions on BoxConstraints {
  // نسبت عرض کانتینر فعلی به حداکثر عرض در دسترس
  double get widthRatio =>
      maxWidth; // فرض می کنیم اینجا منظور شما خود maxWidth است
  // نسبت ارتفاع کانتینر فعلی به حداکثر ارتفاع در دسترس
  double get heightRatio =>
      maxHeight; // فرض می کنیم اینجا منظور شما خود maxHeight است

  // مثال: اگر بخواهید عرض را با یک درصد محاسبه کنید (با فرض اینکه constrains.maxWidth را داریم)
  double getWidthWithPercentage(double percentage) {
    return maxWidth * percentage;
  }

  double getHeightWithPercentage(double percentage) {
    return maxHeight * percentage;
  }
}

// حتما این رو بالا اضافه کن
extension FarsiNumberExtension on String {
  String get farsiNumber1 {
    String text = this;

    // ۱. حذف ".0" از انتهای رشته (اگر وجود داشته باشد)
    // چون متغیرهای lineTotal از نوع double هستند، معمولا به شکل "2500.0" به استرینگ تبدیل می‌شوند.
    if (text.endsWith('.0')) {
      text = text.substring(0, text.length - 2);
    }

    // ۲. جداسازی سه رقم سه رقم با استفاده از Regex
    // این الگو باهوش است و فقط به اعداد صحیح (قبل از اعشار در صورت وجود) کار دارد
    text = text.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    // ۳. تبدیل ارقام انگلیسی به فارسی
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      text = text.replaceAll(english[i], farsi[i]);
    }

    return text;
  }
}

extension StringLimit on String {
  // این متد متن رو می‌گیره و تبدیل به ویجت Text با قابلیت سه نقطه می‌کنه
  Widget toText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.right,
    TextOverflow? overflow,
  }) {
    return Text(
      this,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis, // 👈 اصلِ کاری اینجاست (سه نقطه)
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: "IranYekan", // فونت جدیدت رو اینجا ست کن
      ),
    );
  }
}
