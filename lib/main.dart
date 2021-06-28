import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geometricweather_flutter/app/main/page_management.dart';
import 'package:geometricweather_flutter/app/search/page_search.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'app/common/basic/widgets.dart';
import 'app/common/utils/router.dart';
import 'app/common/utils/system_services.dart';
import 'app/settings/page_about.dart';
import 'app/theme/theme.dart';
import 'app/main/page_main.dart';
import 'generated/l10n.dart';

SettingsManager settingsManager;
ThemeManager themeManager;

String versionName;
String currentTimezone;

void main() {
  setupLocator();
  Paint.enableDithering = true;

  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    preloadMainViewModel(),
    SettingsManager.getInstance(),
    PackageInfo.fromPlatform(),
    FlutterNativeTimezone.getLocalTimezone(),
  ]).then((value) {
    settingsManager = value[1] as SettingsManager;
    themeManager = ThemeManager.getInstance(settingsManager.darkMode);

    versionName = (value[2] as PackageInfo).version;
    currentTimezone = value[3] as String;
    WidgetsBinding.instance
      // ignore: invalid_use_of_protected_member
      ..scheduleAttachRootWidget(GeometricWeather(themeManager.themeProvider))
      ..scheduleWarmUpFrame();
  });
}

class GeometricWeather extends StatelessWidget {

  GeometricWeather(this._themeProvider, {
    Key key
  }): super(key: key);

  final ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Geometric Weather',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routes: {
              Routers.ROUTER_ID_ROOT: (context) => MainPage(),
              Routers.ROUTER_ID_MANAGEMENT: (context) => ManagementPage(),
              Routers.ROUTER_ID_SEARCH: (context) => SearchPage(),
              Routers.ROUTER_ID_ABOUT: (context) => AboutPage(),
            },
            navigatorObservers: [routeObserver],
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}

