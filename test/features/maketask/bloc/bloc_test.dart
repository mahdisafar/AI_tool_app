import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/task_list_entity.dart';
import 'package:ai_app/features/feature_maketaks/domain/usecases/maketask_usecase.dart';
import 'package:ai_app/features/feature_maketaks/domain/usecases/task_lits_usecases.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/feature_tasks_bloc.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/mt_status.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/tl_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ۱. تعریف موک‌های مجزا (این بخش خارج از main)
class MockAddTaskUseCase extends Mock implements AddTaskUseCase {}

class MockSaveTaskListUseCase extends Mock implements SaveTaskListUseCase {}

class MockMaketaskUsecase extends Mock implements MaketaskUsecase {}

class MockFetchAllTasksUseCase extends Mock implements FetchAllTasksUseCase {}

class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

class MockUpdateTaskListUseCase extends Mock implements UpdateTaskListUseCase {}

void main() {
  // ۲. تعریف متغیرها
  late MockAddTaskUseCase mockAddTask;
  late MockSaveTaskListUseCase mockSaveTask;
  late MockMaketaskUsecase mockMakeTask;
  late MockFetchAllTasksUseCase mockFetchAll;
  late MockDeleteTaskUseCase mockDeleteTask;
  late MockUpdateTaskListUseCase mockUpdateTask;

  late FeatureTasksBloc bloc;

  setUp(() {
    // ۳. مقداردهی هر کدام به صورت مجزا
    mockAddTask = MockAddTaskUseCase();
    mockSaveTask = MockSaveTaskListUseCase();
    mockMakeTask = MockMaketaskUsecase();
    mockFetchAll = MockFetchAllTasksUseCase();
    mockDeleteTask = MockDeleteTaskUseCase();
    mockUpdateTask = MockUpdateTaskListUseCase();

    bloc = FeatureTasksBloc(
      addTaskUseCase: mockAddTask,
      saveTaskListUseCase: mockSaveTask,
      maketaskUsecase: mockMakeTask,
      fetchAllTasksUseCase: mockFetchAll,
      deleteTaskUseCase: mockDeleteTask,
      updateTaskListUseCase: mockUpdateTask,
    );
  });

  group("make task and add", () {
    tearDown(() => bloc.close());
    TaskListEntity faketaskListEntity =
        TaskListEntity(id: 1.toString(), tasks: [
      MaketaskEntity(id: "1", messagecontent: "", model: ""),
      MaketaskEntity(id: "2", messagecontent: "", model: ""),
      MaketaskEntity(id: "3", messagecontent: "", model: ""),
      MaketaskEntity(id: "4", messagecontent: "", model: "")
    ]);
    /* MaketaskEntity fakeEntity = MaketaskEntity(
      id: "123",
      messagecontent: "TITLE: سلام\nDESCRIPTION: توضیحات تست",
      model: "gpt-3.5",
    );*/

    blocTest<FeatureTasksBloc, FeatureTasksState>(
      "delete task and update list",
      build: () {
        when(
          () => mockDeleteTask(any()),
        ).thenAnswer((_) async => DataSuccess(true));
        return bloc;
      },
      seed: () => FeatureTasksState(
          mtStatus: MtInitial(), tlStatus: TlCompleted(faketaskListEntity)),
      act: (bloc) => bloc.add(DeleteTaskEvent(id: "1")),
      expect: () => [
        FeatureTasksState(
            mtStatus: MtLoading(), tlStatus: TlCompleted(faketaskListEntity)),
      ],
      verify: (_) {
        // آیا واقعاً یوزکیس صدا زده شد؟ یا بلاک الکی استیت موفقیت داد؟
        verify(() => mockMakeTask.call(any())).called(1);
      },
    );
  });
}
