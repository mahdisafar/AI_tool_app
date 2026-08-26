import 'package:ai_app/core/constants/constant.dart';

import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_maketaks/data/datasources/api_provider.dart';
import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/remote/maketask_model.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/maketaks_repository.dart';

// @Injectable(as: MaketaksRepository) می‌گه که این کلاس پیاده‌سازی MaketaksRepository است
// @lazySingleton برای ثبت به صورت Singleton تنبل
@Injectable(as: MaketaksRepository)
@lazySingleton
class MaketaksRepositoryImpl extends MaketaksRepository {
  ApiProvider apiProvider;
  MaketaksRepositoryImpl(this.apiProvider);
  @override
  Future<DataState<MaketaskEntity>> fetchAitask(String message) async {
    try {
      OpenAIChatCompletionModel response = await apiProvider.makeTask(message);

      MaketaskEntity maketaskEntity =
          MaketaskModel.fromOpenAI(response, AiNames.gapgptqwen3);
      debugPrint("maketaskEntity ID: ${maketaskEntity.id}");
      return DataSuccess(maketaskEntity);
    } on RequestFailedException catch (e) {
      return DataFailed("خطای سرور: ${e.message}, کد: ${e.statusCode}");
    } catch (e) {
      return DataFailed("Error in repo maketask:$e");
    }
  }
}
