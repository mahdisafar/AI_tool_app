import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/maketask_model/local/task_list_local_model.dart';

@lazySingleton
class HiveService {
  static const String boxName = 'task_lists_box';

  Future<void> openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<TaskListLocalModel>(boxName);
    }
  }

  T? getValue<T>(String key, {String? customBoxName}) {
    final box = Hive.box<T>(customBoxName ?? boxName);
    return box.get(key);
  }

  Future<void> saveOrUpdateTaskList(TaskListLocalModel taskList) async {
    final box = Hive.box<TaskListLocalModel>(boxName);
    debugPrint("HIVE PRE-SAVE: length is ${taskList.tasks.length}");
    await box.put(taskList.id, taskList);
    debugPrint(
        "HIVE POST-SAVE: box length is ${box.get(taskList.id)?.tasks.length}");
  }

  TaskListLocalModel? getTaskListById(String id) {
    return getValue<TaskListLocalModel>(id);
  }

  Future<void> deleteTaskList(String id) async {
    final box = Hive.box<TaskListLocalModel>(boxName);
    await box.delete(id);
  }
}
