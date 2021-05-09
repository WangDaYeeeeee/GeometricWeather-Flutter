import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/palette.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';

class MaterialWeatherView extends StatefulWidget {

  const MaterialWeatherView({
    Key key,
    this.initWeatherKind = WeatherKind.CLEAR,
    this.initDaylight = true,
    this.child
  }) : super(key: key);

  final WeatherKind initWeatherKind;
  final bool initDaylight;

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return MaterialWeatherViewState();
  }
}

class MaterialWeatherViewState extends State<MaterialWeatherView>
    with TickerProviderStateMixin
    implements WeatherView {

  WeatherKind _weatherKind;
  bool _daylight;

  AnimationController _animController;
  CustomPainter _painter;

  @override
  void initState() {
    super.initState();

    _weatherKind = widget.initWeatherKind;
    _daylight = widget.initDaylight;

    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Tween<double>(begin: 0, end: 300).animate(_animController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animController.forward();
        }
      });
    _animController.forward();
    _painter = getCustomPainter(_weatherKind, _daylight, _animController);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: getGradient(_weatherKind, _daylight)
      ),
      child: RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: _painter,
            child: RepaintBoundary(child: widget.child),
          )
      ),
    );
  }

  @override
  set drawable(bool drawable) {
    // TODO: implement drawable
  }

  @override
  Color getBackgroundColor() {
    // TODO: implement getBackgroundColor
    throw UnimplementedError();
  }

  @override
  List<Color> getThemeColors(bool lightTheme) {
    // TODO: implement getThemeColors
    throw UnimplementedError();
  }

  @override
  set gravitySensorEnabled(bool enabled) {
    // TODO: implement gravitySensorEnabled
  }

  @override
  // TODO: implement headerHeight
  int get headerHeight => throw UnimplementedError();

  @override
  void onClick() {
    // TODO: implement onClick
  }

  @override
  void onScroll(int offset) {
    // TODO: implement onScroll
  }

  @override
  void setWeather(WeatherKind weatherKind, bool daylight) {
    if (_weatherKind != weatherKind || _daylight != daylight) {
      setState(() {
        _weatherKind = weatherKind;
        _daylight = daylight;
        _painter = getCustomPainter(_weatherKind, _daylight, _animController);
      });
    }
  }

  @override
  WeatherKind get weatherKind => _weatherKind;
}

abstract class MaterialWeatherPainter extends CustomPainter {

  MaterialWeatherPainter(this.repaint): super(repaint: repaint);

  final Listenable repaint;

  double scrollRate = 0;
  double rotation2D = 0;
  double rotation3D = 0;

  void updateData(double scrollRate, double rotation2D, double rotation3D) {
    this.scrollRate = scrollRate;
    this.rotation2D = rotation2D;
    this.rotation3D = rotation3D;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}