import 'package:ai_app/features/feature_clean_massges/data/repositories/make_clnmg_repositoryi_impl.dart';
import 'package:get_it/get_it.dart';

// --- Imports Feature: MakeTasks ---
import 'package:ai_app/features/feature_maketaks/data/datasources/api_provider.dart';
import 'package:ai_app/features/feature_maketaks/data/datasources/hive_services.dart';
import 'package:ai_app/features/feature_maketaks/data/repositories/tasks_repository_impl.dart';
import 'package:ai_app/features/feature_maketaks/data/repositories/maketaks_repository_impl.dart';
import 'package:ai_app/features/feature_maketaks/domain/repositories/tasks_repository.dart';
import 'package:ai_app/features/feature_maketaks/domain/repositories/maketaks_repository.dart';
import 'package:ai_app/features/feature_maketaks/domain/usecases/maketask_usecase.dart';
import 'package:ai_app/features/feature_maketaks/domain/usecases/task_lits_usecases.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/feature_tasks_bloc.dart';

// --- Imports Feature: Clean Messages ---
import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_hive.dart';
import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_message_api_provider.dart';
import 'package:ai_app/features/feature_clean_massges/data/repositories/clmg_list_repository_impl.dart';

import 'package:ai_app/features/feature_clean_massges/domain/repositories/clmg_list_repository.dart';
import 'package:ai_app/features/feature_clean_massges/domain/repositories/make_clnmg_repository.dart';
import 'package:ai_app/features/feature_clean_massges/domain/usecases/cln_mg_usecases.dart';
import 'package:ai_app/features/feature_clean_massges/presentation/bloc/feature_clean_massges_bloc.dart';

final locator = GetIt.instance;

void setupLocator() {
  // ==========================================================================
  // 1. DATA SOURCES
  // ==========================================================================

  // MakeTasks
  locator.registerLazySingleton<ApiProvider>(() => ApiProvider());
  locator.registerLazySingleton<HiveService>(() => HiveService());

  // Clean Messages
  locator.registerLazySingleton<ClnHive>(() => ClnHive());
  locator.registerLazySingleton<ClnMessageApiProvider>(
      () => ClnMessageApiProvider());

  // ==========================================================================
  // 2. REPOSITORIES
  // ==========================================================================

  // MakeTasks Repos
  locator.registerLazySingleton<MaketaksRepository>(
    () => MaketaksRepositoryImpl(locator<ApiProvider>()),
  );
  locator.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(locator<HiveService>()),
  );

  // Clean Messages Repos
  locator.registerLazySingleton<ClmgListRepository>(
    () => ClmgListRepositoryImpl(hive: locator<ClnHive>()),
  );
  locator.registerLazySingleton<MakeClnmgRepository>(
    () => MakeClnmgRepositoryImpl(api: locator<ClnMessageApiProvider>()),
  );

  // ==========================================================================
  // 3. USE CASES
  // ==========================================================================

  // MakeTasks UseCases
  locator.registerLazySingleton(
      () => MaketaskUsecase(locator<MaketaksRepository>()));
  locator.registerLazySingleton(
      () => FetchAllTasksUseCase(tasksRepository: locator<TasksRepository>()));
  locator.registerLazySingleton(
      () => AddTaskUseCase(tasksRepository: locator<TasksRepository>()));
  locator.registerLazySingleton(
      () => DeleteTaskUseCase(tasksRepository: locator<TasksRepository>()));
  locator.registerLazySingleton(
      () => UpdateTaskListUseCase(tasksRepository: locator<TasksRepository>()));
  locator.registerLazySingleton(
      () => SaveTaskListUseCase(tasksRepository: locator<TasksRepository>()));

  // Clean Messages UseCases
  locator
      .registerLazySingleton(() => Makeclnmg(locator<MakeClnmgRepository>()));
  locator.registerLazySingleton(
      () => GetClnMgListUseCase(locator<ClmgListRepository>()));
  locator.registerLazySingleton(
      () => SaveClnMgListUseCase(locator<ClmgListRepository>()));
  locator.registerLazySingleton(
      () => AddClnMgUseCase(locator<ClmgListRepository>()));
  locator.registerLazySingleton(
      () => DeleteClnMgUseCase(locator<ClmgListRepository>()));

  // ==========================================================================
  // 4. BLOCS (Register as Factory)
  // ==========================================================================

  // FeatureTasksBloc
  locator.registerFactory(
    () => FeatureTasksBloc(
      maketaskUsecase: locator<MaketaskUsecase>(),
      fetchAllTasksUseCase: locator<FetchAllTasksUseCase>(),
      addTaskUseCase: locator<AddTaskUseCase>(),
      deleteTaskUseCase: locator<DeleteTaskUseCase>(),
      updateTaskListUseCase: locator<UpdateTaskListUseCase>(),
      saveTaskListUseCase: locator<SaveTaskListUseCase>(),
    ),
  );

  // FeatureCleanMassgesBloc
  locator.registerFactory(
    () => FeatureCleanMassgesBloc(
      makeclnmgUseCase: locator<Makeclnmg>(),
      getClnMgListUseCase: locator<GetClnMgListUseCase>(),
      saveClnMgListUseCase: locator<SaveClnMgListUseCase>(),
      addClnMgUseCase: locator<AddClnMgUseCase>(),
      deleteClnMgUseCase: locator<DeleteClnMgUseCase>(),
    ),
  );
}
