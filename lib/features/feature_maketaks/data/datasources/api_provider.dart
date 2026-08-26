import 'package:ai_app/core/constants/constant.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_openai/dart_openai.dart';

@lazySingleton
class ApiProvider {
  ApiProvider() {
    OpenAI.apiKey = Aiapi.apikeyGapGpt;
    OpenAI.baseUrl = Aiapi.baseUrlGapGpt;
  }

  Future<dynamic> makeTask(String message) async {
    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              Prompts.maketask ?? "abmjn")
        ],
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(message)
        ],
        role: OpenAIChatMessageRole.user,
      ),
    ];
    final chatCompletion = await OpenAI.instance.chat
        .create(model: AiNames.gapgptqwen3, messages: messages);
    return chatCompletion;
  }
}
