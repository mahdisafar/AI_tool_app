import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String text;
  final bool isUser;

  const ChatMessageEntity({
    required this.text,
    required this.isUser,
  });

  ChatMessageEntity copyWith({
    String? text,
  }) {
    return ChatMessageEntity(
      text: text ?? this.text,
      isUser: isUser,
    );
  }

  @override
  List<Object?> get props => [text, isUser];
}
