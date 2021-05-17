import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geometricweather_flutter/app/main/root.dart';
import 'package:provider/provider.dart';

import 'app/common/utils/router.dart';
import 'app/common/utils/system_services.dart';
import 'app/common/utils/theme.dart';
import 'app/settings/about.dart';
import 'generated/l10n.dart';

void main() {
  setupLocator();

  runApp(GeometricWeather());
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
                ROUTER_ID_ROOT:(context) => RootPage(),
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