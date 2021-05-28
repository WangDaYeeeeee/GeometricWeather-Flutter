// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.utils.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/common/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCode {
  CLEAR,
  PARTLY_CLOUDY,
  CLOUDY,
  RAIN_S, // small.
  RAIN_M, // medium.
  RAIN_L, // large.
  SNOW_S,
  SNOW_M,
  SNOW_L,
  WIND,
  FOG,
  HAZE,
  SLEET,
  HAIL,
  THUNDER,
  THUNDERSTORM
}

enum MoonPhaseCode {
  NEW,
  WAXING_CRESCENT,
  FIRST,
  WAXING_GIBBOUS,
  FULL,
  WANING_GIBBOUS,
  THIRD,
  WANING_CRESCENT
}

bool isPrecipitation(WeatherCode code) {
  return code == WeatherCode.RAIN_S
      || code == WeatherCode.RAIN_M
      || code == WeatherCode.RAIN_L
      || code == WeatherCode.SNOW_S
      || code == WeatherCode.SNOW_M
      || code == WeatherCode.SNOW_L
      || code == WeatherCode.SLEET
      || code == WeatherCode.HAIL
      || code == WeatherCode.THUNDERSTORM;
}

bool isRain(WeatherCode code) {
  return code == WeatherCode.RAIN_S
      || code == WeatherCode.RAIN_M
      || code == WeatherCode.RAIN_L
      || code == WeatherCode.SLEET
      || code == WeatherCode.THUNDERSTORM;
}

bool isSnow(WeatherCode code) {
  return code == WeatherCode.SNOW_S
      || code == WeatherCode.SNOW_M
      || code == WeatherCode.SNOW_L
      || code == WeatherCode.SLEET;
}

bool isIce(WeatherCode code) {
  return code == WeatherCode.HAIL;
}

@JsonSerializable()
@DateTimeConverter()
class Base {

  final String cityId;
  final int timeStamp;

  final DateTime publishDate; // device time.
  final int publishTime; // device time.

  final DateTime updateDate; // device time.
  final int updateTime; // device time.

  Base(
      this.cityId,
      this.timeStamp,
      this.publishDate,
      this.publishTime,
      this.updateDate,
      this.updateTime);

  static String getTime(DateTime date, bool twelveHour) {
    if (twelveHour) {
      return DateFormat("h:mm aa").format(date);
    } else {
      return DateFormat("HH:mm").format(date);
    }
  }

  factory Base.fromJson(Map<String, dynamic> json) => _$BaseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseToJson(this);
}

@JsonSerializable()
class Temperature {

  final int temperature;
  final int? realFeelTemperature;
  final int? realFeelShaderTemperature;
  final int? apparentTemperature;
  final int? windChillTemperature;
  final int? wetBulbTemperature;
  final int? degreeDayTemperature;

  Temperature(this.temperature, [
    this.realFeelTemperature,
    this.realFeelShaderTemperature,
    this.apparentTemperature,
    this.windChillTemperature,
    this.wetBulbTemperature,
    this.degreeDayTemperature
  ]);

  String getTemperature(BuildContext context, TemperatureUnit unit) {
    return getTemperatureString(context, temperature, unit);
  }

  String getShortTemperature(BuildContext context, TemperatureUnit unit) {
    return getShortTemperatureString(context, temperature, unit);
  }

  String getRealFeelTemperature(BuildContext context, TemperatureUnit unit) {
    return getTemperatureString(context, realFeelTemperature, unit);
  }

  String getShortRealFeeTemperature(BuildContext context, TemperatureUnit unit) {
    return getShortTemperatureString(context, realFeelTemperature, unit);
  }

  static String getTemperatureString(BuildContext context,
      int? temperature, TemperatureUnit unit) {
    if (temperature == null) {
      return '';
    }
    return unit.getValueWithUnit(context, temperature);
  }

  static String getShortTemperatureString(BuildContext context,
      int? temperature, TemperatureUnit unit) {
    if (temperature == null) {
      return '';
    }
    return unit.getValueWithShortUnit(context, temperature);
  }

  static String getTrendTemperatureString(BuildContext context,
      int? night, int? day, TemperatureUnit unit, bool dayNight) {
    if (night == null || day == null) {
      return '';
    }
    if (dayNight) {
      return getShortTemperatureString(context, day, unit)
          + "/" + getShortTemperatureString(context, night, unit);
    } else {
      return getShortTemperatureString(context, night, unit)
          + "/" + getShortTemperatureString(context, day, unit);
    }
  }

  bool isValid() {
    return realFeelTemperature != null
        || realFeelShaderTemperature != null
        || apparentTemperature != null
        || windChillTemperature != null
        || wetBulbTemperature != null
        || degreeDayTemperature != null;
  }

  factory Temperature.fromJson(Map<String, dynamic> json) => _$TemperatureFromJson(json);

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
}

@JsonSerializable()
class Precipitation {

  final double? total;
  final double? thunderstorm;
  final double? rain;
  final double? snow;
  final double? ice;

  static const PRECIPITATION_LIGHT = 10;
  static const PRECIPITATION_MIDDLE = 25;
  static const PRECIPITATION_HEAVY = 50;
  static const PRECIPITATION_RAINSTORM = 100;

  Precipitation([this.total, this.thunderstorm, this.rain, this.snow, this.ice]);

  bool isValid() {
    return total != null && total! > 0;
  }

 Color getPrecipitationColor() {
    if (total == null) {
      return ThemeColors.colorLevel1;
    } else if (total! <= PRECIPITATION_LIGHT) {
      return ThemeColors.colorLevel1;
    } else if (total! <= PRECIPITATION_MIDDLE) {
      return ThemeColors.colorLevel2;
    } else if (total! <= PRECIPITATION_HEAVY) {
      return ThemeColors.colorLevel3;
    } else if (total! <= PRECIPITATION_RAINSTORM) {
      return ThemeColors.colorLevel4;
    } else {
      return ThemeColors.colorLevel5;
    }
  }

  factory Precipitation.fromJson(Map<String, dynamic> json) => _$PrecipitationFromJson(json);

  Map<String, dynamic> toJson() => _$PrecipitationToJson(this);
}

@JsonSerializable()
class PrecipitationProbability {

  final double? total;
  final double? thunderstorm;
  final double? rain;
  final double? snow;
  final double? ice;

  PrecipitationProbability([
    this.total, this.thunderstorm, this.rain, this.snow, this.ice]);

  bool isValid() {
    return total != null && total! > 0;
  }

  factory PrecipitationProbability.fromJson(Map<String, dynamic> json) => _$PrecipitationProbabilityFromJson(json);

  Map<String, dynamic> toJson() => _$PrecipitationProbabilityToJson(this);
}

@JsonSerializable()
class PrecipitationDuration {

  final double? total;
  final double? thunderstorm;
  final double? rain;
  final double? snow;
  final double? ice;

  PrecipitationDuration([
    this.total, this.thunderstorm, this.rain, this.snow, this.ice]);

  factory PrecipitationDuration.fromJson(Map<String, dynamic> json) => _$PrecipitationDurationFromJson(json);

  Map<String, dynamic> toJson() => _$PrecipitationDurationToJson(this);
}

@JsonSerializable()
class WindDegree {

  final double? degree;
  
  WindDegree([this.degree]);

  String getWindArrow() {
    if (degree == null) {
      return '';
    } else if (22.5 < degree! && degree! <= 67.5) {
      return "↙";
    } else if (67.5 < degree! && degree! <= 112.5) {
      return "←";
    } else if (112.5 < degree! && degree! <= 157.5) {
      return "↖";
    } else if (157.5 < degree! && degree! <= 202.5) {
      return "↑";
    } else if (202.5 < degree! && degree! <= 247.5) {
      return "↗";
    } else if (247.5 < degree! && degree! <= 292.5) {
      return "→";
    } else if (292.5 < degree! && degree! <= 337.5) {
      return "↘";
    } else {
      return "↓";
    }
  }

  factory WindDegree.fromJson(Map<String, dynamic> json) => _$WindDegreeFromJson(json);

  Map<String, dynamic> toJson() => _$WindDegreeToJson(this);
}

@JsonSerializable()
class Wind {

  final String direction;
  final WindDegree degree;
  final String level;
  final double? speed;

  static const double WIND_SPEED_0 = 2;
  static const double WIND_SPEED_1 = 6;
  static const double WIND_SPEED_2 = 12;
  static const double WIND_SPEED_3 = 19;
  static const double WIND_SPEED_4 = 30;
  static const double WIND_SPEED_5 = 40;
  static const double WIND_SPEED_6 = 51;
  static const double WIND_SPEED_7 = 62;
  static const double WIND_SPEED_8 = 75;
  static const double WIND_SPEED_9 = 87;
  static const double WIND_SPEED_10 = 103;
  static const double WIND_SPEED_11 = 117;

  Wind(this.direction, this.degree, this.level, [ this.speed ]);

  Color getWindColor() {
    if (speed == null) {
      return ThemeColors.colorLevel1;
    } else if (speed! <= WIND_SPEED_3) {
      return ThemeColors.colorLevel1;
    } else if (speed! <= WIND_SPEED_5) {
      return ThemeColors.colorLevel2;
    } else if (speed! <= WIND_SPEED_7) {
      return ThemeColors.colorLevel3;
    } else if (speed! <= WIND_SPEED_9) {
      return ThemeColors.colorLevel4;
    } else if (speed! <= WIND_SPEED_11) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  String getShortWindDescription() {
    return "$direction $level";
  }

  String getWindDescription(BuildContext context, SpeedUnit unit) {
    StringBuffer b = new StringBuffer();
    b.write(direction);
    if (speed != null) {
      b.write(" ");
      b.write(unit.getValueWithUnit(context, speed));
    }
    b.write(" ");
    b.write("(");
    b.write(level);
    b.write(")");
    if (degree.degree != null) {
      b.write(" ");
      b.write(degree.getWindArrow());
    }
    return b.toString();
  }

  bool isValidSpeed() {
    return speed != null && speed! > 0;
  }

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);

  Map<String, dynamic> toJson() => _$WindToJson(this);
}

@JsonSerializable()
class UV {

  final int? index;
  final String? level;
  final String? description;

  static const int UV_INDEX_LOW = 2;
  static const int UV_INDEX_MIDDLE = 5;
  static const int UV_INDEX_HIGH = 7;
  static const int UV_INDEX_EXCESSIVE = 10;

  UV([this.index, this.level, this.description]);

  bool isValid() {
    return index != null || level != null || description != null;
  }

  bool isValidIndex() {
    return index != null;
  }

  String getUVDescription() {
    StringBuffer b = new StringBuffer();
    if (index != null) {
      b.write(index);
    }
    if (level != null) {
      b.write(isEmpty(b.toString()) ? "" : " ");
      b.write(level);
    }
    if (description != null) {
      b.write(isEmpty(b.toString()) ? "" : "\n");
      b.write(description);
    }
    return b.toString();
  }

  String getShortUVDescription() {
    StringBuffer b = new StringBuffer();
    if (index != null) {
      b.write(index);
    }
    if (level != null) {
      b.write(isEmpty(b.toString()) ? "" : " ");
      b.write(level);
    }
    return b.toString();
  }

  Color getUVColor() {
    if (index == null) {
      return ThemeColors.colorLevel1;
    } else if (index! <= UV_INDEX_LOW) {
      return ThemeColors.colorLevel1;
    } else if (index! <= UV_INDEX_MIDDLE) {
      return ThemeColors.colorLevel2;
    } else if (index! <= UV_INDEX_HIGH) {
      return ThemeColors.colorLevel3;
    } else if (index! <= UV_INDEX_EXCESSIVE) {
      return ThemeColors.colorLevel4;
    } else {
      return ThemeColors.colorLevel5;
    }
  }

  factory UV.fromJson(Map<String, dynamic> json) => _$UVFromJson(json);

  Map<String, dynamic> toJson() => _$UVToJson(this);
}

@JsonSerializable()
class AirQuality {

  final String? aqiText;
  final int? aqiIndex;
  final double? pm25;
  final double? pm10;
  final double? so2;
  final double? no2;
  final double? o3;
  final double? co;

  static const int AQI_INDEX_1 = 50;
  static const int AQI_INDEX_2 = 100;
  static const int AQI_INDEX_3 = 150;
  static const int AQI_INDEX_4 = 200;
  static const int AQI_INDEX_5 = 300;

  AirQuality([
    this.aqiText,
    this.aqiIndex,
    this.pm25,
    this.pm10,
    this.so2,
    this.no2,
    this.o3,
    this.co
  ]);

  Color getAqiColor() {
    if (aqiIndex == null) {
      return ThemeColors.colorLevel1;
    } else if (aqiIndex! <= AQI_INDEX_1) {
      return ThemeColors.colorLevel1;
    } else if (aqiIndex! <= AQI_INDEX_2) {
      return ThemeColors.colorLevel2;
    } else if (aqiIndex! <= AQI_INDEX_3) {
      return ThemeColors.colorLevel3;
    } else if (aqiIndex! <= AQI_INDEX_4) {
      return ThemeColors.colorLevel4;
    } else if (aqiIndex! <= AQI_INDEX_5) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  Color getPm25Color() {
    if (pm25 == null) {
      return Colors.transparent;
    } else if (pm25! <= 35) {
      return ThemeColors.colorLevel1;
    } else if (pm25! <= 75) {
      return ThemeColors.colorLevel2;
    } else if (pm25! <= 115) {
      return ThemeColors.colorLevel3;
    } else if (pm25! <= 150) {
      return ThemeColors.colorLevel4;
    } else if (pm25! <= 250) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  Color getPm10Color() {
    if (pm10 == null) {
      return Colors.transparent;
    } else if (pm10! <= 50) {
      return ThemeColors.colorLevel1;
    } else if (pm10! <= 150) {
      return ThemeColors.colorLevel2;
    } else if (pm10! <= 250) {
      return ThemeColors.colorLevel3;
    } else if (pm10! <= 350) {
      return ThemeColors.colorLevel4;
    } else if (pm10! <= 420) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  Color getSo2Color() {
    if (so2 == null) {
      return Colors.transparent;
    } else if (so2! <= 50) {
      return ThemeColors.colorLevel1;
    } else if (so2! <= 150) {
      return ThemeColors.colorLevel2;
    } else if (so2! <= 475) {
      return ThemeColors.colorLevel3;
    } else if (so2! <= 800) {
      return ThemeColors.colorLevel4;
    } else if (so2! <= 1600) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  Color getNo2Color() {
    if (no2 == null) {
      return Colors.transparent;
    } else if (no2! <= 40) {
      return ThemeColors.colorLevel1;
    } else if (no2! <= 80) {
      return ThemeColors.colorLevel2;
    } else if (no2! <= 180) {
      return ThemeColors.colorLevel3;
    } else if (no2! <= 280) {
      return ThemeColors.colorLevel4;
    } else if (no2! <= 565) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  Color getO3Color() {
    if (o3 == null) {
      return Colors.transparent;
    } else if (o3! <= 160) {
      return ThemeColors.colorLevel1;
    } else if (o3! <= 200) {
      return ThemeColors.colorLevel2;
    } else if (o3! <= 300) {
      return ThemeColors.colorLevel3;
    } else if (o3! <= 400) {
      return ThemeColors.colorLevel4;
    } else if (o3! <= 800) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  Color getCOColor() {
    if (co == null) {
      return Colors.transparent;
    } else if (co! <= 5) {
      return ThemeColors.colorLevel1;
    } else if (co! <= 10) {
      return ThemeColors.colorLevel2;
    } else if (co! <= 35) {
      return ThemeColors.colorLevel3;
    } else if (co! <= 60) {
      return ThemeColors.colorLevel4;
    } else if (co! <= 90) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  bool isValid() {
    return aqiIndex != null
        || aqiText != null
        || pm25 != null
        || pm10 != null
        || so2 != null
        || no2 != null
        || o3 != null
        || co != null;
  }

  bool isValidIndex() {
    return aqiIndex != null && aqiIndex! > 0;
  }

  factory AirQuality.fromJson(Map<String, dynamic> json) => _$AirQualityFromJson(json);

  Map<String, dynamic> toJson() => _$AirQualityToJson(this);
}

@JsonSerializable()
@WeatherCodeConverter()
class Current {

  final String weatherText;
  final WeatherCode weatherCode;

  final Temperature temperature;
  final Precipitation precipitation;
  final PrecipitationProbability precipitationProbability;
  final Wind wind;
  final UV uv;
  final AirQuality airQuality;

  final double? relativeHumidity;
  final double? pressure;
  final double? visibility;
  final int? dewPoint;
  final int? cloudCover;
  final double? ceiling;

  final String? dailyForecast;
  final String? hourlyForecast;

  Current(
      this.weatherText,
      this.weatherCode,
      this.temperature,
      this.precipitation,
      this.precipitationProbability,
      this.wind,
      this.uv,
      this.airQuality, [
        this.relativeHumidity,
        this.pressure,
        this.visibility,
        this.dewPoint,
        this.cloudCover,
        this.ceiling,
        this.dailyForecast,
        this.hourlyForecast
      ]);

  factory Current.fromJson(Map<String, dynamic> json) => _$CurrentFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class History {

  final DateTime date;
  final int time;

  final int daytimeTemperature;
  final int nighttimeTemperature;

  History(
      this.date, this.time, this.daytimeTemperature, this.nighttimeTemperature);

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}

@JsonSerializable()
class HalfDay {

  final String weatherText;
  final String weatherPhase;
  @WeatherCodeConverter()
  final WeatherCode weatherCode;

  final Temperature temperature;
  final Precipitation precipitation;
  final PrecipitationProbability precipitationProbability;
  final PrecipitationDuration precipitationDuration;
  final Wind wind;

  final int? cloudCover;

  HalfDay(this.weatherText, this.weatherPhase, this.weatherCode,
      this.temperature, this.precipitation, this.precipitationProbability,
      this.precipitationDuration, this.wind, [this.cloudCover]);

  factory HalfDay.fromJson(Map<String, dynamic> json) => _$HalfDayFromJson(json);

  Map<String, dynamic> toJson() => _$HalfDayToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class Astro {

  final DateTime? riseDate;
  final DateTime? setDate;

  Astro([this.riseDate, this.setDate]);

  bool isValid() {
    return riseDate != null && setDate != null;
  }

  String getRiseTime(bool twelveHour) {
    if (riseDate == null) {
      return '';
    }
    if (twelveHour) {
      return DateFormat("h:mm aa").format(riseDate!);
    } else {
      return DateFormat("HH:mm").format(riseDate!);
    }
  }

  String getSetTime(bool twelveHour) {
    if (setDate == null) {
      return '';
    }
    if (twelveHour) {
      return DateFormat("h:mm aa").format(setDate!);
    } else {
      return DateFormat("HH:mm").format(setDate!);
    }
  }

  factory Astro.fromJson(Map<String, dynamic> json) => _$AstroFromJson(json);

  Map<String, dynamic> toJson() => _$AstroToJson(this);
}

@JsonSerializable()
class MoonPhase {

  final int? angle;
  final String? description;

  MoonPhase([this.angle, this.description]);

  bool isValid() {
    return angle != null && description != null;
  }

  MoonPhaseCode getMoonPhaseCode() {
    if (isEmpty(description)) {
      return MoonPhaseCode.NEW;
    }

    switch (description!.toLowerCase()) {
      case "waxingcrescent":
      case "waxing crescent":
        return MoonPhaseCode.WAXING_CRESCENT;

      case "first":
      case "firstquarter":
      case "first quarter":
        return MoonPhaseCode.FIRST;

      case "waxinggibbous":
      case "waxing gibbous":
        return MoonPhaseCode.WAXING_GIBBOUS;

      case "full":
      case "fullmoon":
      case "full moon":
        return MoonPhaseCode.FULL;

      case "waninggibbous":
      case "waning gibbous":
        return MoonPhaseCode.WANING_GIBBOUS;

      case "third":
      case "thirdquarter":
      case "third quarter":
      case "last":
      case "lastquarter":
      case "last quarter":
        return MoonPhaseCode.THIRD;

      case "waningcrescent":
      case "waning crescent":
        return MoonPhaseCode.WANING_CRESCENT;

      default:
        return MoonPhaseCode.NEW;
    }
  }

  factory MoonPhase.fromJson(Map<String, dynamic> json) => _$MoonPhaseFromJson(json);

  Map<String, dynamic> toJson() => _$MoonPhaseToJson(this);
}

@JsonSerializable()
class Pollen {

  final int? grassIndex;
  final int? grassLevel;
  final String? grassDescription;

  final int? moldIndex;
  final int? moldLevel;
  final String? moldDescription;

  final int? ragweedIndex;
  final int? ragweedLevel;
  final String? ragweedDescription;

  final int? treeIndex;
  final int? treeLevel;
  final String? treeDescription;

  Pollen([this.grassIndex, this.grassLevel, this.grassDescription,
      this.moldIndex, this.moldLevel, this.moldDescription, this.ragweedIndex,
      this.ragweedLevel, this.ragweedDescription, this.treeIndex,
      this.treeLevel, this.treeDescription]);

  bool isValid() {
    return (grassIndex != null && grassIndex! > 0 && grassLevel != null)
        || (moldIndex != null && moldIndex! > 0 && moldLevel != null)
        || (ragweedIndex != null && ragweedIndex! > 0 && ragweedLevel != null)
        || (treeIndex != null && treeIndex! > 0 && treeLevel != null);
  }

  Color getPollenColor(int? level) {
    if (level == null) {
      return ThemeColors.colorLevel1;
    } else if (level <= 1) {
      return ThemeColors.colorLevel1;
    } else if (level <= 2) {
      return ThemeColors.colorLevel2;
    } else if (level <= 3) {
      return ThemeColors.colorLevel3;
    } else if (level <= 4) {
      return ThemeColors.colorLevel4;
    } else if (level <= 5) {
      return ThemeColors.colorLevel5;
    } else {
      return ThemeColors.colorLevel6;
    }
  }

  factory Pollen.fromJson(Map<String, dynamic> json) => _$PollenFromJson(json);

  Map<String, dynamic> toJson() => _$PollenToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class Daily {

  final DateTime date;
  final int time;

  final List<HalfDay> halfDays;
  final List<Astro> astros;
  final MoonPhase moonPhase;
  final AirQuality airQuality;
  final Pollen pollen;
  final UV uv;
  final double hoursOfSun;
  
  Daily(this.date, this.time, this.halfDays, this.astros, this.moonPhase,
      this.airQuality, this.pollen, this.uv, this.hoursOfSun);

  HalfDay day() {
    return halfDays[0];
  }

  HalfDay night() {
    return halfDays[1];
  }

  Astro sun() {
    return astros[0];
  }

  Astro moon() {
    return astros[1];
  }

  String getDate(String format) {
    return DateFormat(format).format(date);
  }

  int getWeek() => date.weekday;

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
@WeatherCodeConverter()
class Hourly {

  final DateTime date;
  final int time;
  final bool daylight;

  final String weatherText;
  final WeatherCode weatherCode;

  final Temperature temperature;
  final Precipitation precipitation;
  final PrecipitationProbability precipitationProbability;

  Hourly(
      this.date,
      this.time,
      this.daylight,
      this.weatherText,
      this.weatherCode,
      this.temperature,
      this.precipitation,
      this.precipitationProbability);

  String getHour(bool twelveHour, String ofClock) {
    int hour = DateTime.now().hour;
    if (twelveHour) {
      hour = hour + 1 - 12;
    }

    return '$hour$ofClock';
  }

  String getDate(String format) {
    return DateFormat(format).format(date);
  }

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class Alert {

  final int alertId;
  final DateTime date;
  final int time;

  final String description;
  final String content;

  final String type;
  final int priority;
  final int color;

  Alert(this.alertId, this.date, this.time, this.description, this.content,
      this.type, this.priority, this.color);

  static void deduplication(List<Alert> alertList) {
    for (int i = 0; i < alertList.length; i ++) {
      String type = alertList[i].type;
      for (int j = alertList.length - 1; j > i; j --) {
        if (alertList[j].type == type) {
          alertList.remove(j);
        }
      }
    }
  }

  static void descByTime(List<Alert> alertList) {
    Alert temp;

    for (int i = 0; i < alertList.length; i ++) {
      int maxTime = alertList[i].time;
      int maxIndex = i;
      for (int j = i + 1; j < alertList.length; j ++) {
        if (maxTime < alertList[j].time) {
          maxTime = alertList[j].time;
          maxIndex = j;
        }
      }
      if (maxIndex != i) {
        // swap.
        temp = alertList[i];
        alertList[i] = alertList[maxIndex];
        alertList[maxIndex] = temp;
      }
    }
  }

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
}

@JsonSerializable()
class Weather {

  final Base base;
  final Current current;
  final List<Daily> dailyForecast;
  final List<Hourly> hourlyForecast;
  final List<Alert> alertList;

  final History? yesterday;

  Weather(
      this.base,
      this.current,
      this.dailyForecast,
      this.hourlyForecast,
      this.alertList,
      [ this.yesterday ]);

  bool isValid(double hour) {
    int updateTime = base.updateTime;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    return currentTime >= updateTime
        && currentTime - updateTime < hour * 60 * 60 * 1000;
  }

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}