import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class MaketaskEntity extends Equatable {
  final String? id;
  final String? model;
  final String messagecontent;
  final String? title;
  final String? desc;

  const MaketaskEntity({
    this.id,
    required this.messagecontent,
    required this.model,
    this.title,
    this.desc,
  });

  @override
  List<Object?> get props => [
        id,
        model,
        messagecontent,
      ];
}
