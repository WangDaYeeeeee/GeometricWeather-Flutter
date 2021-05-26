import 'dart:async';

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

  void reset();

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

  set gravitySensorEnabled(bool enabled);
}