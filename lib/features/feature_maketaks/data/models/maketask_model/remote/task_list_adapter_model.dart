import 'package:hive/hive.dart';
import '../local/task_list_local_model.dart';
import '../local/maketask_localmodel.dart'; // حتماً این را هم ایمپورت کن

class TaskListLocalModelAdapter extends TypeAdapter<TaskListLocalModel> {
  @override
  final int typeId = 1; // مطمئن شو با typeId مدل دیگر تداخل نداشته باشد

  @override
  TaskListLocalModel read(BinaryReader reader) {
    final id =
        reader.readString(); // استفاده از متد اختصاصی برای String دقیق‌تر است
    final tasksList = reader.readList(); // لیست را می‌خوانیم

    return TaskListLocalModel(
      id: id,
      tasks: tasksList.cast<MaketaskLocalModel>(), // تبدیل نوع لیست
    );
  }

  @override
  void write(BinaryWriter writer, TaskListLocalModel obj) {
    writer.writeString(obj.id);
    writer.writeList(obj.tasks); // ذخیره لیست مدل‌ها
  }
}
