import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_clean_massges/domain/entities/cln_mg_entity.dart';

import 'package:ai_app/features/feature_clean_massges/presentation/bloc/state_status.dart'
    show ClnListStatus, ClnStatus;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:injectable/injectable.dart';

import '../../domain/entities/cln_mg_list_entity.dart' show ClnMgListEntity;
import '../../domain/usecases/cln_mg_usecases.dart';

part 'feature_clean_massges_event.dart';
part 'feature_clean_massges_state.dart';

@injectable
class FeatureCleanMassgesBloc
    extends Bloc<FeatureCleanMassgesEvent, FeatureCleanMassgesState> {
  final Makeclnmg makeclnmgUseCase;
  final GetClnMgListUseCase getClnMgListUseCase;
  final SaveClnMgListUseCase saveClnMgListUseCase;
  final AddClnMgUseCase addClnMgUseCase;
  final DeleteClnMgUseCase deleteClnMgUseCase;

  FeatureCleanMassgesBloc({
    required this.makeclnmgUseCase,
    required this.getClnMgListUseCase,
    required this.saveClnMgListUseCase,
    required this.addClnMgUseCase,
    required this.deleteClnMgUseCase,
  }) : super(const FeatureCleanMassgesState(
            clnStatus: ClnStatus.initial,
            clnListStatus: ClnListStatus.initial,
            messages: [])) {
    on<ResetCleanMessageStatusEvent>(
      (event, emit) {
        emit(state.copyWith(
          clnStatus: ClnStatus.initial,
        ));
      },
    );

    // ۲. ایجاد پیام جدید
    on<CreateCleanMessageEvent>(
      (event, emit) async {
        emit(state.copyWith(clnStatus: ClnStatus.loading));
        DataState dataState = await makeclnmgUseCase(event.rawMessage);

        if (dataState is DataSuccess) {
          // گرفتن لیست فعلی و اضافه کردن پیام جدید به آن
          final currentMessages = state.messages;
          final updatedMessages = List<ClnMgEntity>.from(currentMessages)
            ..add(dataState.data);

          ClnMgListEntity clnMgListEntity =
              ClnMgListEntity(id: "1", mgs: updatedMessages);

          DataState dataListState = await addClnMgUseCase(clnMgListEntity);

          if (dataListState is DataSuccess) {
            emit(state.copyWith(
              clnStatus: ClnStatus.success,
              clnListStatus: ClnListStatus.success,
              messages: updatedMessages, // آپدیت لیست از طریق copyWith
            ));
          } else {
            emit(state.copyWith(
              clnStatus: ClnStatus.success, // چون پیام تولید شده موفقه
              clnListStatus: ClnListStatus.failure,
              errorMessage: dataListState.errors, // آپدیت خطا از طریق copyWith
            ));
          }
        } else {
          emit(state.copyWith(
            clnStatus: ClnStatus.failure,
            errorMessage: dataState.errors, // آپدیت خطا از طریق copyWith
          ));
        }
      },
    );

    // ۳. حذف پیام
    on<DeleteCleanMessageEvent>(
      (event, emit) async {
        emit(state.copyWith(clnListStatus: ClnListStatus.loading));

        // فیلتر کردن لیست پیام‌ها (حذف آیتم مورد نظر)
        final updatedList = state.messages
            .where((msg) => msg.id?.trim() != event.id.trim())
            .toList();

        DataState dataState = await deleteClnMgUseCase(
            ClnMgListEntity(id: "1", mgs: updatedList));

        if (dataState is DataSuccess) {
          emit(state.copyWith(
            clnListStatus: ClnListStatus.success,
            messages: updatedList, // جایگزینی لیست جدید فیلتر شده
          ));
        } else {
          emit(state.copyWith(
            clnListStatus: ClnListStatus.failure,
            errorMessage: dataState.errors,
          ));
        }
      },
    );

    // ۴. دریافت لیست پیام‌ها
    on<FetchCleanMessagesEvent>((event, emit) async {
      emit(state.copyWith(clnListStatus: ClnListStatus.loading));
      DataState dataState = await getClnMgListUseCase(event.id);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          clnListStatus: ClnListStatus.success,
          messages: dataState.data.mgs ??
              [], // توجه: لیست پیام‌ها از داخل فیلد mgs از کلاس ClnMgListEntity استخراج می‌شود
        ));
      } else {
        emit(state.copyWith(
          clnListStatus: ClnListStatus.failure,
          errorMessage: dataState.errors,
        ));
      }
    });
  }
}
