import 'package:hive/hive.dart';
import '../../../domain/entities/chat_message_entity.dart';


part 'chat_message_local_model.g.dart';

@HiveType(typeId: 0) 
class ChatMessageLocalModel {
  @HiveField(0)
  final bool isUser;

  @HiveField(1)
  final String text;

  ChatMessageLocalModel({required this.isUser, required this.text});

  
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(isUser: isUser, text: text);
  }

  
  factory ChatMessageLocalModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageLocalModel(isUser: entity.isUser, text: entity.text);
  }
}
