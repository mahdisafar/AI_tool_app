import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart';

import '../../../../core/resources/data_state.dart' show DataState;

abstract class MakeClnmgRepository {
  Future<DataState<ClnMgEntity>> makeclnmg(String message);
}
