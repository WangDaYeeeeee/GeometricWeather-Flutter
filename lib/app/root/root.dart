import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch_layout.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/common/utils/polling.dart';
import 'package:geometricweather_flutter/app/common/utils/theme.dart';
import 'package:geometricweather_flutter/app/root/app_bar.dart';
import 'package:geometricweather_flutter/main.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {

  RootPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

class _RootPageState extends State<RootPage>
    with RouteAware, WidgetsBindingObserver {

  static GlobalKey<WeatherViewState> _weatherViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final bool lightTheme = Theme.of(context).brightness == Brightness.light;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: locationListRes
        )
      ],
      child: PlatformScaffold(
          body: Stack(
            children: [
              MaterialWeatherView(
                key: _weatherViewKey,
                weatherKind: WeatherKind.CLOUD,
                daylight: true,
                onStateCreated: () {
                  setState(() { });
                },
              ),
              Stack(children: [
                SwipeSwitchLayout(
                  child: RefreshIndicator(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Consumer<LocationListResource>(
                        builder: (context, locationListResource, _) {

                          if (locationListResource.event is ItemRangeInserted
                              && locationListResource.locationList.length > 0) {
                            UpdateProgressHandler.requestWeatherUpdate(
                                context,
                                locationListResource.locationList[0]
                            ).listen((event) {
                              log('result = ${event.status}');
                              locationListResource.update((list) {
                                list[0] = event.data;
                                return ItemChanged(0);
                              });
                            });
                          }

                          return locationListResource.locationList.length == 0
                              ? PlatformCircularProgressIndicator()
                              : PlatformText(
                              "${
                                  getLocationName(
                                      context,
                                      locationListResource.locationList[0]
                                  )
                              }, ${
                                  locationListResource.locationList[0].latitude
                              }, ${
                                  locationListResource.locationList[0].longitude
                              }"
                          );
                        },
                      ),
                    ),
                    onRefresh: _onRefresh,
                    color: _getThemeColors(lightTheme)[0],
                  ),
                  onSwipe: _onSwiping,
                  onSwitch: _onSwitch,
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: SafeArea(
                    child: FloatingActionButton(
                      child: Icon(Icons.switch_left_outlined),
                      onPressed: () {
                        Random r = Random();
                        bool light = r.nextBool();
                        _weatherViewKey.currentState?.setWeather(
                            WeatherKind.values[r.nextInt(WeatherKind.values.length)],
                            light
                        );

                        themeProvider.setMode(light ? ThemeMode.light : ThemeMode.dark);
                      },
                    ),
                  ),
                )
              ]),
              getAppBar(context, 'GeometricWeather')
            ],
          )
      ),
    );
  }

  List<Color> _getThemeColors(bool lightTheme) {
    if (_weatherViewKey.currentState == null) {
      return [
        ThemeColors.primaryColor,
        ThemeColors.primaryDarkColor,
        ThemeColors.primaryAccentColor
      ];
    }
    return _weatherViewKey.currentState.getThemeColors(lightTheme);
  }

  Future<void> _onRefresh() async {
    return Future.delayed(Duration(seconds: 3));
  }

  void _onSwiping(double progress) {
    // todo: show swipe indicate.
  }

  void _onSwitch(int positionChanging) {
    // todo: switch location.
  }

  @override
  void didPushNext() {
    _weatherViewKey.currentState?.drawable = false;
  }

  @override
  void didPopNext() {
    _weatherViewKey.currentState?.drawable = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _weatherViewKey.currentState?.drawable = true;
    } else if (state == AppLifecycleState.paused) {
      _weatherViewKey.currentState?.drawable = false;
    }
  }
}