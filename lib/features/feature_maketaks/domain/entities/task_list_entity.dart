import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:equatable/equatable.dart';

class TaskListEntity extends Equatable {
  final String? id;
  final List<MaketaskEntity> tasks;

  TaskListEntity({required this.id, required this.tasks});
  @override
  List<Object?> get props => [id, tasks];
}
