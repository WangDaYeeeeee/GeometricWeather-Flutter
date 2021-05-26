import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch_layout.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/theme.dart';
import 'package:geometricweather_flutter/app/main/app_bar.dart';

class RootPage extends StatefulWidget {

  RootPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

class _RootPageState extends State<RootPage> {

  static GlobalKey<WeatherViewState> _weatherViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool lightTheme = Theme.of(context).brightness == Brightness.light;

    return PlatformScaffold(
        body: Stack(
          children: [
            MaterialWeatherView(
              key: _weatherViewKey,
              weatherKind: WeatherKind.values[
                Random().nextInt(WeatherKind.values.length)
              ],
              daylight: Random().nextBool(),
              onStateCreated: () {
                setState(() { });
              },
            ),
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
}