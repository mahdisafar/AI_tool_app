import 'package:ai_app/features/feature_clean_massges/data/models/local/cln_mg_list_local_model.dart';
import 'package:hive/hive.dart';

import '../local/cln_mg_local_model.dart';

class ClnMgListAdapterModel extends TypeAdapter<ClnMgListLocalModel> {
  @override
  int get typeId => 5;
  @override
  ClnMgListLocalModel read(BinaryReader reader) {
    final id = reader.readString();
    final mgList = reader.readList();
    return ClnMgListLocalModel(
      id: id,
      mgs: mgList.cast<ClnMgLocalModel>(), // تبدیل نوع لیست
    );
  }

  @override
  void write(BinaryWriter writer, ClnMgListLocalModel obj) {
    writer.writeString(obj.id);
    writer.writeList(obj.mgs);
  }
}
