import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feature_home_event.dart';
part 'feature_home_state.dart';

class FeatureHomeBloc extends Bloc<FeatureHomeEvent, FeatureHomeState> {
  FeatureHomeBloc() : super(FeatureHomeInitial()) {
    on<FeatureHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
