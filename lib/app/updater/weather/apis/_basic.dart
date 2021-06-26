import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';

class WeatherUpdateResult {

  final Location data;
  final bool getGeoPositionFailed;
  final bool getWeatherFailed;
  final bool jsonDecodeFailed;

  WeatherUpdateResult(
      this.data,
      this.getGeoPositionFailed,
      this.getWeatherFailed,
      this.jsonDecodeFailed);
}

abstract class WeatherApi {

  Future<WeatherUpdateResult> requestWeather(Location location, CancelToken token);

  Future<List<Location>> requestLocations(String query, CancelToken token);
}