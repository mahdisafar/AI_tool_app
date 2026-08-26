import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_voice_chat/data/datasources/livekit_service.dart';
import 'package:ai_app/features/feature_voice_chat/data/datasources/livekit_token_service.dart';
import 'package:ai_app/features/feature_voice_chat/data/datasources/permission_services.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/constant.dart';
import '../../domain/repositories/live_chat_repository.dart';

@LazySingleton(as: LiveChatRepository)
class LiveChatImplRepository extends LiveChatRepository {
  final LivekitService livekit;
  final PermissionService per;
  final LiveKitTokenService tokenService;

  LiveChatImplRepository({
    required this.livekit,
    required this.per,
    required this.tokenService,
  });

  @override
  Future<DataState<bool>> checkMicPermission() async {
    try {
      final hasPermission = await per.requestMicrophonePermission();
      if (hasPermission) {
        print('✅ checkMicPermission: Success');
        return DataSuccess(true);
      }
      print('❌ checkMicPermission: Failed (Permission Denied)');
      return DataFailed('دسترسی به میکروفون توسط کاربر رد شده است.');
    } catch (e) {
      print('❌ checkMicPermission: Exception -> $e');
      return DataFailed('خطا در بررسی پرمیشن میکروفون: $e');
    }
  }

  @override
  @override
  Future<DataState<bool>> startSession() async {
    try {
      // مستقیم با توکن و URL خودت اتصال رو برقرار کن
      await livekit.startSession(
        url: Aiapi.livekitUrl,
        token: Aiapi.livekitTestToken, // یا همون توکنی که داری
      );

      print('✅ startSession: Success');
      return DataSuccess(true);
    } catch (e) {
      print('❌ startSession: Exception -> $e');
      return DataFailed('خطا در برقراری اتصال LiveKit: $e');
    }
  }

  @override
  Future<DataState<bool>> endCall() async {
    try {
      await livekit.endCall();
      print('✅ endCall: Success');
      return DataSuccess(true);
    } catch (e) {
      print('❌ endCall: Exception -> $e');
      return DataFailed('خطا در قطع اتصال: $e');
    }
  }

  @override
  Future<DataState<bool>> diconnectMic() async {
    try {
      await livekit.disconnectMic();
      print('✅ disconnectMic: Success');
      return DataSuccess(true);
    } catch (e) {
      print('❌ diconnectMic: Exception -> $e');
      return DataFailed('خطا در قطع میکروفون: $e');
    }
  }

  @override
  Future<DataState<bool>> enableMic() async {
    try {
      await livekit.connectMic();
      print('🎤 ✅ enableMic: Success (سخت‌افزار میکروفون فعال شد)');
      return DataSuccess(true);
    } catch (e) {
      print('❌ enableMic: Exception -> $e');
      return DataFailed('خطا در فعال‌سازی میکروفون: $e');
    }
  }

  @override
  Stream<VoiceSessionData> liveState() async* {
    yield* livekit.observeVoiceSession();
  }
}
