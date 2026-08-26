import 'package:flutter/material.dart';

// انام برای مدیریت راحت‌تر وضعیت‌ها
enum ChatStatus {
  pleaseTalk, // لطفا صحبت کنید
  listening, // در حال گوش دادن
  thinking, // در حال فکر کردن
  responding, // در حال پاسخگویی
  error, // 🎯 اضافه شد: وضعیت خطا
  idle // وضعیت عادی
}

class VoiceStatusCircle extends StatelessWidget {
  final ChatStatus status;
  final bool isLoading;
  final double size;

  const VoiceStatusCircle({
    super.key,
    this.status = ChatStatus.idle,
    this.isLoading = false,
    this.size = 220, // قطر دایره بزرگ
  });

  // متد کمکی برای ترجمه استیت به متن فارسی
  String _getStatusText() {
    switch (status) {
      case ChatStatus.pleaseTalk:
        return 'لطفاً صحبت کنید';
      case ChatStatus.listening:
        return 'در حال گوش دادن...';
      case ChatStatus.thinking:
        return 'در حال فکر کردن...';
      case ChatStatus.responding:
        return 'در حال پاسخگویی...';
      case ChatStatus.error: // 🎯 اضافه شد
        return 'بروز خطا!\nمجدداً تلاش کنید';
      case ChatStatus.idle:
        return 'آماده به کار';
    }
  }

  // متد کمکی برای تغییر رنگ دایره بر اساس اتمسفر استیت
  Color _getCircleColor(BuildContext context) {
    switch (status) {
      case ChatStatus.listening:
        return Colors.blue;
      case ChatStatus.thinking:
        return Colors.purple;
      case ChatStatus.responding:
        return Colors.green;
      case ChatStatus.error: // 🎯 اضافه شد
        return Colors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _getCircleColor(context);

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 400), // انیمیشن نرم موقع تغییر وضعیت
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activeColor.withAlpha(15),
        border: Border.all(
          color: activeColor.withAlpha(100),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: activeColor.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                  strokeWidth: 3,
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _getStatusText(),
                    key: ValueKey(
                        _getStatusText()), // برای انیمیشن روان تغییر متن
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: activeColor.withAlpha(230),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
