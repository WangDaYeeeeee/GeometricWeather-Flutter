import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/weather/apis/_basic.dart';
import 'package:geometricweather_flutter/app/weather/converters/accu_converter.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/air_quality.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/alert.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/current.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/daily.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/hourly.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/location.dart';
import 'package:geometricweather_flutter/app/weather/properties.dart';

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

String getLanguage(BuildContext context) {
  Locale locale = Localizations.localeOf(context);

  StringBuffer b = StringBuffer(locale.languageCode);
  if (!isEmpty(locale.countryCode)) {
    b.write('-');
    b.write(locale.languageCode);
  }
  return b.toString();
}

class AccuApi implements WeatherApi {

  @override
  Future<List<Location>> requestLocations(
      BuildContext context, String query, CancelToken token) async {
    List<Location> list;

    try {
      list = await _requestLocations(context, query, token);
    } on Exception catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      list = [];
    }

    return list;
  }

  Future<List<Location>> _requestLocations(
      BuildContext context, String query, CancelToken token) async {
    try {
      Dio dio = ensureDio();

      Response response = await dio.get('locations/v1/cities/translate.json',
          queryParameters: {
            'alias': 'Always',
            'apikey': ACCU_WEATHER_KEY,
            'q': query,
            'language': getLanguage(context)
          },
          cancelToken: token
      );

      String zipCode = RegExp("[a-zA-Z0-9]*").hasMatch(query) ? query : null;

      return (response.data as List<Map>)
          .map((e) => AccuLocationResult.fromJson(e))
          .toList()
          .map((e) => toLocation(e, zipCode))
          .toList();
    } on Exception catch (e, stacktrace) {
      return Future.error(e, stacktrace);
    }
  }

  @override
  Future<Weather> requestWeather(
      BuildContext context, Location location, CancelToken token) async {
    try {
      return await _requestWeather(context, location, token);
    } on Exception catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      return null;
    }
  }

  Future<Weather> _requestWeather(
      BuildContext context, Location location, CancelToken token) async {
    try {
      Dio dio = ensureDio();

      String language = getLanguage(context);

      if (location.currentPosition) {
        log('Requesting location by geo position.');
        Response response = await dio.get('locations/v1/cities/geoposition/search.json',
            queryParameters: {
              'alias': 'Always',
              'apikey': ACCU_WEATHER_KEY,
              'q': '${location.latitude},${location.longitude}',
              'language': language
            },
            cancelToken: token
        );

        if (response.data != null) {
          log('Decoding json to location.');
          AccuLocationResult result = AccuLocationResult.fromJson(response.data);
          location = toLocation(result);
        } else if (!location.isUsable()) {
          return null;
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

      log('Requesting weather data.');
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

      log('Converting request result to weather entity.');
      AccuAirQualityResult aqi;
      try {
        aqi = responses[3].data == null
            ? null
            : AccuAirQualityResult.fromJson(responses[3].data);
      } on Exception catch (e, stacktrace) {
        log(e.toString());
        log(stacktrace.toString());
        aqi = null;
      }

      return toWeather(
          context,
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
      );
    } on Exception catch (e, stacktrace) {
      return Future.error(e, stacktrace);
    }
  }
}