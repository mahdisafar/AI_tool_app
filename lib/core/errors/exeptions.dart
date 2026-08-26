class AppException implements Exception {
  final String message;
  final bool isNetworkError;

  AppException({required this.message, this.isNetworkError = false});

  @override
  String toString() => message;
}
