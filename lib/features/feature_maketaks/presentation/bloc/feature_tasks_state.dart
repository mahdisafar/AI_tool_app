part of 'feature_tasks_bloc.dart';

class FeatureTasksState extends Equatable {
  final MtStatus mtStatus;

  final TlStatus tlStatus;

  const FeatureTasksState({
    required this.mtStatus,
    required this.tlStatus,
  });

  factory FeatureTasksState.initial() {
    return FeatureTasksState(
      mtStatus: MtInitial(),
      tlStatus: TlInitial(),
    );
  }

  FeatureTasksState copyWith({
    MtStatus? mtStatus,
    TlStatus? tlStatus,
  }) {
    return FeatureTasksState(
      mtStatus: mtStatus ?? this.mtStatus,
      tlStatus: tlStatus ?? this.tlStatus,
    );
  }

  @override
  List<Object?> get props => [mtStatus, tlStatus];
}
