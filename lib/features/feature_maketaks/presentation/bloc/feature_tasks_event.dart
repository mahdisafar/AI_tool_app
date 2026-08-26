part of 'feature_tasks_bloc.dart';

abstract class FeatureTasksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MaketaskEvent extends FeatureTasksEvent {
  final String message;

  MaketaskEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetMtStatusEvent extends FeatureTasksEvent {}

class GetStateEvent extends FeatureTasksEvent {}

/// Requests loading all tasks for a specific list id.
class FetchAllTasksEvent extends FeatureTasksEvent {
  final String id;
  FetchAllTasksEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddTaskEvent extends FeatureTasksEvent {
  final TaskListEntity taskListEntity;
  AddTaskEvent({required this.taskListEntity});

  @override
  List<Object?> get props => [taskListEntity];
}

class DeleteTaskEvent extends FeatureTasksEvent {
  final String id;
  DeleteTaskEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateTaskListEvent extends FeatureTasksEvent {
  final TaskListEntity taskListEntity;
  UpdateTaskListEvent({required this.taskListEntity});

  @override
  List<Object?> get props => [taskListEntity];
}

class SaveTaskListEvent extends FeatureTasksEvent {
  final TaskListEntity taskListEntity;
  SaveTaskListEvent({required this.taskListEntity});

  @override
  List<Object?> get props => [taskListEntity];
}
