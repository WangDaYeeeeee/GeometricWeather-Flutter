import 'package:flutter/widgets.dart';
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
    // TODO: Handle this case.
      break;
    case WeatherKind.CLOUDY:
    // TODO: Handle this case.
      break;
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
    // TODO: Handle this case.
      break;
    case WeatherKind.HAZE:
    // TODO: Handle this case.
      break;
    case WeatherKind.THUNDER:
    // TODO: Handle this case.
      break;
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
      // TODO: Handle this case.
      break;
    case WeatherKind.CLOUDY:
      // TODO: Handle this case.
      break;
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
      // TODO: Handle this case.
      break;
    case WeatherKind.HAZE:
      // TODO: Handle this case.
      break;
    case WeatherKind.THUNDER:
      // TODO: Handle this case.
      break;
    case WeatherKind.THUNDERSTORM:
      // TODO: Handle this case.
      break;
    case WeatherKind.WIND:
      // TODO: Handle this case.
      break;
  }

  return sunGradient;
}