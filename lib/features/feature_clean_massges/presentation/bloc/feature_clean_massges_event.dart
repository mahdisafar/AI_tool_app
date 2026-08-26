part of 'feature_clean_massges_bloc.dart';

abstract class FeatureCleanMassgesEvent extends Equatable {
  const FeatureCleanMassgesEvent();

  @override
  List<Object> get props => [];
}

/// رویداد تولید پیام جدید توسط هوش مصنوعی
class CreateCleanMessageEvent extends FeatureCleanMassgesEvent {
  final String rawMessage;
  const CreateCleanMessageEvent(this.rawMessage);

  @override
  List<Object> get props => [rawMessage];
}

/// رویداد دریافت لیست پیام‌ها از دیتابیس محلی
class FetchCleanMessagesEvent extends FeatureCleanMassgesEvent {
  final String id;
  const FetchCleanMessagesEvent(this.id);

  @override
  List<Object> get props => [id];
}

/// رویداد ذخیره یا آپدیت کل لیست
class SaveCleanMessagesListEvent extends FeatureCleanMassgesEvent {
  final ClnMgListEntity cleanMgList;
  const SaveCleanMessagesListEvent(this.cleanMgList);

  @override
  List<Object> get props => [cleanMgList];
}

/// رویداد حذف یک لیست یا بخشی از آن
class DeleteCleanMessageEvent extends FeatureCleanMassgesEvent {
  final String id;
  const DeleteCleanMessageEvent(this.id);

  @override
  List<Object> get props => [id];
}

/// اگر نیاز داشتی که وضعیت UI را به حالت اولیه برگردانی
class ResetCleanMessageStatusEvent extends FeatureCleanMassgesEvent {}
