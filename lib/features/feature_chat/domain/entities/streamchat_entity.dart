import 'package:equatable/equatable.dart';

class StreamchatEntity extends Equatable {
  final String? id;
  final DateTime? created;
  final String? model;
  final String? fullresponse;

  const StreamchatEntity(
      {required this.id,
      required this.created,
      required this.model,
      required this.fullresponse});

  @override
  List<Object?> get props => [id, created, model, fullresponse];
}
