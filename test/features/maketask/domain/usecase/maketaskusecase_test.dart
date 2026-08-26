import 'package:ai_app/core/resources/data_state.dart';

import 'package:ai_app/features/feature_maketaks/domain/entities/maketask_entity.dart';
import 'package:ai_app/features/feature_maketaks/domain/repositories/maketaks_repository.dart';
import 'package:ai_app/features/feature_maketaks/domain/usecases/maketask_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mockrepo extends Mock implements MaketaksRepository {}

void main() {
  late MaketaskUsecase maketaskusecase;
  late Mockrepo mockRepo;

  setUp(() {
    mockRepo = Mockrepo();
    maketaskusecase = MaketaskUsecase(mockRepo);
  });
  test("test usecase", () async {
    final fakeEntityFromRepo = MaketaskEntity(
      id: "123",
      messagecontent: "TITLE: سلام\nDESCRIPTION: توضیحات تست",
      model: "gpt-3.5",
    );

    when(() => mockRepo.fetchAitask(any()))
        .thenAnswer((_) async => DataSuccess(fakeEntityFromRepo));
    final result = await maketaskusecase("hi im here");
    expect(result, isA<DataSuccess>());
    expect(result.data!.title, "سلام");
    verify(() => mockRepo.fetchAitask("hi im here")).called(1);
  });
}
