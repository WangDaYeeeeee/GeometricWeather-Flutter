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