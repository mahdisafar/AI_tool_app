import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/core/usecase/usecase.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:injectable/injectable.dart';

import '../repositories/maketaks_repository.dart';


@lazySingleton
class MaketaskUsecase extends UseCase<DataState<MaketaskEntity>, String> {
  final MaketaksRepository maketaksRepository;

  MaketaskUsecase(this.maketaksRepository);

  @override
  Future<DataState<MaketaskEntity>> call(String message) async {
    if (message.trim().isEmpty) return DataFailed("متن نباید خالی باشد");

    final result = await maketaksRepository.fetchAitask(message);

    if (result is DataFailed || result.data == null) {
      return DataFailed(result.errors ?? "خطای شبکه یا سرور");
    }

    final String rawContent = result.data!.messagecontent;

    if (rawContent.contains("INVALID_INPUT")) {
      return DataFailed("هوش مصنوعی متوجه درخواست شما نشد.");
    }

    try {
      final finalEntity =
          _extractEntityFromRawContent(result.data!, rawContent);
      return DataSuccess(finalEntity);
    } catch (e) {
      return DataFailed("خطا در تحلیل ساختار پاسخ");
    }
  }

  MaketaskEntity _extractEntityFromRawContent(
      MaketaskEntity original, String content) {
    final titleMatch = RegExp(r"TITLE:\s*(.*)").firstMatch(content);
    final descMatch = RegExp(r"DESCRIPTION:\s*([\s\S]*)").firstMatch(content);

    return MaketaskEntity(
      id: original.id,
      messagecontent: content,
      model: original.model,
      title: titleMatch?.group(1)?.trim() ?? "بدون تیتر",
      desc: descMatch?.group(1)?.trim() ?? "بدون توضیحات",
    );
  }
}
