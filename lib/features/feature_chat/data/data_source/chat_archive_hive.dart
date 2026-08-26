import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/local/chat_archive_local_model.dart';
import '../models/local/chat_message_local_model.dart';

@lazySingleton
class ChatArchiveHive {
  static const String boxName = 'chat_archive_box';

  Future<Box<ChatArchiveLocalModel>> openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<ChatArchiveLocalModel>(boxName);
    }
    return await Hive.openBox<ChatArchiveLocalModel>(boxName);
  }

  List<ChatArchiveLocalModel> getAll() {
    return _box.values.toList();
  }

  Box<ChatArchiveLocalModel> get _box =>
      Hive.box<ChatArchiveLocalModel>(boxName);

  Future<void> saveOrUpdate(ChatArchiveLocalModel archive) async {
    await _box.put(archive.id, archive);
  }

  Future<void> appendMessage(
      String archiveId, ChatMessageLocalModel msg) async {
    final archive = _box.get(archiveId);
    if (archive == null) return;

    archive.chat.add(msg);
    await _box.put(archiveId, archive);
  }

  ChatArchiveLocalModel? getById(String id) {
    return _box.get(id);
  }

  Future<List<ChatArchiveLocalModel>> delete(String id) async {
    await _box.delete(id);
    return getAll();
  }
}
