import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/cloud.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/hail.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/metro_shower.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/rain.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/snow.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/sun.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/wind.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';

import 'mtrl_weather_view.dart';

MaterialWeatherPainter getCustomPainter(
    WeatherKind weatherKind,
    bool daylight,
    Listenable repaint) {

  switch(weatherKind) {
    case WeatherKind.NULL:
    case WeatherKind.CLEAR:
      return daylight ? SunPainter(repaint) : MeteorShowerPainter(repaint);

    case WeatherKind.CLOUD:
      return CloudPainter(
          daylight ? CloudType.CLOUD_DAY : CloudType.CLOUD_NIGHT, repaint);

    case WeatherKind.CLOUDY:
      return CloudPainter(
          daylight ? CloudType.CLOUDY_DAY : CloudType.CLOUDY_NIGHT, repaint);

    case WeatherKind.RAINY:
      return RainPainter(daylight ? RainType.RAIN_DAY : RainType.RAIN_NIGHT, repaint);

    case WeatherKind.SNOW:
      return SnowPainter(daylight, repaint);

    case WeatherKind.SLEET:
      return RainPainter(daylight ? RainType.SLEET_DAY : RainType.SLEET_NIGHT, repaint);

    case WeatherKind.HAIL:
      return HailPainter(daylight, repaint);

    case WeatherKind.FOG:
      return CloudPainter(CloudType.FOG, repaint);

    case WeatherKind.HAZE:
      return CloudPainter(CloudType.HAZE, repaint);

    case WeatherKind.THUNDER:
      return CloudPainter(CloudType.THUNDER, repaint);

    case WeatherKind.THUNDERSTORM:
      return RainPainter(RainType.THUNDERSTORM, repaint);

    case WeatherKind.WIND:
      return WindPainter(repaint);
  }

  return SunPainter(repaint);
}

MaterialBackgroundGradiant getGradient(WeatherKind weatherKind, bool daylight) {
  switch(weatherKind) {
    case WeatherKind.NULL:
    case WeatherKind.CLEAR:
      return daylight ? sunGradient : metroShowerGradient;

    case WeatherKind.CLOUD:
      return daylight ? cloudDayGradient : cloudNightGradient;

    case WeatherKind.CLOUDY:
      return daylight ? cloudyDayGradient : cloudyNightGradient;

    case WeatherKind.RAINY:
      return daylight ? rainDayGradient : rainNightGradient;

    case WeatherKind.SNOW:
      return daylight ? snowDayGradient : snowNightGradient;

    case WeatherKind.SLEET:
      return daylight ? sleetDayGradient : sleetNightGradient;

    case WeatherKind.HAIL:
      return daylight ? hailDayGradient : hailNightGradient;

    case WeatherKind.FOG:
      return fogGradient;

    case WeatherKind.HAZE:
      return hazeGradient;

    case WeatherKind.THUNDER:
      return thunderGradient;

    case WeatherKind.THUNDERSTORM:
      return thunderstormGradient;

    case WeatherKind.WIND:
      return windGradient;
  }

  return sunGradient;
}