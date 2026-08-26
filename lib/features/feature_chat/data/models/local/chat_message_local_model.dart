import 'package:hive/hive.dart';
import '../../../domain/entities/chat_message_entity.dart';

// این خط خیلی مهمه تا فایل جنریت‌شده به این کلاس وصل بشه
part 'chat_message_local_model.g.dart';

@HiveType(typeId: 0) // آیدی صفر برای پیام
class ChatMessageLocalModel {
  @HiveField(0)
  final bool isUser;

  @HiveField(1)
  final String text;

  ChatMessageLocalModel({required this.isUser, required this.text});

  // تبدیل مدل دیتابیس به انتیتی (برای پاس دادن به لایه Domain)
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(isUser: isUser, text: text);
  }

  // ساخت مدل دیتابیس از روی انتیتی
  factory ChatMessageLocalModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageLocalModel(isUser: entity.isUser, text: entity.text);
  }
}
