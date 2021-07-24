// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['cityId'] as String,
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    json['timezone'] as String,
    json['country'] as String,
    json['province'] as String,
    json['city'] as String,
    json['district'] as String,
    WeatherSourceConverter.fromJson(json['weatherSource'] as String),
    json['currentPosition'] as bool,
    json['residentPosition'] as bool,
    json['china'] as bool,
    weather: WeatherConverter.fromJson(json['weather'] as String),
    currentWeatherCode:
        _$enumDecodeNullable(_$WeatherCodeEnumMap, json['currentWeatherCode']),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
      'country': instance.country,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'weather': WeatherConverter.toJson(instance.weather),
      'weatherSource': WeatherSourceConverter.toJson(instance.weatherSource),
      'currentPosition': instance.currentPosition,
      'residentPosition': instance.residentPosition,
      'china': instance.china,
      'currentWeatherCode': _$WeatherCodeEnumMap[instance.currentWeatherCode],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$WeatherCodeEnumMap = {
  WeatherCode.CLEAR: 'CLEAR',
  WeatherCode.PARTLY_CLOUDY: 'PARTLY_CLOUDY',
  WeatherCode.CLOUDY: 'CLOUDY',
  WeatherCode.RAIN_S: 'RAIN_S',
  WeatherCode.RAIN_M: 'RAIN_M',
  WeatherCode.RAIN_L: 'RAIN_L',
  WeatherCode.SNOW_S: 'SNOW_S',
  WeatherCode.SNOW_M: 'SNOW_M',
  WeatherCode.SNOW_L: 'SNOW_L',
  WeatherCode.WIND: 'WIND',
  WeatherCode.FOG: 'FOG',
  WeatherCode.HAZE: 'HAZE',
  WeatherCode.SLEET: 'SLEET',
  WeatherCode.HAIL: 'HAIL',
  WeatherCode.THUNDER: 'THUNDER',
  WeatherCode.THUNDERSTORM: 'THUNDERSTORM',
};
