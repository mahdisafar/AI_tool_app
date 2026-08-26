part of 'feature_voice_chat_bloc.dart';

abstract class FeatureVoiceChatEvent extends Equatable {
  const FeatureVoiceChatEvent();

  @override
  List<Object> get props => [];
}

// برای استارت اولیه و چک پرمیشن
class InitialVoiceChatEvent extends FeatureVoiceChatEvent {}

// برای باز کردن میکروفون و حرف زدن با جمینای
class StartTalkingEvent extends FeatureVoiceChatEvent {}

// برای قطع کردن میکروفون (Mute / پایان صحبت)
class StopTalkingEvent extends FeatureVoiceChatEvent {}

// خروج کامل از صفحه چت
class LeaveChatEvent extends FeatureVoiceChatEvent {}

class WatchSessionStateEvent extends FeatureVoiceChatEvent {}

// ایونت‌های داخلی برای مدیریت استریم
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
