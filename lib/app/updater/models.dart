enum UpdateStatus {
  LOCATOR_DISABLED,
  LOCATOR_PERMISSIONS_DENIED,
  LOCATOR_FAILED,
  LOCATOR_SUCCEED,

  GET_GEO_POSITION_FAILED,
  GET_WEATHER_FAILED,
  JSON_DECODE_FAILED,

  REQUEST_SUCCEED,
}

class UpdateResult<T> {

  final T data;
  final bool running;
  final UpdateStatus status;

  UpdateResult(this.data, this.running, this.status);
}

abstract class Disposable {

  void dispose();

  bool get disposed;
}

class DisposableFuture<T> {

  final Future<T> future;
  final Disposable disposable;

  DisposableFuture(this.future, this.disposable);
}