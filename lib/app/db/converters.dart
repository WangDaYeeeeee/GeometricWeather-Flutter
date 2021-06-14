// @dart=2.12

import 'dart:convert';

import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/db/entities.dart';

LocationEntity locationToEntity(Location location) {
  return LocationEntity(
      location.formattedId,
      location.cityId,
      location.latitude,
      location.longitude,
      location.timezone,
      location.country,
      location.province,
      location.city,
      location.district,
      location.currentWeatherCode.index,
      location.currentSunriseDate?.millisecondsSinceEpoch ?? -1,
      location.currentSunsetDate?.millisecondsSinceEpoch ?? -1,
      location.weatherSource.key,
      location.currentPosition,
      location.residentPosition,
      location.china
  );
}

Location entityToLocation(LocationEntity entity) {
  WeatherSource? weatherSource;
  try {
    weatherSource = WeatherSource.all[entity.weatherSourceKey];
  } catch (e) {
    weatherSource = null;
  }
  if (weatherSource == null) {
    weatherSource = WeatherSource.all[WeatherSource.KEY_ACCU];
  }

  return Location(
    entity.cityId,
    entity.latitude,
    entity.longitude,
    entity.timezone,
    entity.country,
    entity.province,
    entity.city,
    entity.district,
    weatherSource!,
    entity.currentPosition,
    entity.residentPosition,
    entity.china,
    currentWeatherCode: WeatherCode.values[entity.weatherCodeIndex],
    sunriseDate: entity.sunriseTimestamp < 0
        ? null
        : DateTime.fromMillisecondsSinceEpoch(entity.sunriseTimestamp),
    sunsetDate: entity.sunsetTimestamp < 0
        ? null
        : DateTime.fromMillisecondsSinceEpoch(entity.sunsetTimestamp),
  );
}

Future<WeatherEntity> weatherToEntity(String formattedId, Weather weather) async {
  return WeatherEntity(formattedId, json.encode(weather.toJson()));
}

Future<Weather> entityToWeather(WeatherEntity entity) async {
  return Weather.fromJson(json.decode(entity.json));
}

