import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/cloud.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/sun.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';

import 'mtrl_weather_view.dart';

MaterialWeatherPainter getCustomPainter(
    WeatherKind weatherKind,
    bool daylight,
    Listenable repaint) {

  switch(weatherKind) {
    case WeatherKind.NULL:
    case WeatherKind.CLEAR:
      return SunPainter(repaint);

    case WeatherKind.CLOUD:
      return CloudPainter(
          daylight ? CloudType.CLOUD_DAY : CloudType.CLOUD_NIGHT, repaint);

    case WeatherKind.CLOUDY:
      return CloudPainter(
          daylight ? CloudType.CLOUDY_DAY : CloudType.CLOUDY_NIGHT, repaint);

    case WeatherKind.RAINY:
    // TODO: Handle this case.
      break;
    case WeatherKind.SNOW:
    // TODO: Handle this case.
      break;
    case WeatherKind.SLEET:
    // TODO: Handle this case.
      break;
    case WeatherKind.HAIL:
    // TODO: Handle this case.
      break;
    case WeatherKind.FOG:
      return CloudPainter(CloudType.FOG, repaint);

    case WeatherKind.HAZE:
      return CloudPainter(CloudType.HAZE, repaint);

    case WeatherKind.THUNDER:
      return CloudPainter(CloudType.THUNDER, repaint);

    case WeatherKind.THUNDERSTORM:
    // TODO: Handle this case.
      break;
    case WeatherKind.WIND:
    // TODO: Handle this case.
      break;
  }

  return SunPainter(repaint);
}

Gradient getGradient(WeatherKind weatherKind, bool daylight) {
  switch(weatherKind) {

    case WeatherKind.NULL:
    case WeatherKind.CLEAR:
      return sunGradient;

    case WeatherKind.CLOUD:
      return daylight ? cloudDayGradient : cloudNightGradient;

    case WeatherKind.CLOUDY:
      return daylight ? cloudyDayGradient : cloudyNightGradient;

    case WeatherKind.RAINY:
      // TODO: Handle this case.
      break;
    case WeatherKind.SNOW:
      // TODO: Handle this case.
      break;
    case WeatherKind.SLEET:
      // TODO: Handle this case.
      break;
    case WeatherKind.HAIL:
      // TODO: Handle this case.
      break;
    case WeatherKind.FOG:
      return fogGradient;

    case WeatherKind.HAZE:
      return hazeGradient;

    case WeatherKind.THUNDER:
      return thunderGradient;

    case WeatherKind.THUNDERSTORM:
      // TODO: Handle this case.
      break;
    case WeatherKind.WIND:
      // TODO: Handle this case.
      break;
  }

  return sunGradient;
}