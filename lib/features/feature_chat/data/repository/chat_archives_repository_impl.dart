import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_chat/data/data_source/chat_archive_hive.dart';
import 'package:ai_app/features/feature_chat/data/models/local/chat_archive_local_model.dart';
import 'package:ai_app/features/feature_chat/data/models/local/chat_message_local_model.dart';
import 'package:ai_app/features/feature_chat/domain/entities/chat_message_entity.dart';
import 'package:flutter/rendering.dart' show debugPrint;
import 'package:injectable/injectable.dart';
import '../../domain/entities/chat_archives_entity.dart';
import '../../domain/repositories/chat_archives_repository.dart';

@LazySingleton(as: ChatArchivesRepository)
class ChatArchivesRepositoryImpl extends ChatArchivesRepository {
  final ChatArchiveHive hive;

  ChatArchivesRepositoryImpl({required this.hive});

  @override
  Future<DataState<bool>> addMessagetoArchive(
      String archiveid, ChatMessageEntity message) async {
    try {
      await hive.appendMessage(archiveid,
          ChatMessageLocalModel(isUser: message.isUser, text: message.text));
      return DataSuccess(true);
    } catch (e) {
      return DataFailed("error");
    }
  }

  @override
  Future<DataState<List<ChatArchivesEntity>>> deletechat(String id) async {
    try {
      List<ChatArchiveLocalModel> local = await hive.delete(id);
      if (local.isNotEmpty) {
        List<ChatArchivesEntity> entity =
            local.map((c) => c.toEntity()).toList();
        return DataSuccess(entity);
      } else {
        return DataSuccess([]);
      }
    } catch (e) {
      return DataFailed("error");
    }
  }

  @override
  Future<DataState<ChatArchivesEntity>> getchat(String id) async {
    try {
      ChatArchivesEntity? chatArchivesEntity;
      debugPrint("getting chat ID : $id");
      chatArchivesEntity = hive.getById(id)?.toEntity();
      if (chatArchivesEntity != null) {
        debugPrint(
            "first text in chat id $id: ${chatArchivesEntity.chat[0].text}");
        return DataSuccess(chatArchivesEntity);
      } else {
        return DataFailed("%chatarchive is null%");
      }
    } catch (e) {
      return DataFailed("error $e");
    }
  }

  @override
  Future<DataState<bool>> startchat(ChatArchivesEntity chatentity) async {
    try {
      ChatArchiveLocalModel local = ChatArchiveLocalModel(
          id: chatentity.id,
          chat: ChatArchiveLocalModel.fromEntity(chatentity).chat);
      await hive.saveOrUpdate(local);
      return DataSuccess(true);
    } catch (e) {
      return DataFailed("errors : $e");
    }
  }

  @override
  Future<DataState<List<ChatArchivesEntity>>> getallChats() async {
    try {
      List<ChatArchiveLocalModel> local = hive.getAll();
      if (local.isNotEmpty) {
        List<ChatArchivesEntity> entity =
            local.map((c) => c.toEntity()).toList();
        return DataSuccess(entity);
      } else {
        return DataSuccess([]);
      }
    } catch (e) {
      return DataFailed("errors : getting List $e");
    }
  }
}
