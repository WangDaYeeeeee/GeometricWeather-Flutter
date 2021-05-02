import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app/common/router.dart';
import 'app/common/theme.dart';
import 'app/settings/about.dart';
import 'generated/l10n.dart';

void main() {
  runApp(GeometricWeather());

  if (Platform.isAndroid || Platform.isIOS) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      // systemNavigationBarColor: null,
      // systemNavigationBarDividerColor: null,
      // systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class GeometricWeather extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _GeometricWeatherState();
  }
}

class _GeometricWeatherState extends State<GeometricWeather> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
              title: 'Geometric Weather',
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
              routes: {
                ROUTER_ID_ROOT:(context) => AboutPage(),
                ROUTER_ID_ABOUT:(context) => AboutPage(),
              },
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales
          );
        },
      ),
    );
  }
}