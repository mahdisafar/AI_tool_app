import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/core/usecase/usecase.dart';
import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart';
import 'package:injectable/injectable.dart';

import '../entities/cln_mg_list_entity.dart';
import '../repositories/clmg_list_repository.dart';
import '../repositories/make_clnmg_repository.dart';

// @lazySingleton برای Use Case ساخت پیام تمیز
@lazySingleton
class Makeclnmg extends UseCase<DataState<ClnMgEntity>, String> {
  final MakeClnmgRepository repo;

  Makeclnmg(this.repo);

  @override
  Future<DataState<ClnMgEntity>> call(String message) async {
    if (message.trim().isEmpty) return DataFailed("متن نباید خالی باشد");

    return await repo.makeclnmg(message);
  }
}

@lazySingleton
class GetClnMgListUseCase extends UseCase<DataState<ClnMgListEntity>, String> {
  final ClmgListRepository repository;

  GetClnMgListUseCase(this.repository);

  @override
  Future<DataState<ClnMgListEntity>> call(String params) {
    return repository.fetchAllTasks(params);
  }
}

@lazySingleton
class SaveClnMgListUseCase
    extends UseCase<DataState<ClnMgListEntity>, ClnMgListEntity> {
  final ClmgListRepository repository;

  SaveClnMgListUseCase(this.repository);

  @override
  Future<DataState<ClnMgListEntity>> call(ClnMgListEntity params) {
    return repository.saveTaskList(params);
  }
}

@lazySingleton
class AddClnMgUseCase
    extends UseCase<DataState<ClnMgListEntity>, ClnMgListEntity> {
  final ClmgListRepository repository;

  AddClnMgUseCase(this.repository);

  @override
  Future<DataState<ClnMgListEntity>> call(ClnMgListEntity params) {
    return repository.addtask(params);
  }
}

@lazySingleton
class DeleteClnMgUseCase
    extends UseCase<DataState<ClnMgListEntity>, ClnMgListEntity> {
  final ClmgListRepository repository;

  DeleteClnMgUseCase(this.repository);

  @override
  Future<DataState<ClnMgListEntity>> call(ClnMgListEntity params) {
    return repository.deletetask(params);
  }
}
