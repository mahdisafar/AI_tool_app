abstract class UseCase<T, P> {
  Future<T> call(P param);
}

abstract class StreamUseCase<T, P> {
  Stream<T> stream(P param);
}
