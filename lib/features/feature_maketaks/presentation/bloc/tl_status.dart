abstract class TlStatus {}

class TlLoading extends TlStatus {}

class TlInitial extends TlStatus {}

class TlCompleted extends TlStatus {
  final dynamic data; // دیتای شما اینجاست!
  TlCompleted(this.data);
}

class TlError extends TlStatus {
  final String message;
  TlError(this.message);
}
