import 'dart:core';

import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';

class Location {

  final String cityId;

  final double latitude;
  final double longitude;
  final TimeZone timeZone;

  final String country;
  final String province;
  final String city;
  final String district;

  Weather weather;
  final WeatherSource weatherSource;

  final bool currentPosition;
  final bool residentPosition;
  final bool china;

  static const NULL_ID = "NULL_ID";
  static const CURRENT_POSITION_ID = "CURRENT_POSITION";

  Location(Location src, WeatherSource weatherSource): this(
      src.cityId, src.latitude, src.longitude, src.timeZone, src.country, src.province,
      src.city, src.district, src.weather, weatherSource, src.currentPosition,
      src.residentPosition, src.china);

  Location(
      Location src, bool currentPosition, bool residentPosition
  ): this(src.cityId, src.latitude, src.longitude, src.timeZone, src.country, src.province,
        src.city, src.district, src.weather, src.weatherSource,
        currentPosition, residentPosition, src.china);

  Location(Location src,
      double latitude, double longitude, TimeZone timeZone,
      String country, String province, String city, String district, bool china
  ): this(src.cityId, latitude, longitude, timeZone, country, province, city, district,
        src.weather, src.weatherSource, src.currentPosition, src.residentPosition, china);

  Location(
      this.cityId, this.latitude, this.longitude, this.timeZone,
      this.country, this.province, this.city, this.district,
      this.weather, this.weatherSource,
      this.currentPosition, this.residentPosition, this.china);

  static Location buildLocal() {
    return new Location(
        NULL_ID,
        0, 0, TimeZone.getDefault(),
        "", "", "", "",
        null, WeatherSource.,
        true, false, false
    );
  }

  public static Location buildDefaultLocation() {
    return new Location(
        "101924",
        39.904000f, 116.391000f, TimeZone.getTimeZone("Asia/Shanghai"),
        "中国", "直辖市", "北京", "",
        null, WeatherSource.ACCU,
        false, false, true
    );
  }

  public bool equals(@Nullable Location location) {
    if (location == null) {
      return false;
    } else {
      return equals(location.getFormattedId());
    }
  }

  public bool equals(@Nullable String formattedId) {
    if (TextUtils.isEmpty(formattedId)) {
      return false;
    }
    if (CURRENT_POSITION_ID.equals(formattedId)) {
      return isCurrentPosition();
    }
    try {
      assert formattedId != null;
      String[] keys = formattedId.split("&");
      return !isCurrentPosition()
          && cityId.equals(keys[0])
          && weatherSource.name().equals(keys[1]);
    } catch (Exception e) {
    return false;
    }
  }

  public String getFormattedId() {
    return isCurrentPosition() ? CURRENT_POSITION_ID : (cityId + "&" + weatherSource.name());
  }

  public bool isCurrentPosition() {
    return currentPosition;
  }

  public bool isResidentPosition() {
    return residentPosition;
  }

  public bool isUsable() {
    return !cityId.equals(NULL_ID);
  }

  public bool canUseChineseSource() {
    return LanguageUtils.isChinese(city) && china;
  }

  public String getCityId() {
    return cityId;
  }

  public double getLatitude() {
    return latitude;
  }

  public double getLongitude() {
    return longitude;
  }

  public TimeZone getTimeZone() {
    return timeZone;
  }

  public String getCountry() {
    return country;
  }

  public String getProvince() {
    return province;
  }

  public String getCity() {
    return city;
  }

  public String getDistrict() {
    return district;
  }

  public String getCityName(Context context) {
    if (!TextUtils.isEmpty(district) && !district.equals("市辖区") && !district.equals("无")) {
      return district;
    } else if (!TextUtils.isEmpty(city) && !city.equals("市辖区")) {
      return city;
    } else if (!TextUtils.isEmpty(province)) {
      return province;
    } else if (currentPosition) {
      return context.getString(R.string.current_location);
    } else {
      return "";
    }
  }

  @NonNull
  @Override
  public String toString() {
    StringBuilder builder = new StringBuilder(getCountry() + " " + getProvince());
    if (!getProvince().equals(getCity())
        && !TextUtils.isEmpty(getCity())) {
      builder.append(" ").append(getCity());
    }
    if (!getCity().equals(getDistrict())
        && !TextUtils.isEmpty(getDistrict())) {
      builder.append(" ").append(getDistrict());
    }
    return builder.toString();
  }

  public bool hasGeocodeInformation() {
    return !TextUtils.isEmpty(country)
        || !TextUtils.isEmpty(province)
        || !TextUtils.isEmpty(city)
        || !TextUtils.isEmpty(district);
  }

  @Nullable
  public Weather getWeather() {
    return weather;
  }

  public void setWeather(@Nullable Weather weather) {
    this.weather = weather;
  }

  WeatherSource getWeatherSource() {
    return weatherSource;
  }

  public bool isChina() {
    return china;
  }

  private static bool isEquals(@Nullable String a, @Nullable String b) {
    if (TextUtils.isEmpty(a) && TextUtils.isEmpty(b)) {
      return true;
    } else if (!TextUtils.isEmpty(a) && !TextUtils.isEmpty(b)) {
      return a.equals(b);
    } else {
      return false;
    }
  }

  public static List<Location> excludeInvalidResidentLocation(Context context, List<Location> list) {
    Location currentLocation = null;
    for (Location l : list) {
      if (l.isCurrentPosition()) {
        currentLocation = l;
        break;
      }
    }

    List<Location> result = new ArrayList<>(list.size());
    if (currentLocation == null) {
      result.addAll(list);
    } else {
      for (Location l : list) {
        if (!l.isResidentPosition() || !l.isCloseTo(context, currentLocation)) {
          result.add(l);
        }
      }
    }
    return result;
  }

  bool _isCloseTo(Context c, Location location) {
    if (cityId.equals(location.getCityId())) {
      return true;
    }
    if (isEquals(province, location.province)
        && isEquals(city, location.city)) {
      return true;
    }
    if (isEquals(province, location.province)
        && getCityName(c).equals(location.getCityName(c))) {
      return true;
    }
    return (latitude - location.latitude).abs() < 0.8
        && (longitude - location.longitude).abs() < 0.8;
  }

  bool isDaylight() {
    if (weather != null ) {
      return weather.isDaylight(getTimeZone());
    }

    return DisplayUtils.isDaylight(getTimeZone());
  }
}