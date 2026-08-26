import 'package:equatable/equatable.dart';

class ClnMgEntity extends Equatable {
  final String? id;
  String? title;
  String? desc;
  String? style;

  final String contentmessage;

  ClnMgEntity(
      {this.title,
      this.desc,
      this.style,
      required this.id,
      required this.contentmessage});

  @override
  List<Object?> get props => [id, contentmessage];
}
