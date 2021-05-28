// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Base _$BaseFromJson(Map<String, dynamic> json) {
  return Base(
    json['cityId'] as String,
    json['timeStamp'] as int,
    DateTime.parse(json['publishDate'] as String),
    json['publishTime'] as int,
    DateTime.parse(json['updateDate'] as String),
    json['updateTime'] as int,
  );
}

Map<String, dynamic> _$BaseToJson(Base instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'timeStamp': instance.timeStamp,
      'publishDate': instance.publishDate.toIso8601String(),
      'publishTime': instance.publishTime,
      'updateDate': instance.updateDate.toIso8601String(),
      'updateTime': instance.updateTime,
    };

Temperature _$TemperatureFromJson(Map<String, dynamic> json) {
  return Temperature(
    json['temperature'] as int,
    json['realFeelTemperature'] as int?,
    json['realFeelShaderTemperature'] as int?,
    json['apparentTemperature'] as int?,
    json['windChillTemperature'] as int?,
    json['wetBulbTemperature'] as int?,
    json['degreeDayTemperature'] as int?,
  );
}

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'realFeelTemperature': instance.realFeelTemperature,
      'realFeelShaderTemperature': instance.realFeelShaderTemperature,
      'apparentTemperature': instance.apparentTemperature,
      'windChillTemperature': instance.windChillTemperature,
      'wetBulbTemperature': instance.wetBulbTemperature,
      'degreeDayTemperature': instance.degreeDayTemperature,
    };

Precipitation _$PrecipitationFromJson(Map<String, dynamic> json) {
  return Precipitation(
    (json['total'] as num?)?.toDouble(),
    (json['thunderstorm'] as num?)?.toDouble(),
    (json['rain'] as num?)?.toDouble(),
    (json['snow'] as num?)?.toDouble(),
    (json['ice'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$PrecipitationToJson(Precipitation instance) =>
    <String, dynamic>{
      'total': instance.total,
      'thunderstorm': instance.thunderstorm,
      'rain': instance.rain,
      'snow': instance.snow,
      'ice': instance.ice,
    };

PrecipitationProbability _$PrecipitationProbabilityFromJson(
    Map<String, dynamic> json) {
  return PrecipitationProbability(
    (json['total'] as num?)?.toDouble(),
    (json['thunderstorm'] as num?)?.toDouble(),
    (json['rain'] as num?)?.toDouble(),
    (json['snow'] as num?)?.toDouble(),
    (json['ice'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$PrecipitationProbabilityToJson(
        PrecipitationProbability instance) =>
    <String, dynamic>{
      'total': instance.total,
      'thunderstorm': instance.thunderstorm,
      'rain': instance.rain,
      'snow': instance.snow,
      'ice': instance.ice,
    };

PrecipitationDuration _$PrecipitationDurationFromJson(
    Map<String, dynamic> json) {
  return PrecipitationDuration(
    (json['total'] as num?)?.toDouble(),
    (json['thunderstorm'] as num?)?.toDouble(),
    (json['rain'] as num?)?.toDouble(),
    (json['snow'] as num?)?.toDouble(),
    (json['ice'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$PrecipitationDurationToJson(
        PrecipitationDuration instance) =>
    <String, dynamic>{
      'total': instance.total,
      'thunderstorm': instance.thunderstorm,
      'rain': instance.rain,
      'snow': instance.snow,
      'ice': instance.ice,
    };

WindDegree _$WindDegreeFromJson(Map<String, dynamic> json) {
  return WindDegree(
    (json['degree'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$WindDegreeToJson(WindDegree instance) =>
    <String, dynamic>{
      'degree': instance.degree,
    };

Wind _$WindFromJson(Map<String, dynamic> json) {
  return Wind(
    json['direction'] as String,
    WindDegree.fromJson(json['degree'] as Map<String, dynamic>),
    json['level'] as String,
    (json['speed'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'direction': instance.direction,
      'degree': instance.degree,
      'level': instance.level,
      'speed': instance.speed,
    };

UV _$UVFromJson(Map<String, dynamic> json) {
  return UV(
    json['index'] as int?,
    json['level'] as String?,
    json['description'] as String?,
  );
}

Map<String, dynamic> _$UVToJson(UV instance) => <String, dynamic>{
      'index': instance.index,
      'level': instance.level,
      'description': instance.description,
    };

AirQuality _$AirQualityFromJson(Map<String, dynamic> json) {
  return AirQuality(
    json['aqiText'] as String?,
    json['aqiIndex'] as int?,
    (json['pm25'] as num?)?.toDouble(),
    (json['pm10'] as num?)?.toDouble(),
    (json['so2'] as num?)?.toDouble(),
    (json['no2'] as num?)?.toDouble(),
    (json['o3'] as num?)?.toDouble(),
    (json['co'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$AirQualityToJson(AirQuality instance) =>
    <String, dynamic>{
      'aqiText': instance.aqiText,
      'aqiIndex': instance.aqiIndex,
      'pm25': instance.pm25,
      'pm10': instance.pm10,
      'so2': instance.so2,
      'no2': instance.no2,
      'o3': instance.o3,
      'co': instance.co,
    };

Current _$CurrentFromJson(Map<String, dynamic> json) {
  return Current(
    json['weatherText'] as String,
    _$enumDecode(_$WeatherCodeEnumMap, json['weatherCode']),
    Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
    Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
    PrecipitationProbability.fromJson(
        json['precipitationProbability'] as Map<String, dynamic>),
    Wind.fromJson(json['wind'] as Map<String, dynamic>),
    UV.fromJson(json['uv'] as Map<String, dynamic>),
    AirQuality.fromJson(json['airQuality'] as Map<String, dynamic>),
    (json['relativeHumidity'] as num?)?.toDouble(),
    (json['pressure'] as num?)?.toDouble(),
    (json['visibility'] as num?)?.toDouble(),
    json['dewPoint'] as int?,
    json['cloudCover'] as int?,
    (json['ceiling'] as num?)?.toDouble(),
    json['dailyForecast'] as String?,
    json['hourlyForecast'] as String?,
  );
}

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'weatherText': instance.weatherText,
      'weatherCode': _$WeatherCodeEnumMap[instance.weatherCode],
      'temperature': instance.temperature,
      'precipitation': instance.precipitation,
      'precipitationProbability': instance.precipitationProbability,
      'wind': instance.wind,
      'uv': instance.uv,
      'airQuality': instance.airQuality,
      'relativeHumidity': instance.relativeHumidity,
      'pressure': instance.pressure,
      'visibility': instance.visibility,
      'dewPoint': instance.dewPoint,
      'cloudCover': instance.cloudCover,
      'ceiling': instance.ceiling,
      'dailyForecast': instance.dailyForecast,
      'hourlyForecast': instance.hourlyForecast,
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

History _$HistoryFromJson(Map<String, dynamic> json) {
  return History(
    DateTime.parse(json['date'] as String),
    json['time'] as int,
    json['daytimeTemperature'] as int,
    json['nighttimeTemperature'] as int,
  );
}

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'daytimeTemperature': instance.daytimeTemperature,
      'nighttimeTemperature': instance.nighttimeTemperature,
    };

HalfDay _$HalfDayFromJson(Map<String, dynamic> json) {
  return HalfDay(
    json['weatherText'] as String,
    json['weatherPhase'] as String,
    _$enumDecode(_$WeatherCodeEnumMap, json['weatherCode']),
    Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
    Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
    PrecipitationProbability.fromJson(
        json['precipitationProbability'] as Map<String, dynamic>),
    PrecipitationDuration.fromJson(
        json['precipitationDuration'] as Map<String, dynamic>),
    Wind.fromJson(json['wind'] as Map<String, dynamic>),
    json['cloudCover'] as int?,
  );
}

Map<String, dynamic> _$HalfDayToJson(HalfDay instance) => <String, dynamic>{
      'weatherText': instance.weatherText,
      'weatherPhase': instance.weatherPhase,
      'weatherCode': _$WeatherCodeEnumMap[instance.weatherCode],
      'temperature': instance.temperature,
      'precipitation': instance.precipitation,
      'precipitationProbability': instance.precipitationProbability,
      'precipitationDuration': instance.precipitationDuration,
      'wind': instance.wind,
      'cloudCover': instance.cloudCover,
    };

Astro _$AstroFromJson(Map<String, dynamic> json) {
  return Astro(
    json['riseDate'] == null
        ? null
        : DateTime.parse(json['riseDate'] as String),
    json['setDate'] == null ? null : DateTime.parse(json['setDate'] as String),
  );
}

Map<String, dynamic> _$AstroToJson(Astro instance) => <String, dynamic>{
      'riseDate': instance.riseDate?.toIso8601String(),
      'setDate': instance.setDate?.toIso8601String(),
    };

MoonPhase _$MoonPhaseFromJson(Map<String, dynamic> json) {
  return MoonPhase(
    json['angle'] as int?,
    json['description'] as String?,
  );
}

Map<String, dynamic> _$MoonPhaseToJson(MoonPhase instance) => <String, dynamic>{
      'angle': instance.angle,
      'description': instance.description,
    };

Pollen _$PollenFromJson(Map<String, dynamic> json) {
  return Pollen(
    json['grassIndex'] as int?,
    json['grassLevel'] as int?,
    json['grassDescription'] as String?,
    json['moldIndex'] as int?,
    json['moldLevel'] as int?,
    json['moldDescription'] as String?,
    json['ragweedIndex'] as int?,
    json['ragweedLevel'] as int?,
    json['ragweedDescription'] as String?,
    json['treeIndex'] as int?,
    json['treeLevel'] as int?,
    json['treeDescription'] as String?,
  );
}

Map<String, dynamic> _$PollenToJson(Pollen instance) => <String, dynamic>{
      'grassIndex': instance.grassIndex,
      'grassLevel': instance.grassLevel,
      'grassDescription': instance.grassDescription,
      'moldIndex': instance.moldIndex,
      'moldLevel': instance.moldLevel,
      'moldDescription': instance.moldDescription,
      'ragweedIndex': instance.ragweedIndex,
      'ragweedLevel': instance.ragweedLevel,
      'ragweedDescription': instance.ragweedDescription,
      'treeIndex': instance.treeIndex,
      'treeLevel': instance.treeLevel,
      'treeDescription': instance.treeDescription,
    };

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
    DateTime.parse(json['date'] as String),
    json['time'] as int,
    (json['halfDays'] as List<dynamic>)
        .map((e) => HalfDay.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['astros'] as List<dynamic>)
        .map((e) => Astro.fromJson(e as Map<String, dynamic>))
        .toList(),
    MoonPhase.fromJson(json['moonPhase'] as Map<String, dynamic>),
    AirQuality.fromJson(json['airQuality'] as Map<String, dynamic>),
    Pollen.fromJson(json['pollen'] as Map<String, dynamic>),
    UV.fromJson(json['uv'] as Map<String, dynamic>),
    (json['hoursOfSun'] as num).toDouble(),
  );
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'halfDays': instance.halfDays,
      'astros': instance.astros,
      'moonPhase': instance.moonPhase,
      'airQuality': instance.airQuality,
      'pollen': instance.pollen,
      'uv': instance.uv,
      'hoursOfSun': instance.hoursOfSun,
    };

Hourly _$HourlyFromJson(Map<String, dynamic> json) {
  return Hourly(
    DateTime.parse(json['date'] as String),
    json['time'] as int,
    json['daylight'] as bool,
    json['weatherText'] as String,
    _$enumDecode(_$WeatherCodeEnumMap, json['weatherCode']),
    Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
    Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
    PrecipitationProbability.fromJson(
        json['precipitationProbability'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'daylight': instance.daylight,
      'weatherText': instance.weatherText,
      'weatherCode': _$WeatherCodeEnumMap[instance.weatherCode],
      'temperature': instance.temperature,
      'precipitation': instance.precipitation,
      'precipitationProbability': instance.precipitationProbability,
    };

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return Alert(
    json['alertId'] as int,
    DateTime.parse(json['date'] as String),
    json['time'] as int,
    json['description'] as String,
    json['content'] as String,
    json['type'] as String,
    json['priority'] as int,
    json['color'] as int,
  );
}

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
      'alertId': instance.alertId,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'description': instance.description,
      'content': instance.content,
      'type': instance.type,
      'priority': instance.priority,
      'color': instance.color,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
    Base.fromJson(json['base'] as Map<String, dynamic>),
    Current.fromJson(json['current'] as Map<String, dynamic>),
    (json['dailyForecast'] as List<dynamic>)
        .map((e) => Daily.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['hourlyForecast'] as List<dynamic>)
        .map((e) => Hourly.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['alertList'] as List<dynamic>)
        .map((e) => Alert.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['yesterday'] == null
        ? null
        : History.fromJson(json['yesterday'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'base': instance.base,
      'current': instance.current,
      'dailyForecast': instance.dailyForecast,
      'hourlyForecast': instance.hourlyForecast,
      'alertList': instance.alertList,
      'yesterday': instance.yesterday,
    };
