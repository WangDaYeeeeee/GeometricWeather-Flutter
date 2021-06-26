import 'package:dio/dio.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/updater/weather/apis/_basic.dart';
import 'package:geometricweather_flutter/app/updater/weather/apis/accu_apis.dart';

class Disposable {

  final CancelToken _token = CancelToken();

  void dispose() {
    _token.cancel();
  }

  bool get disposed => _token.isCancelled;
}

class DisposableFuture<T> {

  final Future<T> future;
  final Disposable disposable;

  DisposableFuture(this.future, this.disposable);
}

class WeatherHelper {

  final WeatherApi _api = AccuApi();

  DisposableFuture<WeatherUpdateResult> requestWeather(Location location) {
    final disposable = Disposable();
    return DisposableFuture(
        _api.requestWeather(location, disposable._token),
        disposable
    );
  }

  DisposableFuture<List<Location>> requestLocations(String query) {
    final disposable = Disposable();
    return DisposableFuture(
        _api.requestLocations(query, disposable._token),
        disposable
    );
  }
}