import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';

import 'package:ai_app/features/feature_maketaks/domain/entities/task_list_entity.dart';

abstract class TasksRepository {
  Future<DataState<bool>> saveTaskList(TaskListEntity taskListEntity);
  Future<DataState<TaskListEntity>> fetchAllTasks(String id);
  Future<DataState<bool>> deletetask(String id, List<MaketaskEntity> newTasks);
  Future<DataState<TaskListEntity>> addtask(
      String id, List<MaketaskEntity> newTasks);
  Future<DataState<bool>> updatetaskList(
      String id, List<MaketaskEntity> newTasks);
}
