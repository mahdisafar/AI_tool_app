part of 'feature_clean_massges_bloc.dart';

class FeatureCleanMassgesState extends Equatable {
  final ClnStatus clnStatus;
  final ClnListStatus clnListStatus;
  final List<ClnMgEntity>
      messages; 
  final String? errorMessage; 

  const FeatureCleanMassgesState({
    required this.messages,
    this.clnListStatus = ClnListStatus.initial,
    this.clnStatus = ClnStatus.initial,
    this.errorMessage,
  });

  
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
      errorMessage: errorMessage ?? this.errorMessage, 
    );
  }

  
  @override
  List<Object?> get props => [clnStatus, clnListStatus, messages, errorMessage];
}
