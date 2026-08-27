import 'package:hive/hive.dart';
import 'cln_mg_local_model.dart';

@HiveType(typeId: 5) 
class ClnMgListLocalModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ClnMgLocalModel> mgs;

  ClnMgListLocalModel({required this.id, required this.mgs});
}
