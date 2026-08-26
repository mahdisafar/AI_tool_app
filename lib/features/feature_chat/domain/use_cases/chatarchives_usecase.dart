import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/core/usecase/usecase.dart';
import 'package:ai_app/features/feature_chat/domain/entities/chat_archives_entity.dart';
import 'package:ai_app/features/feature_chat/domain/entities/chat_message_entity.dart';
import 'package:ai_app/features/feature_chat/domain/repositories/chat_archives_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateNewChatUsecase
    extends UseCase<DataState<bool>, ChatArchivesEntity> {
  final ChatArchivesRepository repo;
  CreateNewChatUsecase({required this.repo});

  @override
  Future<DataState<bool>> call(ChatArchivesEntity chatEntity) {
    return repo.startchat(chatEntity);
  }
}

// ۲. یوزکیس گرفتن یک چت خاص با آیدی
@injectable
class GetChatUsecase extends UseCase<DataState<ChatArchivesEntity>, String> {
  final ChatArchivesRepository repo;
  GetChatUsecase({required this.repo});

  @override
  Future<DataState<ChatArchivesEntity>> call(String id) {
    return repo.getchat(id);
  }
}

// ۳. یوزکیس حذف یک چت
@injectable
class DeleteChatUsecase
    extends UseCase<DataState<List<ChatArchivesEntity>>, String> {
  final ChatArchivesRepository repo;
  DeleteChatUsecase({required this.repo});
  @override
  Future<DataState<List<ChatArchivesEntity>>> call(String id) {
    return repo.deletechat(id);
  }
}

@injectable
class GetAllchatsUseCase
    extends UseCase<DataState<List<ChatArchivesEntity>>, Null> {
  final ChatArchivesRepository repo;

  GetAllchatsUseCase({required this.repo});
  @override
  Future<DataState<List<ChatArchivesEntity>>> call(Null param) async {
    return repo.getallChats();
  }
}

// ۴. یوزکیس اضافه کردن پیام به آرشیو چت
@injectable
class AddMessageToArchiveUsecase
    extends UseCase<DataState<bool>, AddMessageParams> {
  final ChatArchivesRepository repo;
  AddMessageToArchiveUsecase({required this.repo});

  @override
  Future<DataState<bool>> call(AddMessageParams params) {
    return repo.addMessagetoArchive(params.archiveId, params.message);
  }
}

class AddMessageParams {
  final String archiveId;
  final ChatMessageEntity message;

  AddMessageParams({required this.archiveId, required this.message});
}
