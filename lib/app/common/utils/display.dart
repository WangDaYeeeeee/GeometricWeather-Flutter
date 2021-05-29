import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:timezone/timezone.dart' as tz;

String getDefaultTimeZone() => DateTime.now().timeZoneName;

bool isDaylightTimezone(String timezone) {
  var timezoneDate = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));

  int time = 60 * timezoneDate.hour + timezoneDate.minute;

  int sr = 60 * 6;
  int ss = 60 * 18;
  return sr < time && time < ss;
}

bool isDaylightLocation(Location location) {
  if (location.weather != null ) {
    return isDaylightTimezone(location.timezone);
  }

  return isDaylightWeather(location.weather, location.timezone);
}

bool isDaylightWeather(Weather weather, String timezone) {
  DateTime riseDate = weather.dailyForecast[0].sun().riseDate;
  DateTime setDate = weather.dailyForecast[0].sun().setDate;

  if (riseDate != null && setDate != null) {
    var timezoneDate = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));
    int time = 60 * timezoneDate.hour + timezoneDate.minute;

    int sunrise = 60 * riseDate.hour + riseDate.minute;
    int sunset = 60 * setDate.hour + setDate.minute;

    return sunrise < time && time < sunset;
  }

  return isDaylightTimezone(timezone);
}

bool isToday(DateTime date, String timezone) {
  var timezoneDate = tz.TZDateTime.from(DateTime.now(), tz.getLocation(timezone));

  return date.year == timezoneDate.year
      && date.month == timezoneDate.month
      && date.day == timezoneDate.day;
}

String getLocationName(BuildContext context, Location location) {
  if (!isEmpty(location.district)
      && location.district != "市辖区"
      && location.district != "无") {
    return location.district;
  } else if (!isEmpty(location.city) && location.city != "市辖区") {
    return location.city;
  } else if (!isEmpty(location.province)) {
    return location.province;
  } else if (location.currentPosition) {
    return S.of(context).current_location;
  } else {
    return "";
  }
}