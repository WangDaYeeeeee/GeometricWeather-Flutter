import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';

abstract class WeatherApi {

  Future<Weather> requestWeather(
      BuildContext context, Location location, CancelToken token);

  Future<List<Location>> requestLocations(
      BuildContext context, String query, CancelToken token);
}