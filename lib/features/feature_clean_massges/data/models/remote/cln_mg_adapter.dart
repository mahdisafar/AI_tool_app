import 'package:hive/hive.dart';

import '../local/cln_mg_local_model.dart';

class ClnMgAdapter extends TypeAdapter<ClnMgLocalModel> {
  final int typeId = 4; // دقیقاً همان typeId که در مدل مشخص کردید

  @override
  ClnMgLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClnMgLocalModel(
      id: fields[0] as String,
      title: fields[1] as String,
      desc: fields[2] as String,
      contentmessage: fields[3] as String,
      selectedStyle: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClnMgLocalModel obj) {
    writer
      ..writeByte(5) // تعداد فیلدها
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.contentmessage)
      ..writeByte(4)
      ..write(obj.selectedStyle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClnMgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
