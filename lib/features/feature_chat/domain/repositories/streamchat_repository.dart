import '../../../../core/resources/data_state.dart';
import '../entities/chat_message_entity.dart';

abstract class Streamchatrepository {
  Stream<DataState<String>> openchat(
      String message, String imageUrl, List<ChatMessageEntity> history);
}
