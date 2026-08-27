import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionService {
  
  Future<bool> requestMicrophonePermission() async {
    
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    }

    
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  
  Future<bool> hasMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
