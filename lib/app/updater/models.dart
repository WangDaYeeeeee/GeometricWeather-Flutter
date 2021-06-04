enum UpdateStatus {
  LOCATOR_DISABLED,
  LOCATOR_PERMISSIONS_DENIED,
  LOCATOR_RUNNING,
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