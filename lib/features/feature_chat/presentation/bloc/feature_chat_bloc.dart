import 'dart:async';
import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_chat/domain/use_cases/streamchat_usecase.dart';
import 'package:ai_app/features/feature_chat/presentation/bloc/active_chat_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/entities/chat_archives_entity.dart'
    show ChatArchivesEntity;
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/use_cases/chatarchives_usecase.dart';
part 'feature_chat_event.dart';
part 'feature_chat_state.dart';

@injectable
class FeatureChatBloc extends Bloc<FeatureChatEvent, ChatState> {
  final StreamchatUsecase usecase;
  final AddMessageToArchiveUsecase addMessageToArchiveUsecase;
  final CreateNewChatUsecase startChatUsecase;
  final ActiveChatCubit activeChatCubit;
  final GetChatUsecase getChatUsecase;
  StreamController<void>? _stopSignal;

  FeatureChatBloc(
      {required this.startChatUsecase,
      required this.usecase,
      required this.addMessageToArchiveUsecase,
      required this.activeChatCubit,
      required this.getChatUsecase})
      : super(const ChatState(
            messages: [], status: ChatStatus.initial, errorMessage: null)) {
    
    void prepareNewStream() {
      if (_stopSignal != null && !_stopSignal!.isClosed) {
        _stopSignal!.add(null);
        _stopSignal!.close();
      }
      _stopSignal = StreamController<void>.broadcast();
    }

    on<MessageSent>((event, emit) async {
      prepareNewStream();
      final userMessage = ChatMessageEntity(text: event.message, isUser: true);

      // Locke the ChatID in state
      emit(state.copyWith(
          messages: [userMessage, ...state.messages],
          status: ChatStatus.streamloading,
          chatId: event.chatArchives));

      // First Create a UserMessage
      await addMessageToArchiveUsecase(AddMessageParams(
          archiveId: event.chatArchives, message: userMessage));

      final placeholder = ChatMessageEntity(text: '', isUser: false);
      emit(state.copyWith(
          streamingMessage: placeholder, status: ChatStatus.streaming));

      // getting All words to combine a Full Message
      final buffer = StringBuffer();
      // Create History For AI
      final recentHistory = state.messages.take(10).toList().reversed.toList();
      await emit.forEach<DataState>(
        usecase.stream((event.message, event.image, recentHistory)).takeUntil(
            _stopSignal!.stream.first.catchError((_) => null)),
        onData: (dataState) {
          if (dataState is DataSuccess) {
            buffer.write(dataState.data);

            final updatedStreamMsg =
                placeholder.copyWith(text: buffer.toString());

            return state.copyWith(
                streamingMessage: updatedStreamMsg,
                status: ChatStatus.streaming);
          } else if (dataState is DataFailed) {
            return state.copyWith(status: ChatStatus.streamFailed);
          }
          return state;
        },
        onError: (error, stackTrace) {
          debugPrint("Stream error: $error");
          return state.copyWith(status: ChatStatus.streamFailed);
        },
      );

      if (state.status == ChatStatus.streaming) {
        final finalAiMessage = state.streamingMessage!;

        await addMessageToArchiveUsecase(AddMessageParams(
            archiveId: event.chatArchives, message: finalAiMessage));

        emit(state.copyWith(
            messages: [finalAiMessage, ...state.messages],
            clearStreamingMessage: true,
            status: ChatStatus.doneStream));
      }
    });

    
    on<Createchat>((event, emit) async {
      prepareNewStream();
      emit(state.copyWith(
          messages: [], status: ChatStatus.initial, clearChatId: true));
      String id = DateTime.now().microsecondsSinceEpoch.toString();
      final userMessage = ChatMessageEntity(text: event.message, isUser: true);

      
      emit(state.copyWith(
        messages: [userMessage],
        status: ChatStatus.streamloading,
        chatId: id,
      ));

      await startChatUsecase(
          ChatArchivesEntity(id: id, chat: <ChatMessageEntity>[userMessage]));

      
      activeChatCubit.selectChat(id);

      final placeholder = ChatMessageEntity(text: '', isUser: false);
      emit(state.copyWith(
          streamingMessage: placeholder, status: ChatStatus.streaming));

      final buffer = StringBuffer();

      await emit.forEach<DataState>(
        usecase.stream((
          event.message,
          event.image,
          <ChatMessageEntity>[]
        )).takeUntil(_stopSignal!.stream.first.catchError((_) => null)),
        onData: (dataState) {
          if (dataState is DataSuccess) {
            buffer.write(dataState.data);
            return state.copyWith(
                streamingMessage: placeholder.copyWith(text: buffer.toString()),
                status: ChatStatus.streaming);
          } else if (dataState is DataFailed) {
            return state.copyWith(status: ChatStatus.streamFailed);
          }
          return state;
        },
        onError: (error, stackTrace) {
          debugPrint("Stream error: $error");
          return state.copyWith(status: ChatStatus.streamFailed);
        },
      );

      if (state.status == ChatStatus.streaming &&
          state.streamingMessage != null) {
        final finalAiMessage = state.streamingMessage!;

        await addMessageToArchiveUsecase(
            AddMessageParams(archiveId: id, message: finalAiMessage));

        emit(state.copyWith(
            messages: [finalAiMessage, ...state.messages],
            clearStreamingMessage: true,
            status: ChatStatus.doneStream));
      }
    });

    
    on<GetMainchatsEvent>((event, emit) async {
      emit(state.copyWith(
          messages: [], status: ChatStatus.archiveLoading, chatId: event.id));

      DataState dataState = await getChatUsecase(event.id);
      if (dataState is DataSuccess) {
        if (dataState.data != null) {
          emit(state.copyWith(
            messages: dataState.data.chat.reversed.toList(),
            status: ChatStatus.succsesArchive,
            chatId: event.id, 
          ));
        } else {
          emit(state.copyWith(
              messages: [],
              status: ChatStatus.archiveFailed,
              clearChatId: true));
        }
      } else {
        emit(state.copyWith(
            messages: [], status: ChatStatus.archiveFailed, clearChatId: true));
      }
    });

    
    on<CreateNewArchive>((event, emit) async {
      emit(state.copyWith(
          messages: [], status: ChatStatus.initial, clearChatId: true));
    });

    on<StopRes>((event, emit) {
      if (_stopSignal != null && !_stopSignal!.isClosed) {
        _stopSignal!.add(null);
      }
      emit(state.copyWith(status: ChatStatus.initial));
    });

    on<ResetChatEvent>((event, emit) {
      emit(const ChatState(
          messages: [], status: ChatStatus.initial, errorMessage: null));
    });
  }

  @override
  Future<void> close() {
    _stopSignal?.close();
    return super.close();
  }
}

// ==================== FeatureAllChatArchicesBloc ====================
@injectable
class FeatureAllChatArchicesbloc
    extends Bloc<FeatureChatEvent, AllChatArchicesState> {
  final GetAllchatsUseCase getAllchatsUseCase;
  final DeleteChatUsecase deleteChatUsecase;

  FeatureAllChatArchicesbloc({
    required this.getAllchatsUseCase,
    required this.deleteChatUsecase,
  }) : super(AllChatArchicesInitial()) {
    on<DeletechatsEvent>((event, emit) async {
      final deleteResult = await deleteChatUsecase(event.id);
      if (deleteResult is DataSuccess) {
        final allChatsResult = await getAllchatsUseCase(null);
        if (allChatsResult is DataSuccess && allChatsResult.data != null) {
          emit(AllChatArchicesSuccses(allchat: allChatsResult.data!));
        } else {
          emit(AllChatArchicesFailed(err: allChatsResult.errors ?? "%Error%"));
        }
      } else {
        emit(AllChatArchicesFailed(err: deleteResult.errors ?? "%Error%"));
      }
    });

    on<GetAllchatArchives>((event, emit) async {
      emit(AllChatArchicesLoading());
      DataState state = await getAllchatsUseCase(null);
      if (state is DataSuccess) {
        emit(AllChatArchicesSuccses(allchat: state.data));
      } else {
        emit(AllChatArchicesFailed(err: state.errors ?? "%Error%"));
      }
    });
  }
}

class RefreshMainchatsEvent extends FeatureChatEvent {
  final String id;
  const RefreshMainchatsEvent({required this.id});
}
