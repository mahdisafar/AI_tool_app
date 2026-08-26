import 'package:ai_app/features/feature_chat/domain/entities/chat_message_entity.dart';

class ChatArchivesEntity {
  final String id;
  final List<ChatMessageEntity> chat;

  ChatArchivesEntity({required this.id, required this.chat});
}
