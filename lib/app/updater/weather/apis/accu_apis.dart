import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/updater/weather/converters/accu_converter.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/air_quality.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/alert.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/current.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/daily.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/hourly.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/location.dart';

import '../properties.dart';
import '_basic.dart';

Dio _dio;

Dio ensureDio() {
  if (_dio == null) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ACCU_WEATHER_BASE_URL
      )
    );
    _dio.interceptors.add(
        LogInterceptor(
            request: false,
            requestHeader: false,
            responseHeader: false,
            responseBody: true
        )
    );
  }
  return _dio;
}

String getLanguage() {
  // the local name may contains a location code.
  // for example: 'zh_Hans_US'.
  final codes = Platform.localeName.replaceAll('_', '-').split('-');
  if (codes.length > 2) {
    return '${codes[0]}-${codes[1]}';
  }

  return Platform.localeName.replaceAll('_', '-');
}

class AccuApi implements WeatherApi {

  @override
  Future<List<Location>> requestLocations(
      String query, CancelToken token) async {
    List<Location> list;

    try {
      list = await _requestLocations(query, token);
    } on Exception catch (e, stacktrace) {
      testLog(e.toString());
      testLog(stacktrace.toString());
      list = [];
    }

    return list;
  }

  Future<List<Location>> _requestLocations(
      String query, CancelToken token) async {
    try {
      Dio dio = ensureDio();

      Response response = await dio.get('locations/v1/cities/translate.json',
          queryParameters: {
            'alias': 'Always',
            'apikey': ACCU_WEATHER_KEY,
            'q': query,
            'language': getLanguage()
          },
          cancelToken: token
      );

      String zipCode = RegExp("[a-zA-Z0-9]*").hasMatch(query) ? query : null;

      return (response.data as List)
          .map((e) => AccuLocationResult.fromJson(e as Map))
          .toList()
          .map((e) => toLocation(e, null, zipCode))
          .toList();
    } on Exception catch (e, stacktrace) {
      return Future.error(e, stacktrace);
    }
  }

  @override
  Future<WeatherUpdateResult> requestWeather(
      Location location, CancelToken token) async {
    bool getGeoPositionFailed = false;

    try {
      Dio dio = ensureDio();
      String language = getLanguage();

      if (location.currentPosition) {
        testLog('Requesting location by geo position.');
        Response response = await dio.get('locations/v1/cities/geoposition/search.json',
            queryParameters: {
              'alias': 'Always',
              'apikey': ACCU_WEATHER_KEY,
              'q': '${location.latitude},${location.longitude}',
              'language': language
            },
            cancelToken: token
        );

        getGeoPositionFailed = response.data == null;
        if (response.data != null) {
          testLog('Decoding json to location.');
          AccuLocationResult result = AccuLocationResult.fromJson(response.data);
          location = toLocation(result, location);
        } else if (!location.usable) {
          testLog('Location request failed.');
          return WeatherUpdateResult(location, true, false, false);
        }
      }

      final currentParams = {
        'apikey': ACCU_CURRENT_KEY,
        'language': language,
        'details': true,
        'metric': true,
      };

      final params = {
        'apikey': ACCU_WEATHER_KEY,
        'language': language,
        'details': true,
        'metric': true,
      };

      final aqiParams = {
        'apikey': ACCU_AQI_KEY,
        'language': language,
        'details': true,
        'metric': true,
      };

      testLog('Requesting weather data.');
      List<Response> responses = await Future.wait([
        dio.get('currentconditions/v1/${location.cityId}.json',
            queryParameters: currentParams,
            cancelToken: token
        ),
        dio.get('forecasts/v1/daily/15day/${location.cityId}.json',
            queryParameters: params,
            cancelToken: token
        ),
        dio.get('forecasts/v1/hourly/24hour/${location.cityId}.json',
            queryParameters: params,
            cancelToken: token
        ),
        dio.get('airquality/v1/observations/${location.cityId}.json',
            queryParameters: aqiParams,
            cancelToken: token
        ),
        dio.get('alerts/v1/${location.cityId}.json',
            queryParameters: params,
            cancelToken: token
        )
      ]);

      testLog('Converting request result to weather entity.');
      AccuAirQualityResult aqi;
      try {
        aqi = responses[3].data == null
            ? null
            : AccuAirQualityResult.fromJson(responses[3].data);
      } on Exception catch (e, stacktrace) {
        testLog(e.toString());
        testLog(stacktrace.toString());
        aqi = null;
      }

      location = location.copyOf(
          weather: await toWeather(
              location,
              AccuCurrentResult.fromJson(responses[0].data[0]),
              AccuDailyResult.fromJson(responses[1].data),
              (responses[2].data as List)
                  .map((e) => AccuHourlyResult.fromJson(e))
                  .toList(),
              (responses[4].data as List)
                  .map((e) => AccuAlertResult.fromJson(e))
                  .toList(),
              aqi
          )
      );

      testLog('All requests and converts succeed.');
      return WeatherUpdateResult(location, getGeoPositionFailed, false, false);
    } on Exception catch (e, stacktrace) {
      testLog('Requests end with an error.');
      testLog(e.toString());
      testLog(stacktrace.toString());
      return WeatherUpdateResult(location, getGeoPositionFailed, true, false);
    }
  }
}