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
}

class ThemeProvider with ChangeNotifier {

  ThemeMode themeMode;

  ThemeData lightTheme;
  ThemeData darkTheme;

  ThemeProvider() {
    themeMode = ThemeMode.system;

    lightTheme = ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        primaryColor: ThemeColors.primaryColor,
        primaryColorDark: ThemeColors.primaryDarkColor,
        accentColor: ThemeColors.primaryAccentColor,
        backgroundColor: ThemeColors.lightBackgroundColor,
        dividerColor: ThemeColors.lightDividerColor
    );
    darkTheme = ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: ThemeColors.primaryColor,
        primaryColorDark: ThemeColors.primaryDarkColor,
        accentColor: ThemeColors.primaryAccentColor,
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