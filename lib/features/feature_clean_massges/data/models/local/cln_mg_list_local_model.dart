import 'package:hive/hive.dart';
import 'cln_mg_local_model.dart';

@HiveType(typeId: 5) // یک آیدی منحصربه‌فرد دیگر (مثلاً 4)
class ClnMgListLocalModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ClnMgLocalModel> mgs;

  ClnMgListLocalModel({required this.id, required this.mgs});
}
