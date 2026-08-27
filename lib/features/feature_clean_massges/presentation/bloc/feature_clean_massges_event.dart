part of 'feature_clean_massges_bloc.dart';

abstract class FeatureCleanMassgesEvent extends Equatable {
  const FeatureCleanMassgesEvent();

  @override
  List<Object> get props => [];
}


class CreateCleanMessageEvent extends FeatureCleanMassgesEvent {
  final String rawMessage;
  const CreateCleanMessageEvent(this.rawMessage);

  @override
  List<Object> get props => [rawMessage];
}


class FetchCleanMessagesEvent extends FeatureCleanMassgesEvent {
  final String id;
  const FetchCleanMessagesEvent(this.id);

  @override
  List<Object> get props => [id];
}


class SaveCleanMessagesListEvent extends FeatureCleanMassgesEvent {
  final ClnMgListEntity cleanMgList;
  const SaveCleanMessagesListEvent(this.cleanMgList);

  @override
  List<Object> get props => [cleanMgList];
}


class DeleteCleanMessageEvent extends FeatureCleanMassgesEvent {
  final String id;
  const DeleteCleanMessageEvent(this.id);

  @override
  List<Object> get props => [id];
}


class ResetCleanMessageStatusEvent extends FeatureCleanMassgesEvent {}
