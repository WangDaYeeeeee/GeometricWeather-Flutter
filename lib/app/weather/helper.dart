import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/weather/apis/_basic.dart';
import 'package:geometricweather_flutter/app/weather/apis/accu_apis.dart';

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

  DisposableFuture<Weather> requestWeather(BuildContext context, Location location) {
    final disposable = Disposable();
    return DisposableFuture(
        _api.requestWeather(context, location, disposable._token),
        disposable
    );
  }

  DisposableFuture<List<Location>> requestLocations(BuildContext context, String query) {
    final disposable = Disposable();
    return DisposableFuture(
        _api.requestLocations(context, query, disposable._token),
        disposable
    );
  }
}