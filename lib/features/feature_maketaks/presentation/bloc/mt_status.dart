import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';

abstract class MtStatus {}

class MtLoading extends MtStatus {}

class MtInitial extends MtStatus {}

class MtCompleted extends MtStatus {
  final MaketaskEntity maketaskEntity;

  MtCompleted(this.maketaskEntity);
}

class MtError extends MtStatus {
  final String message;
  MtError(this.message);
}
