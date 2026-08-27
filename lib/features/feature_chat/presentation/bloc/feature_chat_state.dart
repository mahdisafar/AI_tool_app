part of 'feature_chat_bloc.dart';

// state for chatmessage
enum ChatStatus {
  initial,
  idle,
  archiveLoading,
  streamloading,
  streaming,
  doneStream,
  succsesArchive,
  streamFailed,
  archiveFailed,
}

class ChatState extends Equatable {
  final List<ChatMessageEntity> messages;
  final ChatMessageEntity? streamingMessage;
  final ChatStatus status;
  final String? errorMessage;
  final String? chatId; 

  const ChatState({
    required this.messages,
    this.streamingMessage,
    required this.status,
    this.errorMessage,
    this.chatId, 
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    ChatMessageEntity? streamingMessage,
    bool clearStreamingMessage = false,
    ChatStatus? status,
    String? errorMessage,
    String? chatId, 
    bool clearChatId =
        false, 
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      streamingMessage: clearStreamingMessage
          ? null
          : (streamingMessage ?? this.streamingMessage),
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      chatId: clearChatId
          ? null
          : (chatId ?? this.chatId), 
    );
  }

  @override
  List<Object?> get props => [
        messages,
        streamingMessage,
        status,
        errorMessage,
        chatId
      ]; 
}

//state for every Archive chat
abstract class ChatArchicesState {}

class ChatArchicesInitail extends ChatArchicesState {}

class ChatArchicesSuccses extends ChatArchicesState {
  final ChatArchivesEntity? allchatEntity;

  ChatArchicesSuccses({
    this.allchatEntity,
  });
}

class ChatArchicesFailed extends ChatArchicesState {
  final String err;

  ChatArchicesFailed({required this.err});
}

class ChatArchicesLoading extends ChatArchicesState {}

//state for Allarchive chat
abstract class AllChatArchicesState {}

class AllChatArchicesInitial extends AllChatArchicesState {}

class AllChatArchicesSuccses extends AllChatArchicesState {
  final List<ChatArchivesEntity>? allchat;

  AllChatArchicesSuccses({required this.allchat});
}

class AllChatArchicesLoading extends AllChatArchicesState {}

class AllChatArchicesFailed extends AllChatArchicesState {
  final String err;

  AllChatArchicesFailed({required this.err});
}
