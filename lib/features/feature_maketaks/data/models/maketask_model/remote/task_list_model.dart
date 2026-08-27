import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/remote/maketask_model.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/task_list_entity.dart';

class TaskListModel extends TaskListEntity {
  final String? id;
  final List<MaketaskModel> tasks;
  TaskListModel({required this.id, required this.tasks})
      : super(
            id: id,
            tasks: tasks
                .map((t) => MaketaskEntity(
                      id: t.id,
                      model: t.model ??
                          "", 
                      messagecontent: (t.choices?[0] != null &&
                              t.choices!.isNotEmpty &&
                              t.choices?[0].message!.content != null)
                          ? (t.choices?[0].message!.content ?? "")
                          : "",
                    ))
                .toList());
  factory TaskListModel.fromMap(Map<String, dynamic> data) {
    return TaskListModel(id: data['id'], tasks: data['tasks']);
  }
  Map<String, dynamic> toMap() => {'id': id, 'tasks': tasks};
}
