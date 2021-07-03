import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geometricweather_flutter/app/main/page_management.dart';
import 'package:geometricweather_flutter/app/search/page_search.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/settings/page_settings.dart';
import 'package:geometricweather_flutter/app/settings/page_settings_unit.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'app/common/basic/widgets.dart';
import 'app/common/utils/router.dart';
import 'app/common/utils/system_services.dart';
import 'app/settings/page_about.dart';
import 'app/settings/page_settings_appearance.dart';
import 'app/theme/theme.dart';
import 'app/main/page_main.dart';
import 'generated/l10n.dart';

SettingsManager settingsManager;
ThemeManager themeManager;

String versionName;
String systemVersion;
String currentTimezone;

void main() {
  setupLocator();
  Paint.enableDithering = true;

  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    preloadMainViewModel(),
    SettingsManager.getInstance(),
    PackageInfo.fromPlatform(),
    Platform.isIOS ? DeviceInfoPlugin().iosInfo : DeviceInfoPlugin().androidInfo,
    FlutterNativeTimezone.getLocalTimezone(),
  ]).then((value) {
    settingsManager = value[1] as SettingsManager;
    themeManager = ThemeManager.getInstance(settingsManager.darkMode);

    versionName = (value[2] as PackageInfo).version;
    systemVersion = Platform.isIOS ? (
        value[3] as IosDeviceInfo
    ).systemVersion : (
        value[3] as AndroidDeviceInfo
    ).version.codename;
    currentTimezone = value[4] as String;

    WidgetsBinding.instance
      // ignore: invalid_use_of_protected_member
      ..scheduleAttachRootWidget(
          GeometricWeather(themeManager.themeProvider)
      )..scheduleWarmUpFrame();
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
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routes: {
              Routers.ROUTER_ID_MAIN: (context) => MainPage(),
              Routers.ROUTER_ID_MANAGEMENT: (context) => ManagementPage(),
              Routers.ROUTER_ID_SEARCH: (context) => SearchPage(),
              Routers.ROUTER_ID_SETTINGS: (context) => SettingsPage(),
              Routers.ROUTER_ID_UNIT_SETTINGS: (context) => UnitSettingsPage(),
              Routers.ROUTER_ID_APPEARANCE_SETTINGS: (context) => AppearanceSettingsPage(),
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

