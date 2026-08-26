import 'package:ai_app/core/resources/data_state.dart';

import '../../data/datasources/livekit_service.dart';

abstract class LiveChatRepository {
  Future<DataState<bool>> checkMicPermission();

  Future<DataState<bool>> startSession();

  Future<DataState<bool>> endCall();

  Future<DataState<bool>> diconnectMic();

  Future<DataState<bool>> enableMic();

  Stream<VoiceSessionData> liveState();
}
