import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/core/usecase/usecase.dart';
import 'package:ai_app/features/feature_chat/domain/entities/chat_message_entity.dart';
import 'package:injectable/injectable.dart';

import '../repositories/streamchat_repository.dart' show Streamchatrepository;

@lazySingleton
class StreamchatUsecase extends StreamUseCase<DataState<String>,
    (String, String, List<ChatMessageEntity>)> {
  final Streamchatrepository streamchatrepository;
  StreamchatUsecase({required this.streamchatrepository});
  @override
  Stream<DataState<String>> stream(
      (String, String, List<ChatMessageEntity>) params) async* {
    final (message, imageUrl, history) = params;
    yield* streamchatrepository.openchat(message, imageUrl, history);
  }
}
