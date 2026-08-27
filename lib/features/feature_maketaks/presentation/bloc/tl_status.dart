abstract class TlStatus {}

class TlLoading extends TlStatus {}

class TlInitial extends TlStatus {}

class TlCompleted extends TlStatus {
  final dynamic data; 
  TlCompleted(this.data);
}

class TlError extends TlStatus {
  final String message;
  TlError(this.message);
}
