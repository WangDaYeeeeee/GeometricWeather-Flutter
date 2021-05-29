import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';

class Location {

  final String cityId;

  final double latitude;
  final double longitude;
  final String timezone;

  final String country;
  final String province;
  final String city;
  final String district;

  final Weather weather;
  final WeatherSource weatherSource;

  final bool currentPosition;
  final bool residentPosition;
  final bool china;

  static const NULL_ID = "NULL_ID";
  static const CURRENT_POSITION_ID = "CURRENT_POSITION";

  Location(this.cityId, this.latitude, this.longitude, this.timezone,
      this.country, this.province, this.city, this.district,
      this.weatherSource, this.currentPosition, this.residentPosition,
      this.china, [this.weather]);
  
  static copyOf(Location src, {
    String cityId,
    double latitude,
    double longitude,
    String timeZone,
    String country,
    String province,
    String city,
    String district,
    WeatherSource weatherSource,
    bool currentPosition,
    bool residentPosition,
    bool china,
    Weather weather,
  }) {
    return new Location(
        cityId ?? src.cityId,
        latitude ?? src.latitude,
        longitude ?? src.longitude,
        timeZone ?? src.timezone,
        country ?? src.country,
        province ?? src.province,
        city ?? src.city,
        district ?? src.district,
        weatherSource ?? src.weatherSource,
        currentPosition ?? src.currentPosition,
        residentPosition ?? src.residentPosition,
        china ?? src.china,
        weather ?? src.weather
    );
  }

  static Location buildLocal() {
    return new Location(
        Location.NULL_ID,
        0, 0, getDefaultTimeZone(),
        "", "", "", "",
        WeatherSource.all[WeatherSource.KEY_ACCU],
        true, false, false
    );
  }

  static Location buildDefaultLocation() {
    return new Location(
        "101924",
        39.904000, 116.391000, "Asia/Shanghai",
        "中国", "直辖市", "北京", "",
        WeatherSource.all[WeatherSource.KEY_ACCU],
        false, false, true
    );
  }

  bool operator ==(Object other) {
    if (other is Location) {
      if (other == null) {
        return false;
      } else {
        // ignore: unrelated_type_equality_checks
        return this == other.getFormattedId();
      }
    }

    if (other is String) {
      if (isEmpty(other)) {
        return false;
      }
      if (CURRENT_POSITION_ID == other) {
        return currentPosition;
      }
      try {
        var keys = other.split("&");
        return !currentPosition
            && cityId == keys[0]
            && weatherSource.key == keys[1];
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  String getFormattedId() {
    return currentPosition ? CURRENT_POSITION_ID : (cityId + "&" + weatherSource.key);
  }

  bool isUsable() {
    return cityId != NULL_ID;
  }

  @override
  String toString() {
    StringBuffer b = new StringBuffer('$country $province');
    if (province != city && !isEmpty(city)) {
      b.write(" ");
      b.write(city);
    }
    if (city != district && !isEmpty(district)) {
      b.write(" ");
      b.write(district);
    }
    return b.toString();
  }

  bool hasGeocodeInformation() {
    return !isEmpty(country)
        || !isEmpty(province)
        || !isEmpty(city)
        || !isEmpty(district);
  }

  WeatherSource getWeatherSource() {
    return weatherSource;
  }

  bool isChina() {
    return china;
  }

  static bool isEquals(String a, String b) {
    if (isEmpty(a) && isEmpty(b)) {
      return true;
    } else if (!isEmpty(a) && !isEmpty(b)) {
      return a == b;
    } else {
      return false;
    }
  }

  static List<Location> excludeInvalidResidentLocation(List<Location> list) {
    Location currentLocation;
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
        if (!l.residentPosition || !l.isCloseTo(currentLocation)) {
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

  @override
  int get hashCode => super.hashCode;
}