import 'package:dio/dio.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/updater/models.dart';
import 'package:geometricweather_flutter/app/updater/weather/apis/_basic.dart';
import 'package:geometricweather_flutter/app/updater/weather/apis/accu_apis.dart';

class DioDisposable extends Disposable {

  final CancelToken _token = CancelToken();

  @override
  void dispose() {
    _token.cancel();
  }

  @override
  bool get disposed => _token.isCancelled;
}

class WeatherHelper {

  final WeatherApi _api = AccuApi();

  DisposableFuture<WeatherUpdateResult> requestWeather(Location location) {
    final disposable = DioDisposable();
    return DisposableFuture(
        _api.requestWeather(location, disposable._token),
        disposable
    );
  }

  DisposableFuture<List<Location>> requestLocations(String query) {
    final disposable = DioDisposable();
    return DisposableFuture(
        _api.requestLocations(query, disposable._token),
        disposable
    );
  }
}