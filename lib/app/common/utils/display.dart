import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const MAX_PHONE_ADAPTIVE_WIDTH = 512.0;
const MAX_TABLET_ADAPTIVE_WIDTH = 600.0;

const MAX_SHORT_SIDE_FOR_PHONE = 600.0;

Future<String> getDefaultTimeZone() => FlutterNativeTimezone.getLocalTimezone();

bool isDaylight() {
  var date = DateTime.now();

  int time = 60 * date.hour + date.minute;

  int sr = 60 * 6;
  int ss = 60 * 18;
  return sr < time && time < ss;
}

bool isDaylightLocation(Location location) {
  tz.initializeTimeZones();
  var timezoneDate = tz.TZDateTime.now(tz.getLocation(location.timezone));

  if (location.weather != null) {
    DateTime riseDate = location.weather.dailyForecast[0].sun().riseDate;
    DateTime setDate = location.weather.dailyForecast[0].sun().setDate;

    if (riseDate != null && setDate != null) {
      int time = 60 * timezoneDate.hour + timezoneDate.minute;

      int sunrise = 60 * riseDate.hour + riseDate.minute;
      int sunset = 60 * setDate.hour + setDate.minute;

      return sunrise < time && time < sunset;
    }
  }

  return location.isDaylight(timezoneDate.hour, timezoneDate.minute);
}

bool isToday(DateTime date, String timezone) {
  tz.initializeTimeZones();
  var timezoneDate = tz.TZDateTime.now(tz.getLocation(timezone));

  return date.year == timezoneDate.year
      && date.month == timezoneDate.month
      && date.day == timezoneDate.day;
}

int getCurrentTimeInMinute(String timezone) {
  tz.initializeTimeZones();
  var timezoneDate = tz.TZDateTime.now(tz.getLocation(timezone));
  return timezoneDate.hour * 60 + timezoneDate.minute;
}

DateTime getCurrentDateTime(String timezone) {
  tz.initializeTimeZones();
  return tz.TZDateTime.now(tz.getLocation(timezone));
}

bool isTwelveHourFormat(BuildContext context) {
  return !MediaQuery.of(context).alwaysUse24HourFormat;
}

String getLocationName(BuildContext context, Location location) {

  if (!isEmptyString(location.district)
      && location.district != "市辖区"
      && location.district != "无") {
    return location.district;
  } else if (!isEmptyString(location.city) && location.city != "市辖区") {
    return location.city;
  } else if (!isEmptyString(location.province)) {
    return location.province;
  } else if (location.currentPosition) {
    return S.of(context).current_location;
  } else {
    return "";
  }
}

String getWeekName(BuildContext context, int week) {
  if (week == DateTime.monday) {
    return S.of(context).week_1;
  }
  if (week == DateTime.tuesday) {
    return S.of(context).week_2;
  }
  if (week == DateTime.wednesday) {
    return S.of(context).week_3;
  }
  if (week == DateTime.thursday) {
    return S.of(context).week_4;
  }
  if (week == DateTime.friday) {
    return S.of(context).week_5;
  }
  if (week == DateTime.saturday) {
    return S.of(context).week_6;
  }
  if (week == DateTime.sunday) {
    return S.of(context).week_7;
  }
  return "...";
}

bool isLandscape(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return size.width > size.height;
}

bool isTabletDevice(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide >= MAX_SHORT_SIDE_FOR_PHONE;
}

double getTabletAdaptiveWidth(BuildContext context) {
  if (!isTabletDevice(context) && !isLandscape(context)) {
    return MediaQuery.of(context).size.width;
  }

  return isTabletDevice(context)
      ? MAX_TABLET_ADAPTIVE_WIDTH
      : MAX_SHORT_SIDE_FOR_PHONE;
}

Widget getTabletAdaptiveWidthBox(BuildContext context, Widget child) {
  return ConstrainedBox(
    constraints: BoxConstraints(
        maxWidth: getTabletAdaptiveWidth(context)
    ),
    child: child,
  );
}

double getTrendItemWidth(BuildContext context, double margin) =>
    (getTabletAdaptiveWidth(context) - margin * 2.0)
        / (isTabletDevice(context) || isLandscape(context) ? 7.0 : 5.0);

TextDirection getCurrentTextDirection(BuildContext context) =>
    intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;