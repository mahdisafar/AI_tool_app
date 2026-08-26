import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feature_onboarding_event.dart';
part 'feature_onboarding_state.dart';

class FeatureOnboardingBloc
    extends Bloc<FeatureOnboardingEvent, FeatureOnboardingState> {
  FeatureOnboardingBloc() : super(FeatureOnboardingInitial()) {
    on<FeatureOnboardingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
