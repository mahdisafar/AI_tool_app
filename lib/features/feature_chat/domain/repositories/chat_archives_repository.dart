import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_chat/domain/entities/chat_message_entity.dart';

import '../entities/chat_archives_entity.dart';

abstract class ChatArchivesRepository {
  Future<DataState<bool>> startchat(ChatArchivesEntity chatArchivesentity);
  Future<DataState<bool>> addMessagetoArchive(
      String archiveid, ChatMessageEntity message);
  Future<DataState<List<ChatArchivesEntity>>> deletechat(String id);
  Future<DataState<ChatArchivesEntity>> getchat(String archiveid);
  Future<DataState<List<ChatArchivesEntity>>> getallChats();
}
