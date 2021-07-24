//@dart=2.12

import 'package:geometricweather_flutter/app/common/basic/model/location.utils.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {

  final String cityId;

  final double latitude;
  final double longitude;
  final String timezone;

  final String country;
  final String province;
  final String city;
  final String district;

  @JsonKey(
      includeIfNull: true,
      fromJson: WeatherConverter.fromJson,
      toJson: WeatherConverter.toJson
  )
  final Weather? weather;
  final WeatherCode _currentWeatherCode;
  @JsonKey(includeIfNull: true)
  final DateTime? currentSunriseDate;
  @JsonKey(includeIfNull: true)
  final DateTime? currentSunsetDate;
  @JsonKey(
      fromJson: WeatherSourceConverter.fromJson,
      toJson: WeatherSourceConverter.toJson
  )
  final WeatherSource weatherSource;

  final bool currentPosition;
  final bool residentPosition;
  final bool china;

  static const NULL_ID = "NULL_ID";
  static const CURRENT_POSITION_ID = "CURRENT_POSITION";

  Location(
      this.cityId,
      this.latitude,
      this.longitude,
      this.timezone,
      this.country,
      this.province,
      this.city,
      this.district,
      this.weatherSource,
      this.currentPosition,
      this.residentPosition,
      this.china, {
        this.weather,
        WeatherCode? currentWeatherCode,
        DateTime? sunriseDate,
        DateTime? sunsetDate,
  }): this._currentWeatherCode = weather != null
      ? weather.current.weatherCode
      : (currentWeatherCode ?? WeatherCode.CLEAR),
  this.currentSunriseDate = weather != null && weather.dailyForecast.isNotEmpty 
      ? weather.dailyForecast[0].sun().riseDate
      : sunriseDate,
  this.currentSunsetDate = weather != null && weather.dailyForecast.isNotEmpty
      ? weather.dailyForecast[0].sun().setDate
      : sunsetDate;
  
  Location copyOf({
    String? cityId,
    double? latitude,
    double? longitude,
    String? timeZone,
    String? country,
    String? province,
    String? city,
    String? district,
    WeatherSource? weatherSource,
    bool? currentPosition,
    bool? residentPosition,
    bool? china,
    Weather? weather,
  }) {
    return new Location(
      cityId ?? this.cityId,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      timeZone ?? this.timezone,
      country ?? this.country,
      province ?? this.province,
      city ?? this.city,
      district ?? this.district,
      weatherSource ?? this.weatherSource,
      currentPosition ?? this.currentPosition,
      residentPosition ?? this.residentPosition,
      china ?? this.china,
      weather: weather ?? this.weather,
      currentWeatherCode: weather?.current.weatherCode ?? this.currentWeatherCode,
      sunriseDate: weather?.dailyForecast[0].sun().riseDate ?? this.currentSunriseDate,
      sunsetDate: weather?.dailyForecast[0].sun().setDate ?? this.currentSunsetDate,
    );
  }

  static Future<Location> buildLocal() async {
    return new Location(
        Location.NULL_ID,
        0, 0, await getDefaultTimeZone(),
        "", "", "", "",
        WeatherSource.all[WeatherSource.KEY_ACCU]!,
        true, false, false
    );
  }

  static Location buildDefaultLocation() {
    return new Location(
        "101924",
        39.904000, 116.391000, "Asia/Shanghai",
        "中国", "直辖市", "北京", "",
        WeatherSource.all[WeatherSource.KEY_ACCU]!,
        true, false, true
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Location && formattedId == other.formattedId;
  }

  String get formattedId => currentPosition
      ? CURRENT_POSITION_ID
      : (cityId + "&" + weatherSource.key);

  bool get usable => cityId != NULL_ID;

  @override
  String toString() {
    StringBuffer b = new StringBuffer('$country $province');
    if (province != city && !isEmptyString(city)) {
      b.write(" ");
      b.write(city);
    }
    if (city != district && !isEmptyString(district)) {
      b.write(" ");
      b.write(district);
    }
    return b.toString();
  }

  bool hasGeocodeInformation() {
    return !isEmptyString(country)
        || !isEmptyString(province)
        || !isEmptyString(city)
        || !isEmptyString(district);
  }

  WeatherCode get currentWeatherCode => weather?.current.weatherCode
      ?? _currentWeatherCode;

  static bool isEquals(String a, String b) {
    if (isEmptyString(a) && isEmptyString(b)) {
      return true;
    } else if (!isEmptyString(a) && !isEmptyString(b)) {
      return a == b;
    } else {
      return false;
    }
  }

  static List<Location> excludeInvalidResidentLocation(List<Location> list) {
    Location? currentLocation;
    for (Location l in list) {
      if (l.currentPosition) {
        currentLocation = l;
        break;
      }
    }

    List<Location> result = [];
    if (currentLocation == null) {
      result.addAll(list);
    } else {
      for (Location l in list) {
        if (l.currentPosition
            || !l.residentPosition
            || !l.isCloseTo(currentLocation)) {
          result.add(l);
        }
      }
    }
    return result;
  }

  bool isCloseTo(Location location) {
    if (cityId == location.cityId) {
      return true;
    }
    if (isEquals(province, location.province)
        && isEquals(city, location.city)) {
      return true;
    }
    return (latitude - location.latitude).abs() < 0.8
        && (longitude - location.longitude).abs() < 0.8;
  }
  
  bool isDaylight(int hours, int minutes) {
    int currentTime = hours * 60 + minutes;
    int sunriseTime = currentSunriseDate == null 
        ? 6 * 60 
        : currentSunriseDate!.hour * 60 + currentSunriseDate!.minute;
    int sunsetTime = currentSunsetDate == null
        ? 18 * 60
        : currentSunsetDate!.hour * 60 + currentSunsetDate!.minute;
    return sunriseTime <= currentTime && currentTime < sunsetTime;
  }

  @override
  int get hashCode => super.hashCode;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}