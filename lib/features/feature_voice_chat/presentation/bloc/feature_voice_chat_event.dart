part of 'feature_voice_chat_bloc.dart';

abstract class FeatureVoiceChatEvent extends Equatable {
  const FeatureVoiceChatEvent();

  @override
  List<Object> get props => [];
}


class InitialVoiceChatEvent extends FeatureVoiceChatEvent {}


class StartTalkingEvent extends FeatureVoiceChatEvent {}


class StopTalkingEvent extends FeatureVoiceChatEvent {}


class LeaveChatEvent extends FeatureVoiceChatEvent {}

class WatchSessionStateEvent extends FeatureVoiceChatEvent {}


class StartWatchingSessionEvent extends FeatureVoiceChatEvent {}

class _InternalSessionDataUpdated extends FeatureVoiceChatEvent {
  final VoiceSessionData data;
  const _InternalSessionDataUpdated(this.data);
}

class _InternalSessionError extends FeatureVoiceChatEvent {
  final String message;
  const _InternalSessionError(this.message);
}

enum ErrorType {
  sessionStartFailed,
  micPerFalid,
  micEnableFailed,
  micDisableFailed,
  disconnectFailed
}
