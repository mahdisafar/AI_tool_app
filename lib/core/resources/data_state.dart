abstract class DataState<T> {
  final T? data;
  final String? errors;

  DataState(this.data, this.errors);
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(T? data) : super(data, null);
}

class DataFailed<T> extends DataState<T> {
  // استفاده از dynamic یعنی هر چیزی (String، Enum، کلاس ارور) می‌تونه این‌جا قرار بگیره
  // بدون اینکه نیاز باشه تایپ جدیدی به کلاس اضافه کنی و ارور بگیری
  final dynamic errorType;

  DataFailed(String? error, {this.errorType}) : super(null, error);
}

class DataCanseled<T> extends DataState<T> {
  DataCanseled(T? data) : super(data, null);
}
