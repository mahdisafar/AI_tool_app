part of 'feature_chat_bloc.dart';

abstract class FeatureChatEvent extends Equatable {
  const FeatureChatEvent();

  @override
  List<Object> get props => [];
}

class CreateNewArchive extends FeatureChatEvent {}

class MessageSent extends FeatureChatEvent {
  final String chatArchives;
  final String message;
  final String image;

  const MessageSent({
    required this.chatArchives,
    required this.message,
    required this.image,
  });
}

class Createchat extends FeatureChatEvent {
  final String message;
  final String image;

  const Createchat({
    required this.message,
    required this.image,
  });
}

class Streamchat extends FeatureChatEvent {
  final String text;
  const Streamchat({required this.text});
}

class FinishRes extends FeatureChatEvent {
  final String fullmessage;

  const FinishRes({required this.fullmessage});
}

class StopRes extends FeatureChatEvent {}

class GetMainchatsEvent extends FeatureChatEvent {
  final String id;

  const GetMainchatsEvent({required this.id});
}

class DeletechatsEvent extends FeatureChatEvent {
  final String id;

  const DeletechatsEvent({required this.id});
}

class GetAllchatArchives extends FeatureChatEvent {}

class ResetChatEvent extends FeatureChatEvent {}
