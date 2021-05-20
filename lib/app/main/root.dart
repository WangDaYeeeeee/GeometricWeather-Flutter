import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch_layout.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';

class RootPage extends StatefulWidget {

  RootPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

class _RootPageState extends State<RootPage> {

  static GlobalKey<WeatherViewState> _weatherViewKey = GlobalKey();

  bool daylight = true;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialWeatherView(
        key: _weatherViewKey,
        child: SwipeSwitchLayout(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: Text("test!!! : $index"),
          ),
          onSwipe: (double progress) {
            // todo swiping.
          },
          onSwitch: (int positionChanging) {
            // todo switch.
            setState(() {
              index += positionChanging;
            });
          },
        ),
        daylight: daylight,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_left),
        onPressed: () {
          daylight = !daylight;
          _weatherViewKey.currentState.setWeather(WeatherKind.CLEAR, daylight);
        },
      ),
    );
  }
}