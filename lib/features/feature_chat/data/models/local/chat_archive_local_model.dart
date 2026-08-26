import 'package:hive/hive.dart';
import '../../../domain/entities/chat_archives_entity.dart';
import 'chat_message_local_model.dart';

// اتصال به فایل جنریت‌شونده
part 'chat_archive_local_model.g.dart';

@HiveType(typeId: 1) // آیدی یک برای آرشیو (نباید تکراری باشه)
class ChatArchiveLocalModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<ChatMessageLocalModel> chat;

  ChatArchiveLocalModel({required this.id, required this.chat});

  ChatArchivesEntity toEntity() {
    return ChatArchivesEntity(
      id: id,
      chat: chat.map((msg) => msg.toEntity()).toList(),
    );
  }

  factory ChatArchiveLocalModel.fromEntity(ChatArchivesEntity entity) {
    return ChatArchiveLocalModel(
      id: entity.id,
      chat: entity.chat
          .map((msg) => ChatMessageLocalModel.fromEntity(msg))
          .toList(),
    );
  }
}
