import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const materialToolbarHeight = 56.0;
const cupertinoNavBarHeight = 44.0;

const cardRadius = 12.0;
const littleMargin = 8.0;
const normalMargin = 16.0;

class ThemeColors {
  static const primaryColor = Color(0xFF212121);
  static const primaryDarkColor = Color(0xFF1A1A1A);
  static const primaryAccentColor = Color(0xFF212121);

  static const lightBackgroundColor = Color(0xFFFAFAFA);
  static const darkBackgroundColor = Color(0xFF212121);

  static const lightDividerColor = Color(0xFFF1F1F1);
  static const darkDividerColor = Color(0xFF363636);

  static const colorLevel1 = Color(0xFF72d572);
  static const colorLevel2 = Color(0xFFffca28);
  static const colorLevel3 = Color(0xFFffa726);
  static const colorLevel4 = Color(0xFFe52f35);
  static const colorLevel5 = Color(0xFF99004c);
  static const colorLevel6 = Color(0xFF7e0023);
}

Color getCupertinoAppbarBackground(BuildContext context) =>
    Theme.of(context).primaryColor.withAlpha((255 * 0.5).toInt());

double getAppBarHeight(BuildContext context) =>
    (Platform.isIOS ? cupertinoNavBarHeight : materialToolbarHeight)
        + MediaQuery.of(context).padding.top;

class ThemeProvider with ChangeNotifier {

  static ThemeProvider _instance;
  static ThemeProvider getInstance(ThemeMode themeMode) {
    if (_instance == null) {
      _instance = ThemeProvider._(themeMode);
    }
    return _instance;
  }

  ThemeProvider._(this._themeMode);

  ThemeMode _themeMode;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    primaryColor: Platform.isIOS
        ? ThemeColors.lightDividerColor
        : ThemeColors.primaryColor,
    primaryColorBrightness: Platform.isIOS
        ? Brightness.light
        : Brightness.dark,
    primaryColorDark: Platform.isIOS
        ? ThemeColors.lightDividerColor
        : ThemeColors.primaryDarkColor,
    accentColor: ThemeColors.primaryAccentColor,
    accentColorBrightness: Brightness.dark,
    backgroundColor: ThemeColors.lightBackgroundColor,
    canvasColor: ThemeColors.lightBackgroundColor,
    cardColor: ThemeColors.lightBackgroundColor,
    dividerColor: ThemeColors.lightDividerColor,
  );
  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      primaryColor: Platform.isIOS
          ? ThemeColors.darkDividerColor
          : ThemeColors.primaryColor,
      primaryColorBrightness: Brightness.dark,
      primaryColorDark: Platform.isIOS
          ? ThemeColors.darkDividerColor
          : ThemeColors.primaryDarkColor,
      accentColor: ThemeColors.primaryAccentColor,
      accentColorBrightness: Brightness.dark,
      backgroundColor: ThemeColors.darkBackgroundColor,
      canvasColor: ThemeColors.darkBackgroundColor,
      cardColor: ThemeColors.darkBackgroundColor,
      dividerColor: ThemeColors.darkDividerColor
  );

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode newMode) {
    if (_themeMode != newMode) {

      _themeMode = newMode;
      Timer.run(() {
        notifyListeners();
      });
    }
  }
}