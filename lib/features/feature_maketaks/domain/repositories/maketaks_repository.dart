import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';

abstract class MaketaksRepository {
  Future<DataState<MaketaskEntity>> fetchAitask(String message);
}
