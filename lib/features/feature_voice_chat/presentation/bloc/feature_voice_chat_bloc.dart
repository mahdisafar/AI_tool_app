import 'dart:async';
import 'package:ai_app/core/resources/data_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/livekit_service.dart';
import '../../domain/usecases/live_chat_usecase.dart';

part 'feature_voice_chat_event.dart';
part 'feature_voice_chat_state.dart';

@injectable
class FeatureVoiceChatBloc
    extends Bloc<FeatureVoiceChatEvent, FeatureVoiceChatState> {
  final GetReadyLiveChatUsecase getReadyLiveChatUsecase;
  final EnableMicUseCase enableMicUseCase;
  final DisableMicUseCase disableMicUseCase;
  final DisposeEveryThingUseCase disposeEveryThingUseCase;
  final WatchVoiceSessionUseCase watchVoiceSessionUseCase;

  StreamSubscription<VoiceSessionData>? _sessionSub;

  
  VoiceSessionData? _lastSessionData;
  bool _isMicEnabled = false;

  FeatureVoiceChatBloc(
      this.getReadyLiveChatUsecase,
      this.enableMicUseCase,
      this.disableMicUseCase,
      this.disposeEveryThingUseCase,
      this.watchVoiceSessionUseCase)
      : super(VoiceChatInitialState()) {
    on<InitialVoiceChatEvent>((event, emit) async {
      emit(LoadingSessionState());
      DataState datastate = await getReadyLiveChatUsecase(null);

      if (datastate is DataSuccess) {
        DataState micState = await enableMicUseCase(null);
        if (micState is DataSuccess) {
          _isMicEnabled = true;
          add(StartWatchingSessionEvent());
        } else {
          emit(VoiceChatInitialState());
        }
      } else if (datastate is DataFailed) {
        if (datastate.errorType == ErrorType.micPerFalid) {
          emit(PermissionErrorState());
        } else if (datastate.errorType == ErrorType.sessionStartFailed) {
          emit(SessionErrorState());
        }
      }
    });

    on<StartWatchingSessionEvent>((event, emit) async {
      await _sessionSub?.cancel();
      _sessionSub = watchVoiceSessionUseCase.stream(null).listen(
            (data) => add(_InternalSessionDataUpdated(data)),
            onError: (e, s) => add(_InternalSessionError(e.toString())),
          );
    });

    on<_InternalSessionDataUpdated>((event, emit) {
      _lastSessionData = event.data; 
      emit(VoiceSessionActiveState(event.data, isMicEnabled: _isMicEnabled));
    });

    on<_InternalSessionError>((event, emit) {
      emit(OperationErrorState("خطا در دریافت وضعیت زنده: ${event.message}"));
    });

    
    on<StartTalkingEvent>((event, emit) async {
      final DataState state = await enableMicUseCase(null);
      if (state is DataSuccess) {
        _isMicEnabled = true;
        if (_lastSessionData != null) {
          emit(VoiceSessionActiveState(_lastSessionData!, isMicEnabled: true));
        }
      } else {
        emit(const OperationErrorState("خطا در فعال‌سازی میکروفون"));
      }
    });

    
    on<StopTalkingEvent>((event, emit) async {
      final DataState state = await disableMicUseCase(null);
      if (state is DataSuccess) {
        _isMicEnabled = false;
        if (_lastSessionData != null) {
          emit(VoiceSessionActiveState(_lastSessionData!, isMicEnabled: false));
        }
      } else {
        emit(const OperationErrorState("خطا در قطع میکروفون"));
      }
    });

    on<LeaveChatEvent>((event, emit) async {
      await _sessionSub?.cancel();
      await disposeEveryThingUseCase(null);
      emit(VoiceChatInitialState());
    });
  }

  @override
  Future<void> close() {
    _sessionSub?.cancel();
    return super.close();
  }
}
