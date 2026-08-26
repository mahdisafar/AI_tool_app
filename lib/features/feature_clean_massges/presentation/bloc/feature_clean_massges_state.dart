part of 'feature_clean_massges_bloc.dart';

class FeatureCleanMassgesState extends Equatable {
  final ClnStatus clnStatus;
  final ClnListStatus clnListStatus;
  final List<ClnMgEntity>
      messages; // کلمه final اضافه شد تا متغیر غیرقابل تغییر باشد
  final String? errorMessage; // کلمه final اضافه شد

  const FeatureCleanMassgesState({
    required this.messages,
    this.clnListStatus = ClnListStatus.initial,
    this.clnStatus = ClnStatus.initial,
    this.errorMessage,
  });

  // اصلاح کامل متد copyWith برای پذیرش همه فیلدها
  FeatureCleanMassgesState copyWith({
    ClnStatus? clnStatus,
    ClnListStatus? clnListStatus,
    List<ClnMgEntity>? messages,
    String? errorMessage,
  }) {
    return FeatureCleanMassgesState(
      clnListStatus: clnListStatus ?? this.clnListStatus,
      clnStatus: clnStatus ?? this.clnStatus,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage, // به درستی اضافه شد
    );
  }

  // اضافه کردن تمام فیلدها به props جهت مقایسه درست توسط Equatable
  @override
  List<Object?> get props => [clnStatus, clnListStatus, messages, errorMessage];
}
