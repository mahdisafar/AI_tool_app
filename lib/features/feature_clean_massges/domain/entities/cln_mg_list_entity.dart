import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart'
    show ClnMgEntity;

class ClnMgListEntity {
  final String id;
  final List<ClnMgEntity> mgs;

  ClnMgListEntity({required this.id, required this.mgs});
}
