import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/task_list_entity.dart'; // از این Entity استفاده می‌کنیم
import '../repositories/tasks_repository.dart';
import 'package:injectable/injectable.dart';

// --- SaveTaskListUseCase ---
@lazySingleton
class SaveTaskListUseCase extends UseCase<DataState<bool>, TaskListEntity> {
  // <--- تغییر اینجا
  final TasksRepository tasksRepository;

  SaveTaskListUseCase({required this.tasksRepository});

  @override
  Future<DataState<bool>> call(TaskListEntity taskListEntity) {
    // <--- و اینجا
    if (taskListEntity.tasks.isEmpty) {
      // <--- و اینجا
      return Future.value(DataFailed("لیست نمی‌تواند خالی باشد"));
    }
    return tasksRepository.saveTaskList(taskListEntity);
  }
}

// --- FetchAllTasksUseCase (بدون تغییر، چون ورودی‌اش String بود) ---
@lazySingleton
class FetchAllTasksUseCase extends UseCase<DataState<TaskListEntity>, String> {
  final TasksRepository tasksRepository;

  FetchAllTasksUseCase({required this.tasksRepository});

  @override
  Future<DataState<TaskListEntity>> call(String id) {
    // <--- اسم پارامتر را واضح‌تر کردم
    return tasksRepository.fetchAllTasks(id);
  }
}

// --- AddTaskUseCase ---
@lazySingleton
class AddTaskUseCase
    extends UseCase<DataState<TaskListEntity>, TaskListEntity> {
  // <--- تغییر اینجا
  final TasksRepository tasksRepository;

  AddTaskUseCase({required this.tasksRepository});

  @override
  Future<DataState<TaskListEntity>> call(TaskListEntity taskListEntity) {
    // <--- و اینجا
    // اینجا متد Repository هم باید پارامترش TaskListEntity باشد
    // فرض بر این است که متد addtask در Repository اصلاح شده تا TaskListEntity را بگیرد
    return tasksRepository.addtask(
        taskListEntity.id ?? 1.toString(), taskListEntity.tasks);
  }
}

// --- DeleteTaskUseCase ---
@lazySingleton
class DeleteTaskUseCase extends UseCase<DataState<bool>, TaskListEntity> {
  // <--- تغییر اینجا
  final TasksRepository tasksRepository;

  DeleteTaskUseCase({required this.tasksRepository});

  @override
  Future<DataState<bool>> call(TaskListEntity taskListEntity) {
    // <--- و اینجا
    // فرض بر این است که متد deletetask در Repository اصلاح شده
    // و شاید به id و tasks نیاز داشته باشد
    return tasksRepository.deletetask(
        taskListEntity.id ?? 1.toString(), taskListEntity.tasks);
  }
}

// --- UpdateTaskListUseCase ---
@lazySingleton
class UpdateTaskListUseCase extends UseCase<DataState<bool>, TaskListEntity> {
  // <--- تغییر اینجا
  final TasksRepository tasksRepository;

  UpdateTaskListUseCase({required this.tasksRepository});

  @override
  Future<DataState<bool>> call(TaskListEntity taskListEntity) {
    // <--- و اینجا
    // فرض بر این است که متد updatetaskList در Repository اصلاح شده
    return tasksRepository.updatetaskList(
        taskListEntity.id ?? 1.toString(), taskListEntity.tasks);
  }
}
