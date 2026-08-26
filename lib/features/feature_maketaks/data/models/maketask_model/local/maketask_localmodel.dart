import 'package:hive/hive.dart';
import '../../../../domain/entities/maketask_entity.dart';

class MaketaskLocalModel extends MaketaskEntity {
  final String? id;
  final String? model;
  final String messagecontent;
  final String? title;
  final String? desc;

  const MaketaskLocalModel({
    required this.id,
    required this.model,
    required this.messagecontent,
    required this.title,
    required this.desc,
  }) : super(
            id: id,
            title: title,
            desc: desc,
            messagecontent: messagecontent,
            model: model);

  factory MaketaskLocalModel.fromEntity(MaketaskEntity entity) =>
      MaketaskLocalModel(
          id: entity.id,
          model: entity.model,
          messagecontent: entity.messagecontent,
          title: entity.title,
          desc: entity.desc);
}

// کلاسی که جایگزین build_runner می‌شود
class MaketaskLocalModelAdapter extends TypeAdapter<MaketaskLocalModel> {
  @override
  final int typeId = 2; // همان آیدی که قبلا دادی

  @override
  MaketaskLocalModel read(BinaryReader reader) {
    return MaketaskLocalModel(
      id: reader.read(),
      model: reader.read(),
      messagecontent: reader.read(),
      title: reader.read(),
      desc: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, MaketaskLocalModel obj) {
    writer.write(obj.id);
    writer.write(obj.model);
    writer.write(obj.messagecontent);
    writer.write(obj.title);
    writer.write(obj.desc);
  }
}
