// @dart=2.12

import 'package:floor/floor.dart';

@entity
class LocationEntity {

  @primaryKey
  final String formattedId;

  final String cityId;

  final double latitude;
  final double longitude;

  final String timezone;

  final String country;
  final String province;
  final String city;
  final String district;

  final int weatherCodeIndex;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final String weatherSourceKey;

  final bool currentPosition;
  final bool residentPosition;
  final bool china;

  LocationEntity(
      this.formattedId,
      this.cityId,
      this.latitude,
      this.longitude,
      this.timezone,
      this.country,
      this.province,
      this.city,
      this.district,
      this.weatherCodeIndex,
      this.sunriseTimestamp,
      this.sunsetTimestamp,
      this.weatherSourceKey,
      this.currentPosition,
      this.residentPosition,
      this.china);
}

@entity
class WeatherEntity {

  @primaryKey
  final String formattedId;
  final String json;

  WeatherEntity(this.formattedId, this.json);
}

@entity
class TodayForecastRecord {

  @primaryKey
  final int dateTimeMillis;

  TodayForecastRecord(this.dateTimeMillis);
}

@entity
class TomorrowForecastRecord {

  @primaryKey
  final int dateTimeMillis;

  TomorrowForecastRecord(this.dateTimeMillis);
}