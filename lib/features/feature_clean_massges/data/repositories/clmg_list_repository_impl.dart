import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart';
import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_list_entity.dart';
import 'package:ai_app/features/feature_clean_massges/domain/repositories/clmg_list_repository.dart';
import '../datasources/cln_hive.dart';
import '../models/local/cln_mg_list_local_model.dart';
import '../models/local/cln_mg_local_model.dart' show ClnMgLocalModel;
import 'package:flutter/widgets.dart' show debugPrint; // اضافه شد
import 'package:injectable/injectable.dart';

// @Injectable(as: ClmgListRepository) برای پیاده‌سازی ClmgListRepository
// @lazySingleton
@Injectable(as: ClmgListRepository)
@lazySingleton
class ClmgListRepositoryImpl extends ClmgListRepository {
  final ClnHive hive;

  ClmgListRepositoryImpl({required this.hive});

  @override
  Future<DataState<ClnMgListEntity>> addtask(ClnMgListEntity newmglist) async {
    try {
      ClnMgListLocalModel localmodel = ClnMgListLocalModel(
          id: newmglist.id,
          mgs:
              newmglist.mgs.map((m) => ClnMgLocalModel.fromEntity(m)).toList());
      await hive.saveOrUpdateClnmgsList(localmodel);

      return DataSuccess(newmglist);
    } catch (e) {
      debugPrint("❌ Error in addtask: $e"); // اضافه شد
      return DataFailed("Error : $e");
    }
  }

  @override
  Future<DataState<ClnMgListEntity>> deletetask(
      ClnMgListEntity newmglist) async {
    try {
      ClnMgListLocalModel localmodel = ClnMgListLocalModel(
          id: newmglist.id,
          mgs:
              newmglist.mgs.map((m) => ClnMgLocalModel.fromEntity(m)).toList());
      await hive.saveOrUpdateClnmgsList(localmodel);

      return DataSuccess(newmglist);
    } catch (e) {
      debugPrint("❌ Error in deletetask: $e"); // اضافه شد
      return DataFailed("Error : $e");
    }
  }

  @override
  Future<DataState<ClnMgListEntity>> fetchAllTasks(String id) async {
    try {
      final ClnMgListLocalModel? localModel = hive.getClnmgsListById(id);
      if (localModel == null) {
        return DataSuccess(ClnMgListEntity(id: id, mgs: []));
      }
      List<ClnMgEntity> entityList =
          localModel.mgs.map((e) => ClnMgLocalModel.toEntity(e)).toList();
      return DataSuccess(ClnMgListEntity(id: localModel.id, mgs: entityList));
    } catch (e) {
      debugPrint("❌ Error in fetchAllTasks (id: $id): $e"); // اضافه شد
      return DataFailed("Error in featching Clean messages in db :$e");
    }
  }

  @override
  Future<DataState<ClnMgListEntity>> saveTaskList(
      ClnMgListEntity newmglist) async {
    try {
      ClnMgListLocalModel localmodel = ClnMgListLocalModel(
          id: newmglist.id,
          mgs:
              newmglist.mgs.map((m) => ClnMgLocalModel.fromEntity(m)).toList());
      await hive.saveOrUpdateClnmgsList(localmodel);

      return DataSuccess(newmglist);
    } catch (e) {
      debugPrint("❌ Error in saveTaskList: $e"); // اضافه شد
      return DataFailed("Error : $e");
    }
  }

  @override
  Future<DataState<ClnMgListEntity>> updatetaskList(
      ClnMgListEntity newmglist) async {
    try {
      ClnMgListLocalModel localmodel = ClnMgListLocalModel(
          id: newmglist.id,
          mgs:
              newmglist.mgs.map((m) => ClnMgLocalModel.fromEntity(m)).toList());
      await hive.saveOrUpdateClnmgsList(localmodel);

      return DataSuccess(newmglist);
    } catch (e) {
      debugPrint("❌ Error in updatetaskList: $e"); // اضافه شد
      return DataFailed("Error : $e");
    }
  }
}
