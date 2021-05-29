import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

String getWindLevel(BuildContext context, double speed) {
  if (speed <= Wind.WIND_SPEED_0) {
    return S.of(context).wind_0;
  } else if (speed <= Wind.WIND_SPEED_1) {
    return S.of(context).wind_1;
  } else if (speed <= Wind.WIND_SPEED_2) {
    return S.of(context).wind_2;
  } else if (speed <= Wind.WIND_SPEED_3) {
    return S.of(context).wind_3;
  } else if (speed <= Wind.WIND_SPEED_4) {
    return S.of(context).wind_4;
  } else if (speed <= Wind.WIND_SPEED_5) {
    return S.of(context).wind_5;
  } else if (speed <= Wind.WIND_SPEED_6) {
    return S.of(context).wind_6;
  } else if (speed <= Wind.WIND_SPEED_7) {
    return S.of(context).wind_7;
  } else if (speed <= Wind.WIND_SPEED_8) {
    return S.of(context).wind_8;
  } else if (speed <= Wind.WIND_SPEED_9) {
    return S.of(context).wind_9;
  } else if (speed <= Wind.WIND_SPEED_10) {
    return S.of(context).wind_10;
  } else if (speed <= Wind.WIND_SPEED_11) {
    return S.of(context).wind_11;
  } else {
    return S.of(context).wind_12;
  }
}

String getAqiQuality(BuildContext context, int index) {
  if (index == null || index < 0) {
    return '';
  } if (index <= AirQuality.AQI_INDEX_1) {
    return S.of(context).aqi_1;
  } else if (index <= AirQuality.AQI_INDEX_2) {
    return S.of(context).aqi_2;
  } else if (index <= AirQuality.AQI_INDEX_3) {
    return S.of(context).aqi_3;
  } else if (index <= AirQuality.AQI_INDEX_4) {
    return S.of(context).aqi_4;
  } else if (index <= AirQuality.AQI_INDEX_5) {
    return S.of(context).aqi_5;
  } else {
    return S.of(context).aqi_6;
  }
}

int getMoonPhaseAngle(String phase) {
  if (isEmpty(phase)) {
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