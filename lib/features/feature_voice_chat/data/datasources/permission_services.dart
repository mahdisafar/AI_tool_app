import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionService {
  /// بررسی و درخواست دسترسی به میکروفون
  Future<bool> requestMicrophonePermission() async {
    // ابتدا وضعیت فعلی رو چک می‌کنه
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    }

    // اگر دسترسی داده نشده بود، درخواست میده
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  /// فقط بررسی اینکه آیا از قبل دسترسی داریم یا نه (بدون باز کردن دایالوگ سیستم‌عامل)
  Future<bool> hasMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  /// اگر کاربر دسترسی رو Permanently Denied کرده باشه، این متد تنظیمات گوشی رو باز می‌کنه
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
