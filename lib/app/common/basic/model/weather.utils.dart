import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, int> {

  const DateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

class WeatherCodeConverter implements JsonConverter<WeatherCode, int> {

  const WeatherCodeConverter();

  @override
  WeatherCode fromJson(int json) => WeatherCode.values[json];

  @override
  int toJson(WeatherCode object) => object.index;
}