import 'package:hive/hive.dart';
import '../local/task_list_local_model.dart';
import '../local/maketask_localmodel.dart'; 

class TaskListLocalModelAdapter extends TypeAdapter<TaskListLocalModel> {
  @override
  final int typeId = 1; 

  @override
  TaskListLocalModel read(BinaryReader reader) {
    final id =
        reader.readString(); 
    final tasksList = reader.readList(); 

    return TaskListLocalModel(
      id: id,
      tasks: tasksList.cast<MaketaskLocalModel>(), 
    );
  }

  @override
  void write(BinaryWriter writer, TaskListLocalModel obj) {
    writer.writeString(obj.id);
    writer.writeList(obj.tasks); 
  }
}
