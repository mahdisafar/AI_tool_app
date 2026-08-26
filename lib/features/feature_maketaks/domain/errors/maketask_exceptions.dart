class MaketaskEmptyException implements Exception {
  final String message;
  MaketaskEmptyException([this.message = "Task description cannot be empty!"]);

  @override
  String toString() => message;
}

class InvalidTaskException implements Exception {
  final String message;
  InvalidTaskException(this.message);
}
