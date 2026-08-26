import 'package:flutter/material.dart'; // اضافه شده برای لاگ
import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/local/maketask_localmodel.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/task_list_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/hive_services.dart';
import '../models/maketask_model/local/task_list_local_model.dart';
import 'package:injectable/injectable.dart';

// @Injectable(as: TasksRepository) برای پیاده‌سازی TasksRepository
// @lazySingleton
@Injectable(as: TasksRepository)
@lazySingleton
class TasksRepositoryImpl extends TasksRepository {
  HiveService hiveService;
  TasksRepositoryImpl(this.hiveService);

  @override
  Future<DataState<bool>> saveTaskList(TaskListEntity taskListEntity) async {
    try {
      debugPrint('🛠️ Repo: Converting Entity to LocalModel for saving...');
      final List<MaketaskLocalModel> models = taskListEntity.tasks
          .map((e) => MaketaskLocalModel.fromEntity(e))
          .toList();

      final String finalId =
          taskListEntity.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      TaskListLocalModel taskListAdapterModel =
          TaskListLocalModel(id: finalId, tasks: models);

      await hiveService.saveOrUpdateTaskList(taskListAdapterModel);
      debugPrint('✅ Repo: Save successful for ID: $finalId');
      return DataSuccess(true);
    } catch (e) {
      debugPrint('❌ Repo Save Error: $e');
      return DataFailed("$e");
    }
  }

  @override
  Future<DataState<TaskListEntity>> fetchAllTasks(String id) async {
    try {
      debugPrint('🔍 Repo: Fetching tasks for ID: $id');
      final TaskListLocalModel? result = hiveService.getTaskListById(id);

      if (result != null) {
        final tasklist = result.tasks;
        final taskListModel = TaskListEntity(id: id, tasks: tasklist);
        debugPrint('✅ Repo: Fetch successful. Found ${tasklist.length} tasks.');
        return DataSuccess(taskListModel);
      } else {
        debugPrint('⚠️ Repo: No data found in Hive for ID: $id');
        return DataFailed("دیتایی یافت نشد");
      }
    } catch (e) {
      debugPrint('❌ Repo Fetch Error: $e');
      return DataFailed("خطا: $e");
    }
  }

  @override
  Future<DataState<TaskListEntity>> addtask(
      String id, List<MaketaskEntity> newTasks) async {
    try {
      debugPrint('➕ Repo: Adding tasks to list [$id]');

      // ۱. تبدیل مستقیم تمام تسک‌هایی که از Bloc آمده به مدل دیتابیس
      // این لیست خودش شامل همه تسک‌های فعلی است
      final List<MaketaskLocalModel> finalModels =
          newTasks.map((e) => MaketaskLocalModel.fromEntity(e)).toList();

      // ۲. ذخیره مستقیم در Hive (جایگزین کردن لیست قبلی)
      // Hive بر اساس ID، لیست قبلی را پاک و این لیست جدید را جایگزین می‌کند
      await hiveService
          .saveOrUpdateTaskList(TaskListLocalModel(id: id, tasks: finalModels));

      debugPrint('✅ Repo: Task(s) added successfully to ID: $id');

      // برگرداندن انتیتی به لایه بالاتر
      return DataSuccess(TaskListEntity(id: id, tasks: newTasks));
    } catch (e) {
      debugPrint('❌ Repo Add Task Error: $e');
      return DataFailed("$e");
    }
  }

  @override
  Future<DataState<bool>> deletetask(
      String id, List<MaketaskEntity> newTasks) async {
    try {
      debugPrint('🗑️ Repo: Deleting list [$id]');
      final currentList = hiveService.getTaskListById(id);
      if (currentList != null) {
        final List<MaketaskLocalModel> models =
            newTasks.map((e) => MaketaskLocalModel.fromEntity(e)).toList();
        await hiveService
            .saveOrUpdateTaskList(TaskListLocalModel(id: id, tasks: models));
        return DataSuccess(true);
      } else {
        return DataFailed("the List was Null");
      }
    } catch (e) {
      debugPrint('❌ Repo Delete Error: $e');
      return DataFailed("$e");
    }
  }

  @override
  Future<DataState<bool>> updatetaskList(
      String id, List<MaketaskEntity> updatedTasks) async {
    try {
      final currentList = hiveService.getTaskListById(id);
      if (currentList != null) {
        final List<MaketaskLocalModel> models =
            updatedTasks.map((e) => MaketaskLocalModel.fromEntity(e)).toList();
        await hiveService
            .saveOrUpdateTaskList(TaskListLocalModel(id: id, tasks: models));
        return DataSuccess(true);
      } else {
        return DataFailed("The list was null");
      }
    } catch (e) {
      return DataFailed("$e");
    }
  }
}
