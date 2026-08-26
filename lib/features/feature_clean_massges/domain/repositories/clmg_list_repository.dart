import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_list_entity.dart';

import '../../../../core/resources/data_state.dart' show DataState;

abstract class ClmgListRepository {
  Future<DataState<ClnMgListEntity>> saveTaskList(
      ClnMgListEntity clnMgListEntity);
  Future<DataState<ClnMgListEntity>> fetchAllTasks(String id);
  Future<DataState<ClnMgListEntity>> deletetask(ClnMgListEntity newmglist);
  Future<DataState<ClnMgListEntity>> addtask(ClnMgListEntity newmglist);
  Future<DataState<ClnMgListEntity>> updatetaskList(ClnMgListEntity newmglist);
}
