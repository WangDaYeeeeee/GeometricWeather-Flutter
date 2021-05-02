import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const primaryColor = Color(0xFF212121);
const primaryDarkColor = Color(0xFF1A1A1A);
const primaryAccentColor = Color(0xFF212121);

const lightBackgroundColor = Color(0xFFFAFAFA);
const darkBackgroundColor = Color(0xFF292929);

const lightDividerColor = Color(0xFFF1F1F1);
const darkDividerColor = Color(0xFF363636);

class ThemeProvider with ChangeNotifier {

  ThemeData lightTheme;
  ThemeData darkTheme;
  ThemeMode themeMode;

  ThemeProvider() {
    lightTheme = ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        primaryColor: primaryColor,
        primaryColorDark: primaryDarkColor,
        accentColor: primaryAccentColor,
        backgroundColor: lightBackgroundColor,
        dividerColor: lightDividerColor
    );
    darkTheme = ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: primaryColor,
        primaryColorDark: primaryDarkColor,
        accentColor: primaryAccentColor,
        backgroundColor: darkBackgroundColor,
        dividerColor: darkDividerColor
    );
    themeMode = ThemeMode.system;
  }

  void setMode(ThemeMode newMode) {
    if (themeMode != newMode) {
      themeMode = newMode;
      notifyListeners();
    }
  }
}