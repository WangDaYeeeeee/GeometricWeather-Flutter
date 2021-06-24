import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';

enum WeatherKind {
  NULL,
  CLEAR,
  CLOUD, 
  CLOUDY,
  RAINY,
  SNOW,
  SLEET,
  HAIL,
  FOG,
  HAZE,
  THUNDER,
  THUNDERSTORM,
  WIND
}

WeatherKind weatherCodeToWeatherKind(WeatherCode code) {
  switch (code) {
    case WeatherCode.CLEAR:
      return WeatherKind.CLEAR;

    case WeatherCode.PARTLY_CLOUDY:
      return WeatherKind.CLOUD;

    case WeatherCode.CLOUDY:
      return WeatherKind.CLOUDY;

    case WeatherCode.RAIN_S:
    case WeatherCode.RAIN_M:
    case WeatherCode.RAIN_L:
    return WeatherKind.RAINY;

    case WeatherCode.SNOW_S:
    case WeatherCode.SNOW_M:
    case WeatherCode.SNOW_L:
    return WeatherKind.SNOW;

    case WeatherCode.WIND:
      return WeatherKind.WIND;

    case WeatherCode.FOG:
      return WeatherKind.FOG;

    case WeatherCode.HAZE:
      return WeatherKind.HAZE;

    case WeatherCode.SLEET:
      return WeatherKind.SLEET;

    case WeatherCode.HAIL:
      return WeatherKind.HAIL;

    case WeatherCode.THUNDER:
      return WeatherKind.THUNDER;

    case WeatherCode.THUNDERSTORM:
      return WeatherKind.THUNDERSTORM;
  }
  return WeatherKind.NULL;
}

typedef OnStateCreatedCallback = void Function();

abstract class WeatherView extends StatefulWidget {

  const WeatherView({
    Key key,
    this.onStateCreated
  }) : super(key: key);

  final OnStateCreatedCallback onStateCreated;

  @override
  State<StatefulWidget> createState() {
    Timer.run(() {
      onStateCreated?.call();
    });
    return null;
  }
}

abstract class WeatherViewState<T extends StatefulWidget> extends State<T> {

  void setWeather(WeatherKind weatherKind, bool daylight);

  void onClick();

  void onScroll(double offset);

  WeatherKind get weatherKind;

  set drawable(bool drawable);

  set gravitySensorEnabled(bool enabled);
}

abstract class WeatherViewThemeDelegate {

  /// @return colors[] {
  ///     theme color,
  ///     color of daytime chart line,
  ///     color of nighttime chart line
  /// }
  List<Color> getThemeColors(
      BuildContext context,
      WeatherKind weatherKind,
      bool daytime,
      bool lightTheme);

  Color getBackgroundColor(
      BuildContext context,
      WeatherKind weatherKind,
      bool daytime,
      bool lightTheme);

  double getHeaderHeight(BuildContext context);

  BoxDecoration getExtendedBackground(
      BuildContext context,
      WeatherKind weatherKind,
      bool daytime,
      bool lightTheme);
}