// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ai_app/features/feature_chat/data/data_source/chat_archive_hive.dart'
    as _i592;
import 'package:ai_app/features/feature_chat/data/data_source/chat_stream_api_provider.dart'
    as _i371;
import 'package:ai_app/features/feature_chat/data/repository/chat_archives_repository_impl.dart'
    as _i624;
import 'package:ai_app/features/feature_chat/data/repository/streamchat_repository_impl.dart'
    as _i1016;
import 'package:ai_app/features/feature_chat/domain/repositories/chat_archives_repository.dart'
    as _i113;
import 'package:ai_app/features/feature_chat/domain/repositories/streamchat_repository.dart'
    as _i271;
import 'package:ai_app/features/feature_chat/domain/use_cases/chatarchives_usecase.dart'
    as _i282;
import 'package:ai_app/features/feature_chat/domain/use_cases/streamchat_usecase.dart'
    as _i809;
import 'package:ai_app/features/feature_chat/presentation/bloc/active_chat_cubit.dart'
    as _i889;
import 'package:ai_app/features/feature_chat/presentation/bloc/feature_chat_bloc.dart'
    as _i427;
import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_hive.dart'
    as _i40;
import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_message_api_provider.dart'
    as _i767;
import 'package:ai_app/features/feature_clean_massges/data/repositories/clmg_list_repository_impl.dart'
    as _i512;
import 'package:ai_app/features/feature_clean_massges/data/repositories/make_clnmg_repositoryi_impl.dart'
    as _i330;
import 'package:ai_app/features/feature_clean_massges/domain/repositories/clmg_list_repository.dart'
    as _i830;
import 'package:ai_app/features/feature_clean_massges/domain/repositories/make_clnmg_repository.dart'
    as _i924;
import 'package:ai_app/features/feature_clean_massges/domain/usecases/cln_mg_usecases.dart'
    as _i905;
import 'package:ai_app/features/feature_clean_massges/presentation/bloc/feature_clean_massges_bloc.dart'
    as _i1028;
import 'package:ai_app/features/feature_maketaks/data/datasources/api_provider.dart'
    as _i831;
import 'package:ai_app/features/feature_maketaks/data/datasources/hive_services.dart'
    as _i711;
import 'package:ai_app/features/feature_maketaks/data/repositories/maketaks_repository_impl.dart'
    as _i968;
import 'package:ai_app/features/feature_maketaks/data/repositories/tasks_repository_impl.dart'
    as _i446;
import 'package:ai_app/features/feature_maketaks/domain/repositories/maketaks_repository.dart'
    as _i236;
import 'package:ai_app/features/feature_maketaks/domain/repositories/tasks_repository.dart'
    as _i61;
import 'package:ai_app/features/feature_maketaks/domain/usecases/maketask_usecase.dart'
    as _i1054;
import 'package:ai_app/features/feature_maketaks/domain/usecases/task_lits_usecases.dart'
    as _i862;
import 'package:ai_app/features/feature_maketaks/presentation/bloc/feature_tasks_bloc.dart'
    as _i417;
import 'package:ai_app/features/feature_voice_chat/data/datasources/livekit_service.dart'
    as _i498;
import 'package:ai_app/features/feature_voice_chat/data/datasources/livekit_token_service.dart'
    as _i683;
import 'package:ai_app/features/feature_voice_chat/data/datasources/permission_services.dart'
    as _i150;
import 'package:ai_app/features/feature_voice_chat/data/repositories/live_chat_implrepository.dart'
    as _i995;
import 'package:ai_app/features/feature_voice_chat/domain/repositories/live_chat_repository.dart'
    as _i61;
import 'package:ai_app/features/feature_voice_chat/domain/usecases/live_chat_usecase.dart'
    as _i874;
import 'package:ai_app/features/feature_voice_chat/presentation/bloc/feature_voice_chat_bloc.dart'
    as _i481;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i889.ActiveChatCubit>(() => _i889.ActiveChatCubit());
    gh.lazySingleton<_i592.ChatArchiveHive>(() => _i592.ChatArchiveHive());
    gh.lazySingleton<_i371.ChatStreamApiProvider>(
        () => _i371.ChatStreamApiProvider());
    gh.lazySingleton<_i40.ClnHive>(() => _i40.ClnHive());
    gh.lazySingleton<_i767.ClnMessageApiProvider>(
        () => _i767.ClnMessageApiProvider());
    gh.lazySingleton<_i831.ApiProvider>(() => _i831.ApiProvider());
    gh.lazySingleton<_i711.HiveService>(() => _i711.HiveService());
    gh.lazySingleton<_i498.LivekitService>(() => _i498.LivekitService());
    gh.lazySingleton<_i150.PermissionService>(() => _i150.PermissionService());
    gh.lazySingleton<_i683.LiveKitTokenService>(
        () => _i683.LiveKitTokenService());
    gh.lazySingleton<_i61.LiveChatRepository>(
        () => _i995.LiveChatImplRepository(
              livekit: gh<_i498.LivekitService>(),
              per: gh<_i150.PermissionService>(),
              tokenService: gh<_i683.LiveKitTokenService>(),
            ));
    gh.lazySingleton<_i113.ChatArchivesRepository>(() =>
        _i624.ChatArchivesRepositoryImpl(hive: gh<_i592.ChatArchiveHive>()));
    gh.factory<_i830.ClmgListRepository>(
        () => _i512.ClmgListRepositoryImpl(hive: gh<_i40.ClnHive>()));
    gh.factory<_i874.GetReadyLiveChatUsecase>(() =>
        _i874.GetReadyLiveChatUsecase(repo: gh<_i61.LiveChatRepository>()));
    gh.factory<_i874.EnableMicUseCase>(
        () => _i874.EnableMicUseCase(repo: gh<_i61.LiveChatRepository>()));
    gh.factory<_i874.DisableMicUseCase>(
        () => _i874.DisableMicUseCase(repo: gh<_i61.LiveChatRepository>()));
    gh.factory<_i874.DisposeEveryThingUseCase>(() =>
        _i874.DisposeEveryThingUseCase(repo: gh<_i61.LiveChatRepository>()));
    gh.factory<_i874.WatchVoiceSessionUseCase>(
        () => _i874.WatchVoiceSessionUseCase(gh<_i61.LiveChatRepository>()));
    gh.lazySingleton<_i271.Streamchatrepository>(() =>
        _i1016.StreamchatRepositoryImpl(
            chat: gh<_i371.ChatStreamApiProvider>()));
    gh.factory<_i236.MaketaksRepository>(
        () => _i968.MaketaksRepositoryImpl(gh<_i831.ApiProvider>()));
    gh.lazySingleton<_i809.StreamchatUsecase>(() => _i809.StreamchatUsecase(
        streamchatrepository: gh<_i271.Streamchatrepository>()));
    gh.factory<_i924.MakeClnmgRepository>(() =>
        _i330.MakeClnmgRepositoryImpl(api: gh<_i767.ClnMessageApiProvider>()));
    gh.factory<_i61.TasksRepository>(
        () => _i446.TasksRepositoryImpl(gh<_i711.HiveService>()));
    gh.lazySingleton<_i862.SaveTaskListUseCase>(() =>
        _i862.SaveTaskListUseCase(tasksRepository: gh<_i61.TasksRepository>()));
    gh.lazySingleton<_i862.FetchAllTasksUseCase>(() =>
        _i862.FetchAllTasksUseCase(
            tasksRepository: gh<_i61.TasksRepository>()));
    gh.lazySingleton<_i862.AddTaskUseCase>(() =>
        _i862.AddTaskUseCase(tasksRepository: gh<_i61.TasksRepository>()));
    gh.lazySingleton<_i862.DeleteTaskUseCase>(() =>
        _i862.DeleteTaskUseCase(tasksRepository: gh<_i61.TasksRepository>()));
    gh.lazySingleton<_i862.UpdateTaskListUseCase>(() =>
        _i862.UpdateTaskListUseCase(
            tasksRepository: gh<_i61.TasksRepository>()));
    gh.lazySingleton<_i1054.MaketaskUsecase>(
        () => _i1054.MaketaskUsecase(gh<_i236.MaketaksRepository>()));
    gh.factory<_i481.FeatureVoiceChatBloc>(() => _i481.FeatureVoiceChatBloc(
          gh<_i874.GetReadyLiveChatUsecase>(),
          gh<_i874.EnableMicUseCase>(),
          gh<_i874.DisableMicUseCase>(),
          gh<_i874.DisposeEveryThingUseCase>(),
          gh<_i874.WatchVoiceSessionUseCase>(),
        ));
    gh.lazySingleton<_i905.Makeclnmg>(
        () => _i905.Makeclnmg(gh<_i924.MakeClnmgRepository>()));
    gh.lazySingleton<_i905.GetClnMgListUseCase>(
        () => _i905.GetClnMgListUseCase(gh<_i830.ClmgListRepository>()));
    gh.lazySingleton<_i905.SaveClnMgListUseCase>(
        () => _i905.SaveClnMgListUseCase(gh<_i830.ClmgListRepository>()));
    gh.lazySingleton<_i905.AddClnMgUseCase>(
        () => _i905.AddClnMgUseCase(gh<_i830.ClmgListRepository>()));
    gh.lazySingleton<_i905.DeleteClnMgUseCase>(
        () => _i905.DeleteClnMgUseCase(gh<_i830.ClmgListRepository>()));
    gh.factory<_i417.FeatureTasksBloc>(() => _i417.FeatureTasksBloc(
          saveTaskListUseCase: gh<_i862.SaveTaskListUseCase>(),
          maketaskUsecase: gh<_i1054.MaketaskUsecase>(),
          fetchAllTasksUseCase: gh<_i862.FetchAllTasksUseCase>(),
          addTaskUseCase: gh<_i862.AddTaskUseCase>(),
          deleteTaskUseCase: gh<_i862.DeleteTaskUseCase>(),
          updateTaskListUseCase: gh<_i862.UpdateTaskListUseCase>(),
        ));
    gh.factory<_i282.CreateNewChatUsecase>(() =>
        _i282.CreateNewChatUsecase(repo: gh<_i113.ChatArchivesRepository>()));
    gh.factory<_i282.GetChatUsecase>(
        () => _i282.GetChatUsecase(repo: gh<_i113.ChatArchivesRepository>()));
    gh.factory<_i282.DeleteChatUsecase>(() =>
        _i282.DeleteChatUsecase(repo: gh<_i113.ChatArchivesRepository>()));
    gh.factory<_i282.GetAllchatsUseCase>(() =>
        _i282.GetAllchatsUseCase(repo: gh<_i113.ChatArchivesRepository>()));
    gh.factory<_i282.AddMessageToArchiveUsecase>(() =>
        _i282.AddMessageToArchiveUsecase(
            repo: gh<_i113.ChatArchivesRepository>()));
    gh.factory<_i427.FeatureAllChatArchicesbloc>(
        () => _i427.FeatureAllChatArchicesbloc(
              getAllchatsUseCase: gh<_i282.GetAllchatsUseCase>(),
              deleteChatUsecase: gh<_i282.DeleteChatUsecase>(),
            ));
    gh.factory<_i1028.FeatureCleanMassgesBloc>(
        () => _i1028.FeatureCleanMassgesBloc(
              makeclnmgUseCase: gh<_i905.Makeclnmg>(),
              getClnMgListUseCase: gh<_i905.GetClnMgListUseCase>(),
              saveClnMgListUseCase: gh<_i905.SaveClnMgListUseCase>(),
              addClnMgUseCase: gh<_i905.AddClnMgUseCase>(),
              deleteClnMgUseCase: gh<_i905.DeleteClnMgUseCase>(),
            ));
    gh.factory<_i427.FeatureChatBloc>(() => _i427.FeatureChatBloc(
          startChatUsecase: gh<_i282.CreateNewChatUsecase>(),
          usecase: gh<_i809.StreamchatUsecase>(),
          addMessageToArchiveUsecase: gh<_i282.AddMessageToArchiveUsecase>(),
          activeChatCubit: gh<_i889.ActiveChatCubit>(),
          getChatUsecase: gh<_i282.GetChatUsecase>(),
        ));
    return this;
  }
}
