import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';

class RootPage extends StatelessWidget {

  RootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialWeatherView(
        child: Container(),
      ),
    );
  }
}