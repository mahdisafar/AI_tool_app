import 'package:ai_app/core/usecase/usecase.dart';
import 'package:ai_app/features/feature_voice_chat/domain/repositories/live_chat_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/resources/data_state.dart';
import '../../data/datasources/livekit_service.dart';

enum ErrorType {
  sessionStartFailed,
  micPerFalid,
  micEnableFailed,
  micDisableFailed,
  disconnectFailed
}

@injectable
class GetReadyLiveChatUsecase extends UseCase {
  final LiveChatRepository repo;
  GetReadyLiveChatUsecase({required this.repo});

  @override
  Future<DataState> call(param) async {
    final micPermision = await repo.checkMicPermission();
    if (micPermision is DataSuccess) {
      final session = await repo.startSession();
      if (session is DataSuccess) {
        return DataSuccess(null);
      }
      return DataFailed("", errorType: ErrorType.sessionStartFailed);
    }
    return DataFailed("", errorType: ErrorType.micPerFalid);
  }
}

@injectable
class EnableMicUseCase extends UseCase {
  final LiveChatRepository repo;
  EnableMicUseCase({required this.repo});

  @override
  Future<DataState> call(param) async {
    final result = await repo.enableMic();
    if (result is DataSuccess) return DataSuccess(null);
    return DataFailed("", errorType: ErrorType.micEnableFailed);
  }
}

@injectable
class DisableMicUseCase extends UseCase {
  final LiveChatRepository repo;
  DisableMicUseCase({required this.repo});

  @override
  Future<DataState> call(param) async {
    final result = await repo.diconnectMic();
    if (result is DataSuccess) return DataSuccess(null);
    return DataFailed("", errorType: ErrorType.micDisableFailed);
  }
}

@injectable
class DisposeEveryThingUseCase extends UseCase {
  final LiveChatRepository repo;
  DisposeEveryThingUseCase({required this.repo});

  @override
  Future<DataState> call(param) async {
    
    await repo.diconnectMic();
    final result = await repo.endCall();
    if (result is DataSuccess) return DataSuccess(null);
    return DataFailed("", errorType: ErrorType.disconnectFailed);
  }
}

@injectable
class WatchVoiceSessionUseCase extends StreamUseCase {
  final LiveChatRepository repo;

  WatchVoiceSessionUseCase(this.repo);

  @override
  Stream<VoiceSessionData> stream(param) async* {
    yield* repo.liveState();
  }
}
