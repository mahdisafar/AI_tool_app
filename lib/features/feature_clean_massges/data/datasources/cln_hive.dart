import 'package:ai_app/features/feature_clean_massges/data/models/local/cln_mg_list_local_model.dart';
import 'package:flutter/widgets.dart' show debugPrint;
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// @lazySingleton برای سرویس Hive Clean Messages
@lazySingleton
class ClnHive extends HiveObject {
  static const String boxName = 'Cln_lists_box';
  T? getValue<T>(String key, {String? customBoxName}) {
    final box = Hive.box<T>(customBoxName ?? boxName);
    return box.get(key);
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<ClnMgListLocalModel>(boxName);
    }
  }

  Future<void> saveOrUpdateClnmgsList(ClnMgListLocalModel mgList) async {
    final box = Hive.box<ClnMgListLocalModel>(boxName);
    debugPrint("HIVE PRE-SAVE: length is  in cln mgs ${mgList.mgs.length}");
    await box.put(mgList.id, mgList);
    debugPrint(
        "HIVE POST-SAVE: box length is in cln mgs ${box.get(mgList.id)?.mgs.length}");
  }

  ClnMgListLocalModel? getClnmgsListById(String id) {
    return getValue<ClnMgListLocalModel>(id);
  }

  Future<void> deleteClnmgsList(String id) async {
    final box = Hive.box<ClnMgListLocalModel>(boxName);
    await box.delete(id);
  }
}
