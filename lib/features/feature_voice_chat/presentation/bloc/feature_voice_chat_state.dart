part of 'feature_voice_chat_bloc.dart';

abstract class FeatureVoiceChatState extends Equatable {
  const FeatureVoiceChatState();
  @override
  List<Object> get props => [];
}

class VoiceSessionActiveState extends FeatureVoiceChatState {
  final VoiceSessionData sessionData;
  final bool isMicEnabled; 

  const VoiceSessionActiveState(this.sessionData, {this.isMicEnabled = false});

  @override
  List<Object> get props => [sessionData, isMicEnabled];
}

class VoiceChatInitialState extends FeatureVoiceChatState {}

class LoadingSessionState extends FeatureVoiceChatState {}

class SessionReadyState extends FeatureVoiceChatState {}

class UserTalkingState extends FeatureVoiceChatState {}

class PermissionErrorState extends FeatureVoiceChatState {}

class SessionErrorState extends FeatureVoiceChatState {}

class OperationErrorState extends FeatureVoiceChatState {
  final String message;
  const OperationErrorState(this.message);
  @override
  List<Object> get props => [message];
}
