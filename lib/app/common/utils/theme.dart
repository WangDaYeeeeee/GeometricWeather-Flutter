import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeColors {
  static const primaryColor = Color(0xFF212121);
  static const primaryDarkColor = Color(0xFF1A1A1A);
  static const primaryAccentColor = Color(0xFF212121);

  static const lightBackgroundColor = Color(0xFFFAFAFA);
  static const darkBackgroundColor = Color(0xFF292929);

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

class ThemeProvider with ChangeNotifier {

  ThemeMode themeMode;

  ThemeData lightTheme;
  ThemeData darkTheme;

  ThemeProvider() {
    themeMode = ThemeMode.system;

    lightTheme = ThemeData(
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
        dividerColor: ThemeColors.lightDividerColor
    );
    darkTheme = ThemeData(
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
        dividerColor: ThemeColors.darkDividerColor
    );
  }

  void setMode(ThemeMode newMode) {
    if (themeMode != newMode) {
      themeMode = newMode;
      notifyListeners();
    }
  }
}