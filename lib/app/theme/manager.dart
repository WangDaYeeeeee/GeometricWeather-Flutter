import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/appearance.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';

class ThemeManager {

  static ThemeManager _instance;
  static ThemeManager getInstance(DarkMode darkMode) {
    if (_instance == null) {
      _instance = ThemeManager._(darkMode);
    }
    return _instance;
  }

  bool _daytime;
  DarkMode _darkMode;
  WeatherViewThemeDelegate _themeDelegate;

  ThemeProvider _themeProvider;

  ThemeManager._(DarkMode darkMode) {
    _daytime = isDaylight();
    _themeProvider = ThemeProvider.getInstance(getThemeMode(darkMode, _daytime));
  }

  // return true if daytime changed.
  bool update({DarkMode darkMode, Location location}) {
    assert(darkMode != null || location != null);

    bool oldDaytime = _daytime;
    if (location != null) {
      _daytime = isDaylightLocation(location);
    }
    if (darkMode != null) {
      _darkMode = darkMode;
    }

    if (_darkMode.key == DarkMode.KEY_AUTO) {
      _themeProvider.themeMode = _daytime
          ? ThemeMode.light
          : ThemeMode.dark;
    } else if (_darkMode.key == DarkMode.KEY_LIGHT) {
      _themeProvider.themeMode = ThemeMode.light;
    } else if (_darkMode.key == DarkMode.KEY_DARK) {
      _themeProvider.themeMode = ThemeMode.dark;
    } else {
      _themeProvider.themeMode = ThemeMode.system;
    }
    return oldDaytime != _daytime;
  }

  void registerWeatherViewThemeDelegate(WeatherViewThemeDelegate themeDelegate) {
    _themeDelegate = themeDelegate;
  }

  void unregisterWeatherViewThemeDelegate() {
    _themeDelegate = null;
  }

  static ThemeMode getThemeMode(DarkMode darkMode, bool daytime) {
    if (darkMode.key == DarkMode.KEY_AUTO) {
      return daytime
          ? ThemeMode.light
          : ThemeMode.dark;
    } else if (darkMode.key == DarkMode.KEY_LIGHT) {
      return ThemeMode.light;
    } else if (darkMode.key == DarkMode.KEY_DARK) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  bool isLightTheme(BuildContext context) {
    if (_darkMode.key == DarkMode.KEY_AUTO) {
      return _daytime;
    }

    if (_darkMode.key == DarkMode.KEY_SYSTEM) {
      return Theme.of(context).brightness == Brightness.light;
    }

    return _darkMode.key == DarkMode.KEY_LIGHT;
  }

  bool get daytime => _daytime;

  ThemeProvider get themeProvider => _themeProvider;

  List<Color> getWeatherThemeColors(
      BuildContext context,
      WeatherCode weatherCode,
      bool daytime,
      bool lightTheme) => _themeDelegate?.getThemeColors(
      context,
      weatherCodeToWeatherKind(weatherCode),
      daytime,
      lightTheme
  ) ?? [
    ThemeColors.primaryColor,
    ThemeColors.primaryColor,
    ThemeColors.primaryColor,
  ];

  Color getWeatherBackgroundColor(
      BuildContext context,
      WeatherCode weatherCode,
      bool daytime,
      bool lightTheme) => _themeDelegate?.getBackgroundColor(
      context,
      weatherCodeToWeatherKind(weatherCode),
      daytime,
      lightTheme
  ) ?? ThemeColors.primaryColor;

  double getHeaderHeight(BuildContext context) =>
      _themeDelegate?.getHeaderHeight(context) ?? 0.0;

  BoxDecoration getExtendedBackground(
      BuildContext context,
      WeatherKind weatherKind,
      bool daytime,
      bool lightTheme) => _themeDelegate?.getExtendedBackground(
      context,
      weatherKind,
      daytime,
      lightTheme
  ) ?? BoxDecoration(color: Colors.transparent);
}
