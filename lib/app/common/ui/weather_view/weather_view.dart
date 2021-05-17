import 'package:flutter/material.dart';

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

abstract class WeatherViewState {

  void setWeather(WeatherKind weatherKind, bool daylight);

  void onClick();

  void onScroll(int offset);

  WeatherKind get weatherKind;

  /// @return colors[] {
  ///     theme color,
  ///     color of daytime chart line,
  ///     color of nighttime chart line
  /// }
  List<Color> getThemeColors(bool lightTheme);

  Color getBackgroundColor();

  double get headerHeight;

  set drawable(bool drawable);

  set gravitySensorEnabled(bool enabled);
}