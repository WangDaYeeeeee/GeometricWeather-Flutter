import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch_layout.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/theme.dart';
import 'package:geometricweather_flutter/app/main/app_bar.dart';
import 'package:geometricweather_flutter/main.dart';

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

    return PlatformScaffold(
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
                    child: PlatformText("test!!!"),
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
                      _weatherViewKey.currentState?.setWeather(
                          WeatherKind.values[r.nextInt(WeatherKind.values.length)],
                          r.nextBool()
                      );
                    },
                  ),
                ),
              )
            ]),
            getAppBar(context, 'GeometricWeather')
          ],
        )
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

  // called when this widget is resumed by a pop action of top widget.
  @override
  void didPopNext() {
    _weatherViewKey.currentState?.reset();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _weatherViewKey.currentState?.reset();
    }
  }
}