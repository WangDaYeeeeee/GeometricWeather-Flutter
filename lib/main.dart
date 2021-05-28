import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/location/helper.dart';
import 'package:geometricweather_flutter/app/root/root.dart';
import 'package:provider/provider.dart';

import 'app/common/utils/router.dart';
import 'app/common/utils/system_services.dart';
import 'app/common/utils/theme.dart';
import 'app/db/helper.dart';
import 'app/settings/about.dart';
import 'generated/l10n.dart';

final themeProvider = ThemeProvider();
final locationListRes = LocationListResource([], DataChanged());
final routeObserver = RouteObserver<PageRoute>();

void initialize() async {
  try {
    final locationList = await DatabaseHelper.getInstance().readLocationList();
    locationListRes.update((list) {
      list.addAll(locationList);
      return ItemRangeInserted(0, list.length - 1);
    });

    final local = await LocationHelper().requestLocation(locationList[0]);
    locationListRes.update((list) {
      list[0] = local;
      return ItemChanged(0);
    });

    var response = await Dio().get('http://www.baidu.com');
    print(response);
  } catch (e) {
    log(e);
  }
}

void main() {
  // init plugins.
  setupLocator();
  Paint.enableDithering = true;

  // read cache.
  Timer.run(() {
    initialize();
  });

  runApp(GeometricWeather());
}

class GeometricWeather extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: themeProvider
        ),
        ChangeNotifierProvider.value(
            value: locationListRes
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
              title: 'Geometric Weather',
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
              routes: {
                Routers.ROUTER_ID_ROOT: (context) => RootPage(),
                Routers.ROUTER_ID_ABOUT: (context) => AboutPage(),
              },
              navigatorObservers: [routeObserver],
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