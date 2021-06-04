import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app/common/basic/widgets.dart';
import 'app/common/utils/router.dart';
import 'app/common/utils/system_services.dart';
import 'app/theme/theme.dart';
import 'app/main/page_main.dart';
import 'app/settings/page_about.dart';
import 'generated/l10n.dart';

void main() {
  setupLocator();
  Paint.enableDithering = true;

  WidgetsFlutterBinding.ensureInitialized();
  preloadMainViewModel().then((value) {
    WidgetsBinding.instance
      // ignore: invalid_use_of_protected_member
      ..scheduleAttachRootWidget(GeometricWeather(value))
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

