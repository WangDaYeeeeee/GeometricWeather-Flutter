import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/utils.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/palette.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:sensors/sensors.dart';

class MaterialWeatherView extends StatefulWidget {

  const MaterialWeatherView({
    Key key,
    this.initWeatherKind = WeatherKind.CLEAR,
    this.initDaylight = true,
    this.initDrawable = true,
    this.initGravitySensorEnabled = true,
    this.child
  }) : super(key: key);

  final WeatherKind initWeatherKind;
  final bool initDaylight;
  final bool initDrawable;
  final bool initGravitySensorEnabled;

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return MaterialWeatherViewState();
  }
}

class MaterialWeatherViewState extends State<MaterialWeatherView>
    with TickerProviderStateMixin
    implements WeatherViewState {

  WeatherKind _weatherKind;
  bool _daylight;
  bool _drawable;
  bool _gravitySensorEnabled;

  AnimationController _animController;
  MaterialWeatherPainter _painter;

  double _headerHeight = 0;

  List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  List<double> accelerometer;
  List<double> userAccelerometer;
  final List<double> accelerometerOfGravity = [0, 0, 0]; // x, y, z.

  @override
  void initState() {
    super.initState();

    _weatherKind = widget.initWeatherKind;
    _daylight = widget.initDaylight;
    _drawable = widget.initDrawable;
    _gravitySensorEnabled = widget.initGravitySensorEnabled;

    _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
      if (accelerometer == null) {
        accelerometer = [event.x, event.y, event.z];
      } else {
        accelerometer[0] = event.x;
        accelerometer[1] = event.y;
        accelerometer[2] = event.z;
      }
    }));

    _streamSubscriptions.add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (userAccelerometer == null) {
        userAccelerometer = [event.x, event.y, event.z];
      } else {
        userAccelerometer[0] = event.x;
        userAccelerometer[1] = event.y;
        userAccelerometer[2] = event.z;
      }

      Timer.run(() {
        if (_gravitySensorEnabled && accelerometer != null && userAccelerometer != null) {
          // update gravity.
          for (int i = 0; i < accelerometerOfGravity.length; i ++) {
            accelerometerOfGravity[i] = accelerometer[i] - userAccelerometer[i];
          }

          // display.
          double aX = accelerometerOfGravity[0];
          double aY = accelerometerOfGravity[1];
          double aZ = accelerometerOfGravity[2];
          double g2D = sqrt(aX * aX + aY * aY);
          double g3D = sqrt(aX * aX + aY * aY + aZ * aZ);
          double cos2D = max(min(1, aY / g2D), -1);
          double cos3D = max(min(1, g2D * (aY >= 0 ? 1 : -1) / g3D), -1);

          double rotation2D = toDegrees(acos(cos2D)) * (aX >= 0 ? 1 : -1);
          double rotation3D = toDegrees(acos(cos3D)) * (aZ >= 0 ? 1 : -1);

          if (60 < rotation3D.abs() && rotation3D.abs() < 120) {
            rotation2D *= (rotation3D.abs() - 90).abs() / 30.0;
          }

          _painter?._setRotation(rotation2D, rotation3D);
        } else {
          _painter?._setRotation(0, 0);
        }
      });
    }));

    _animController = AnimationController(
      duration: const Duration(milliseconds: 9007199254740992),
      vsync: this,
    );
    Tween<double>(begin: 0, end: 1).animate(_animController)
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
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // todo: fix it.
    _headerHeight = max(MediaQuery.of(context).size.height * 0.55, 180.0);

    if (_drawable) {
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
    } else {
      return Container(child: widget.child);
    }
  }

  @override
  set drawable(bool drawable) {
    if (_drawable != drawable) {
      setState(() {
        _drawable = drawable;
      });
    }
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
    _gravitySensorEnabled = enabled;
  }

  @override
  double get headerHeight => _headerHeight;

  @override
  void onClick() {
    // do nothing.
  }

  @override
  void onScroll(int offset) {
    if (_headerHeight == 0) {
      _painter._setScrollRate(0);
    } else {
      _painter._setScrollRate(1.0 * offset / _headerHeight);
    }
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

  final IntervalComputer _intervalComputer = IntervalComputer();
  final List<_DelayRotationController> _rotationControllers = [
    _DelayRotationController(0), _DelayRotationController(0)
  ];

  final Listenable repaint;

  // 0: no scroll -> show anim with a full alpha value (255).
  // 1: child has already scrolled to hide this view -> hide anim.
  double _scrollRate = 0;
  double _rotation2D = 0;
  double _rotation3D = 0;

  void _setScrollRate(double scrollRate) {
    _scrollRate = scrollRate;
  }

  void _setRotation(double rotation2D, double rotation3D) {
    _rotation2D = rotation2D;
    _rotation3D = rotation3D;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_scrollRate < 1) {
      int interval = _intervalComputer.invalidate();

      _rotationControllers[0].updateRotation(_rotation2D, interval);
      _rotationControllers[1].updateRotation(_rotation3D, interval);

      paintWithInterval(
          canvas,
          size,
          interval,
          _scrollRate,
          _rotationControllers[0].rotation,
          _rotationControllers[1].rotation
      );
    }
  }

  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _DelayRotationController {

  double _targetRotation;
  double _currentRotation;
  double _velocity;
  double _acceleration;

  static const DEFAULT_ABS_ACCELERATION = 90.0 / 200.0 / 800.0 * 1.5;

  _DelayRotationController(double initRotation) {
    _targetRotation = _getRotationInScope(initRotation);
    _currentRotation = _targetRotation;
    _velocity = 0;
    _acceleration = 0;
  }

  void updateRotation(double rotation, int interval) {
    _targetRotation = _getRotationInScope(rotation);

    if (_targetRotation == _currentRotation) {
      // no need to move.
      _acceleration = 0;
      _velocity = 0;
      return;
    }

    double d;
    if (_velocity == 0 || (_targetRotation - _currentRotation) * _velocity < 0) {
      // start or turn around.
      _acceleration = (_targetRotation > _currentRotation ? 1 : -1) * DEFAULT_ABS_ACCELERATION;
      d = _acceleration * pow(interval, 2) / 2.0;
      _velocity = _acceleration * interval;

    } else if (pow(_velocity.abs(), 2) / (2 * DEFAULT_ABS_ACCELERATION)
        < (_targetRotation - _currentRotation).abs()) {
      // speed up.
      _acceleration = (_targetRotation > _currentRotation ? 1 : -1) * DEFAULT_ABS_ACCELERATION;
      d = _velocity * interval + _acceleration * pow(interval, 2) / 2.0;
      _velocity += _acceleration * interval;

    } else {
      // slow down.
      _acceleration = (_targetRotation > _currentRotation ? -1 : 1)
          * pow(_velocity, 2) / (2.0 * (_targetRotation - _currentRotation).abs());
      d = _velocity * interval + _acceleration * pow(interval, 2) / 2.0;
      _velocity += _acceleration * interval;
    }

    if (d.abs() > (_targetRotation - _currentRotation).abs()) {
      _acceleration = 0;
      _currentRotation = _targetRotation;
      _velocity = 0;
    } else {
      _currentRotation += d;
    }
  }

  double get rotation => _currentRotation;

  // ensure the rotation value between -180 and 180.
  double _getRotationInScope(double rotation) {
    if (-180 <= rotation && rotation <= 180) {
      return rotation;
    }

    while(rotation < 0) {
      rotation += 180;
    }
    return rotation % 180;
  }

  double _getDeltaRotation() {
    double delta = _targetRotation - _currentRotation;
    if (delta.abs() < 180) {
      return delta;
    }

    return delta > 0 ? delta - 360 : delta + 360;
  }
}