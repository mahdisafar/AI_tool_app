import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_message_api_provider.dart';
import 'package:ai_app/features/feature_clean_massges/data/models/remote/cln_mg_model.dart';
import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/widgets.dart' show debugPrint;
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constant.dart' show AiNames;
import '../../domain/repositories/make_clnmg_repository.dart';
import '../helper/extractmessage.dart';

// @Injectable(as: MakeClnmgRepository) برای پیاده‌سازی MakeClnmgRepository
// @lazySingleton
@Injectable(as: MakeClnmgRepository)
@lazySingleton
class MakeClnmgRepositoryImpl extends MakeClnmgRepository {
  final ClnMessageApiProvider api;

  MakeClnmgRepositoryImpl({required this.api});
  @override
  Future<DataState<ClnMgEntity>> makeclnmg(String message) async {
    if (message.trim().isEmpty) return DataFailed("متن نباید خالی باشد");
    try {
      OpenAIChatCompletionModel response = await api.createmessage(message);
      ClnMgEntity clnMgEntity =
          ClnmgModel.fromOpenAI(response, AiNames.gapgptqwen3);

      debugPrint(
          "✅ AI Raw Response: ${clnMgEntity.contentmessage}"); // برای دیدن پاسخ خام AI

      final String rawContent = clnMgEntity.contentmessage;
      if (rawContent.contains("INVALID_INPUT")) {
        debugPrint("⚠️ AI returned INVALID_INPUT"); // اضافه شد
        return DataFailed("هوش مصنوعی متوجه درخواست شما نشد.");
      }

      Map<String, String>? airesponse = extractMessageDetails(rawContent);

      if (airesponse == null) {
        debugPrint(
            "⚠️ extractMessageDetails returned NULL for: $rawContent"); // اضافه شد
      }

      clnMgEntity = ClnMgEntity(
          id: clnMgEntity.id,
          title: airesponse?['title'] ?? "Error",
          style: airesponse?['style'] ?? "Error",
          desc: airesponse?['body'] ?? "Error",
          contentmessage: clnMgEntity.contentmessage);
      return DataSuccess(clnMgEntity);
    } on RequestFailedException catch (e) {
      debugPrint(
          "❌ OpenAI Request Failed: ${e.message} | Code: ${e.statusCode}"); // اضافه شد
      return DataFailed("خطای سرور: ${e.message}, کد: ${e.statusCode}");
    } catch (e) {
      debugPrint("❌ Unexpected Error in makeclnmg: $e"); // اضافه شد
      return DataFailed("Error in repo  clean message:$e");
    }
  }
}
