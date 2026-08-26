import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/local/maketask_localmodel.dart';
import 'package:hive/hive.dart';

class TaskListLocalModel extends HiveObject {
  final String id;
  final List<MaketaskLocalModel> tasks;

  TaskListLocalModel({required this.id, required this.tasks});
  TaskListLocalModel copyWith({String? id, List<MaketaskLocalModel>? tasks}) {
    return TaskListLocalModel(id: id ?? this.id, tasks: tasks ?? this.tasks);
  }
}
