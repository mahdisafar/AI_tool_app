import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/task_list_entity.dart'; 
import '../repositories/tasks_repository.dart';
import 'package:injectable/injectable.dart';

// --- SaveTaskListUseCase ---
@lazySingleton
class SaveTaskListUseCase extends UseCase<DataState<bool>, TaskListEntity> {
  
  final TasksRepository tasksRepository;

  SaveTaskListUseCase({required this.tasksRepository});

  @override
  Future<DataState<bool>> call(TaskListEntity taskListEntity) {
    
    if (taskListEntity.tasks.isEmpty) {
      
      return Future.value(DataFailed("لیست نمی‌تواند خالی باشد"));
    }
    return tasksRepository.saveTaskList(taskListEntity);
  }
}


@lazySingleton
class FetchAllTasksUseCase extends UseCase<DataState<TaskListEntity>, String> {
  final TasksRepository tasksRepository;

  FetchAllTasksUseCase({required this.tasksRepository});

  @override
  Future<DataState<TaskListEntity>> call(String id) {
    
    return tasksRepository.fetchAllTasks(id);
  }
}

// --- AddTaskUseCase ---
@lazySingleton
class AddTaskUseCase
    extends UseCase<DataState<TaskListEntity>, TaskListEntity> {
  
  final TasksRepository tasksRepository;

  AddTaskUseCase({required this.tasksRepository});

  @override
  Future<DataState<TaskListEntity>> call(TaskListEntity taskListEntity) {
    
    
    
    return tasksRepository.addtask(
        taskListEntity.id ?? 1.toString(), taskListEntity.tasks);
  }
}

// --- DeleteTaskUseCase ---
@lazySingleton
class DeleteTaskUseCase extends UseCase<DataState<bool>, TaskListEntity> {
  
  final TasksRepository tasksRepository;

  DeleteTaskUseCase({required this.tasksRepository});

  @override
  Future<DataState<bool>> call(TaskListEntity taskListEntity) {
    
    
    
    return tasksRepository.deletetask(
        taskListEntity.id ?? 1.toString(), taskListEntity.tasks);
  }
}

// --- UpdateTaskListUseCase ---
@lazySingleton
class UpdateTaskListUseCase extends UseCase<DataState<bool>, TaskListEntity> {
  
  final TasksRepository tasksRepository;

  UpdateTaskListUseCase({required this.tasksRepository});

  @override
  Future<DataState<bool>> call(TaskListEntity taskListEntity) {
    
    
    return tasksRepository.updatetaskList(
        taskListEntity.id ?? 1.toString(), taskListEntity.tasks);
  }
}
