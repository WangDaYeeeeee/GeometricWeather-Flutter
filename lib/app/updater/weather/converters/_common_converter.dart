import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

String getWindLevelString(BuildContext context, int level) {
  if (level == null || level <= 0) {
    return S.of(context).wind_0;
  } else if (level <= 1) {
    return S.of(context).wind_1;
  } else if (level <= 2) {
    return S.of(context).wind_2;
  } else if (level <= 3) {
    return S.of(context).wind_3;
  } else if (level <= 4) {
    return S.of(context).wind_4;
  } else if (level <= 5) {
    return S.of(context).wind_5;
  } else if (level <= 6) {
    return S.of(context).wind_6;
  } else if (level <= 7) {
    return S.of(context).wind_7;
  } else if (level <= 8) {
    return S.of(context).wind_8;
  } else if (level <= 9) {
    return S.of(context).wind_9;
  } else if (level <= 10) {
    return S.of(context).wind_10;
  } else if (level <= 11) {
    return S.of(context).wind_11;
  } else {
    return S.of(context).wind_12;
  }
}

int getWindLevelInt(double speed) {
  if (speed <= 0) {
    return 0;
  } else if (speed <= 1) {
    return 1;
  } else if (speed <= 2) {
    return 2;
  } else if (speed <= 3) {
    return 3;
  } else if (speed <= 4) {
    return 4;
  } else if (speed <= 5) {
    return 5;
  } else if (speed <= 6) {
    return 6;
  } else if (speed <= 7) {
    return 7;
  } else if (speed <= 8) {
    return 8;
  } else if (speed <= 9) {
    return 9;
  } else if (speed <= 10) {
    return 10;
  } else if (speed <= 11) {
    return 11;
  } else {
    return 12;
  }
}

String getAqiQualityString(BuildContext context, int aqiInt) {
  if (aqiInt == null || aqiInt < 0) {
    return '';
  } if (aqiInt <= 1) {
    return S.of(context).aqi_1;
  } else if (aqiInt <= 2) {
    return S.of(context).aqi_2;
  } else if (aqiInt <= 3) {
    return S.of(context).aqi_3;
  } else if (aqiInt <= 4) {
    return S.of(context).aqi_4;
  } else if (aqiInt <= 5) {
    return S.of(context).aqi_5;
  } else {
    return S.of(context).aqi_6;
  }
}

int getAqiQualityInt(int index) {
  if (index == null || index < 0) {
    return null;
  } if (index <= AirQuality.AQI_INDEX_1) {
    return 1;
  } else if (index <= AirQuality.AQI_INDEX_2) {
    return 2;
  } else if (index <= AirQuality.AQI_INDEX_3) {
    return 3;
  } else if (index <= AirQuality.AQI_INDEX_4) {
    return 4;
  } else if (index <= AirQuality.AQI_INDEX_5) {
    return 5;
  } else {
    return 6;
  }
}

int getMoonPhaseAngle(String phase) {
  if (isEmptyString(phase)) {
    return null;
  }
  switch (phase.toLowerCase()) {
    case "waxingcrescent":
    case "waxing crescent":
      return 45;

    case "first":
    case "firstquarter":
    case "first quarter":
      return 90;

    case "waxinggibbous":
    case "waxing gibbous":
      return 135;

    case "full":
    case "fullmoon":
    case "full moon":
      return 180;

    case "waninggibbous":
    case "waning gibbous":
      return 225;

    case "third":
    case "thirdquarter":
    case "third quarter":
    case "last":
    case "lastquarter":
    case "last quarter":
      return 270;

    case "waningcrescent":
    case "waning crescent":
      return 315;

    default:
      return 360;
  }
}

bool isDaylight(DateTime sunrise, DateTime sunset, DateTime current) =>
    sunrise.isBefore(current) && current.isBefore(sunset);

String removeTimezoneOfDateString(String date) {
  if (isEmptyString(date)) {
    return date;
  }
  return date.substring(0, date.length - 6);
}

DateTime parseNullableDateString(String formattedString) {
  if (isEmptyString(formattedString)) {
    return null;
  }
  return DateTime.parse(formattedString);
}