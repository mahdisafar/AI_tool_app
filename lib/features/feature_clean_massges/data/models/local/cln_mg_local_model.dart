import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class ClnMgLocalModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String desc;
  @HiveField(3)
  final String contentmessage;
  @HiveField(4)
  final String selectedStyle;

  ClnMgLocalModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.contentmessage,
    required this.selectedStyle,
  });

  factory ClnMgLocalModel.fromEntity(ClnMgEntity entity) {
    return ClnMgLocalModel(
        id: entity.id ?? "1",
        title: entity.title ?? "error",
        contentmessage: entity.contentmessage,
        selectedStyle: entity.style ?? "error",
        desc: entity.desc ?? "error");
  }
  static ClnMgEntity toEntity(ClnMgLocalModel local) {
    return ClnMgEntity(
        style: local.selectedStyle,
        id: local.id,
        contentmessage: local.contentmessage,
        title: local.title,
        desc: local.desc);
  }
}
