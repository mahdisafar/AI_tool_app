import 'package:ai_app/core/resources/data_state.dart';

import 'package:ai_app/features/feature_maketaks/domain/usecases/maketask_usecase.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/mt_status.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/tl_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/maketask_entity.dart';
import '../../domain/entities/task_list_entity.dart';
import '../../domain/usecases/task_lits_usecases.dart'
    show
        AddTaskUseCase,
        DeleteTaskUseCase,
        FetchAllTasksUseCase,
        SaveTaskListUseCase,
        UpdateTaskListUseCase;

part 'feature_tasks_event.dart';
part 'feature_tasks_state.dart';

// @factory برای Bloc (هر بار یک نمونه جدید بساز)
@injectable
class FeatureTasksBloc extends Bloc<FeatureTasksEvent, FeatureTasksState> {
  final MaketaskUsecase maketaskUsecase;
  final FetchAllTasksUseCase fetchAllTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskListUseCase updateTaskListUseCase;
  final SaveTaskListUseCase saveTaskListUseCase;
  FeatureTasksBloc({
    required this.saveTaskListUseCase,
    required this.maketaskUsecase,
    required this.fetchAllTasksUseCase,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskListUseCase,
  }) : super(FeatureTasksState.initial()) {
    on<ResetMtStatusEvent>((event, emit) {
      emit(state.copyWith(mtStatus: MtInitial()));
    });
    on<GetStateEvent>(
      (event, emit) {},
    );
    on<MaketaskEvent>((event, emit) async {
      emit(state.copyWith(mtStatus: MtLoading()));
      DataState dataStateM = await maketaskUsecase(event.message);
      if (dataStateM is DataSuccess) {
        debugPrint("Start Adding task...");
        final newTask = dataStateM.data;
        emit(state.copyWith(mtStatus: MtCompleted(newTask)));

        List<MaketaskEntity> currentTasks = [];
        if (state.tlStatus is TlCompleted) {
          currentTasks = List<MaketaskEntity>.from(
              (state.tlStatus as TlCompleted).data.tasks);
          debugPrint("currentTasks :length ${currentTasks.length}");
        }

        final List<MaketaskEntity> updatedTasks = [...currentTasks, newTask];
        debugPrint("updatedTasks :length ${updatedTasks.length}");
        emit(state.copyWith(tlStatus: TlLoading()));

        final addResult =
            await addTaskUseCase(TaskListEntity(id: "1", tasks: updatedTasks));

        if (addResult is DataSuccess) {
          emit(state.copyWith(
              tlStatus:
                  TlCompleted(TaskListEntity(id: "1", tasks: updatedTasks))));
        } else {
          emit(state.copyWith(tlStatus: TlError(addResult.errors ?? "خطا")));
          debugPrint("Error in TL   ${addResult.errors}");
        }
      } else {
        emit(state.copyWith(mtStatus: MtError(dataStateM.errors ?? "")));
        debugPrint("Error in mt   ${dataStateM.errors}");
      }
    });

    on<SaveTaskListEvent>((event, emit) async {
      await _handleTaskOperation(
          callUseCase: () => saveTaskListUseCase(event.taskListEntity),
          emit: emit);
    });
    on<FetchAllTasksEvent>(
      (event, emit) async {
        emit(state.copyWith(tlStatus: TlLoading()));
        DataState dataState = await fetchAllTasksUseCase(event.id);
        if (dataState is DataSuccess) {
          emit(state.copyWith(tlStatus: TlCompleted(dataState.data)));
          debugPrint("Fetch data: Tlstatus is complete ");
        } else {
          emit(state.copyWith(tlStatus: TlError(dataState.errors ?? "")));
        }
      },
    );
    on<AddTaskEvent>(
      (event, emit) async {
        emit(state.copyWith(tlStatus: TlLoading()));

        DataState dataState = await addTaskUseCase(event.taskListEntity);
        if (dataState is DataSuccess) {
          final updatedList = TaskListEntity(
            id: event.taskListEntity.id,
            tasks:
                event.taskListEntity.tasks, // لیستی که به یوزکیس فرستاده بودیم
          );
          emit(state.copyWith(tlStatus: TlCompleted(updatedList)));
        } else {
          emit(state.copyWith(
              tlStatus: TlError(dataState.errors ?? "خطا در افزودن")));
        }
      },
    );
    on<DeleteTaskEvent>((event, emit) async {
      debugPrint("Event Received! ID: ${event.id}");

      List<MaketaskEntity> currentTasks = [];
      if (state.tlStatus is TlCompleted) {
        debugPrint("Start deleting...");
        currentTasks = List<MaketaskEntity>.from(
            (state.tlStatus as TlCompleted).data.tasks);
        emit(state.copyWith(tlStatus: TlLoading()));
        debugPrint(" currentTasks :length ${currentTasks.length}");

        currentTasks.removeWhere((task) => task.id?.trim() == event.id.trim());

        final updatedList = List<MaketaskEntity>.from(currentTasks);
        debugPrint("updatedTasks :length ${updatedList.length}");

        DataState dataState = await deleteTaskUseCase(
            TaskListEntity(id: "1", tasks: updatedList));
        if (dataState is DataSuccess) {
          emit(state.copyWith(
              tlStatus:
                  TlCompleted(TaskListEntity(id: "1", tasks: updatedList))));
        } else {
          emit(state.copyWith(
              tlStatus:
                  TlError("Error in deleting a task  dataState is failed}")));
        }
      } else {
        emit(state.copyWith(
            tlStatus:
                TlError("Error in deleting a task tlStatus is not complete")));
      }
    });
    on<UpdateTaskListEvent>((event, emit) async {
      await _handleTaskOperation(
          callUseCase: () => updateTaskListUseCase(event.taskListEntity),
          emit: emit);
    });
  }
  Future<void> _handleTaskOperation<T>({
    required Future<DataState<T>> Function() callUseCase,
    required Emitter<FeatureTasksState> emit,
  }) async {
    emit(state.copyWith(tlStatus: TlLoading()));
    DataState dataState = await callUseCase();
    if (dataState is DataSuccess) {
      emit(state.copyWith(tlStatus: TlCompleted(dataState.data)));
      debugPrint("Fetch data: Tlstatus is complete ${dataState.data}");
    } else {
      emit(state.copyWith(tlStatus: TlError(dataState.errors ?? "")));
    }
  }
}
