import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const materialToolbarHeight = 56.0;
const cupertinoNavBarHeight = 44.0;

const cardRadius = 12.0;
const littleMargin = 8.0;
const normalMargin = 16.0;

const androidStatusBarMaskAlpha = 25;

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

  static const colorAlert = Color(0xFFfcc96b);

  static const colorTextHugeTitle_light = Color(0xff212121);
  static const colorTextHugeTitle_dark = Color(0xffffffff);

  static const colorTextTitle_light = Color(0xff424242);
  static const colorTextTitle_dark = Color(0xfffafafa);

  static const colorTextContent_light = Color(0xff5f6267);
  static const colorTextContent_dark = Color(0xfff5f5f5);

  static const colorTextSubtitle_light = Color(0xffbdbdbd);
  static const colorTextSubtitle_dark = Color(0xff9e9e9e);
}

Color getCupertinoAppBarBackground(BuildContext context) =>
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
  ThemeMode get themeMode => _themeMode;

  static final ThemeData _lightTheme = ThemeData(
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
  ThemeData get lightTheme => _lightTheme.copyWith(
    textTheme: _lightTheme.textTheme.copyWith(
      headline1: _lightTheme.textTheme.headline1.copyWith(
        color: ThemeColors.colorTextHugeTitle_light,
      ),
      headline2: _lightTheme.textTheme.headline2.copyWith(
          color: ThemeColors.colorTextHugeTitle_light,
          fontWeight: FontWeight.w400
      ),
      headline3: _lightTheme.textTheme.headline3.copyWith(
          color: ThemeColors.colorTextHugeTitle_light,
          fontWeight: FontWeight.w500
      ),
      headline4: _lightTheme.textTheme.headline4.copyWith(
          color: ThemeColors.colorTextHugeTitle_light,
          fontWeight: FontWeight.w500
      ),
      headline5: _lightTheme.textTheme.headline5.copyWith(
          color: ThemeColors.colorTextHugeTitle_light,
          fontWeight: FontWeight.w500
      ),
      headline6: _lightTheme.textTheme.headline6.copyWith(
          color: ThemeColors.colorTextHugeTitle_light,
          fontWeight: FontWeight.w600
      ),
      subtitle1: _lightTheme.textTheme.subtitle1.copyWith(
          color: ThemeColors.colorTextTitle_light,
          fontWeight: FontWeight.w500
      ),
      subtitle2: _lightTheme.textTheme.subtitle2.copyWith(
          color: ThemeColors.colorTextTitle_light,
          fontWeight: FontWeight.w500
      ),
      bodyText1: _lightTheme.textTheme.bodyText1.copyWith(
          color: ThemeColors.colorTextContent_light,
          fontWeight: FontWeight.w500
      ),
      bodyText2: _lightTheme.textTheme.bodyText2.copyWith(
          color: ThemeColors.colorTextContent_light,
          fontWeight: FontWeight.w400
      ),
      button: _lightTheme.textTheme.button.copyWith(
          color: ThemeColors.colorTextTitle_light,
          fontWeight: FontWeight.w600
      ),
      caption: _lightTheme.textTheme.caption.copyWith(
          color: ThemeColors.colorTextSubtitle_light,
          fontWeight: FontWeight.w400,
      ),
      overline: _lightTheme.textTheme.overline.copyWith(
          color: ThemeColors.colorTextSubtitle_light,
          fontWeight: FontWeight.w400
      ),
    )
  );

  static final ThemeData _darkTheme = ThemeData(
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
  ThemeData get darkTheme => _darkTheme.copyWith(
      textTheme: _darkTheme.textTheme.copyWith(
        headline2: _darkTheme.textTheme.headline2.copyWith(
            color: ThemeColors.colorTextHugeTitle_dark,
            fontWeight: FontWeight.w400
        ),
        headline3: _darkTheme.textTheme.headline3.copyWith(
            color: ThemeColors.colorTextHugeTitle_dark,
            fontWeight: FontWeight.w500
        ),
        headline4: _darkTheme.textTheme.headline4.copyWith(
            color: ThemeColors.colorTextHugeTitle_dark,
            fontWeight: FontWeight.w500
        ),
        headline5: _darkTheme.textTheme.headline5.copyWith(
            color: ThemeColors.colorTextHugeTitle_dark,
            fontWeight: FontWeight.w500
        ),
        headline6: _darkTheme.textTheme.headline6.copyWith(
            color: ThemeColors.colorTextHugeTitle_dark,
            fontWeight: FontWeight.w600
        ),
        subtitle1: _darkTheme.textTheme.subtitle1.copyWith(
            color: ThemeColors.colorTextTitle_dark,
            fontWeight: FontWeight.w500
        ),
        subtitle2: _darkTheme.textTheme.subtitle2.copyWith(
            color: ThemeColors.colorTextTitle_dark,
            fontWeight: FontWeight.w500
        ),
        bodyText1: _darkTheme.textTheme.bodyText1.copyWith(
            color: ThemeColors.colorTextContent_dark,
            fontWeight: FontWeight.w500
        ),
        bodyText2: _darkTheme.textTheme.bodyText2.copyWith(
            color: ThemeColors.colorTextContent_dark,
            fontWeight: FontWeight.w400
        ),
        button: _darkTheme.textTheme.button.copyWith(
            color: ThemeColors.colorTextTitle_dark,
            fontWeight: FontWeight.w600
        ),
        caption: _darkTheme.textTheme.caption.copyWith(
            color: ThemeColors.colorTextSubtitle_dark,
            fontWeight: FontWeight.w400
        ),
        overline: _darkTheme.textTheme.overline.copyWith(
            color: ThemeColors.colorTextSubtitle_dark,
            fontWeight: FontWeight.w400
        ),
      )
  );

  set themeMode(ThemeMode newMode) {
    if (_themeMode != newMode) {

      _themeMode = newMode;
      Timer.run(() {
        notifyListeners();
      });
    }
  }
}