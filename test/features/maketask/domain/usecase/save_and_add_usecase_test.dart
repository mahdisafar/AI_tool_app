import 'package:ai_app/core/resources/data_state.dart';
import 'package:ai_app/features/feature_maketaks/data/repositories/tasks_repository_impl.dart';
import 'package:ai_app/features/feature_maketaks/domain/entities/task_list_entity.dart';
import 'package:ai_app/features/feature_maketaks/domain/usecases/task_lits_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mockrepo extends Mock implements TasksRepositoryImpl {}

void main() {
  late AddTaskUseCase addtask;
  late Mockrepo mock;
  setUp(() {
    mock = Mockrepo();
    addtask = AddTaskUseCase(tasksRepository: mock);
  });
  test("add task and load list", () async {
    when(() => mock.addtask(any(), any()))
        .thenAnswer((_) async => DataSuccess(null));
    final result = await addtask(TaskListEntity(id: 1.toString(), tasks: []));
    expect(result, isA<DataSuccess>());
    verify(() => mock.addtask(1.toString(), []));
  });
}
