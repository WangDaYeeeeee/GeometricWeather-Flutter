import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/utils.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/palette.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';

const SWITCH_ANIMATION_DURATION = 350;

class MaterialWeatherView extends WeatherView {

  const MaterialWeatherView({
    Key key,
    this.weatherKind = WeatherKind.NULL,
    this.daylight = true,
    this.drawable = true,
    this.gravitySensorEnabled = true,
    OnStateCreatedCallback onStateCreated
  }) : super(key: key, onStateCreated: onStateCreated);

  final WeatherKind weatherKind;
  final bool daylight;
  final bool drawable;
  final bool gravitySensorEnabled;

  @override
  State<StatefulWidget> createState() {
    return MaterialWeatherViewState();
  }
}

class MaterialWeatherViewState extends WeatherViewState<MaterialWeatherView>
    with TickerProviderStateMixin {

  WeatherKind _weatherKindIn;
  bool _daylightIn;
  MaterialWeatherPainter _painterIn;
  Gradient _gradientIn;

  MaterialWeatherPainter _painterOut;
  Gradient _gradientOut;

  double _switchInProgress; // 0 - 1.

  AnimationController _switchAnimController;
  Animation<double> _switchAnim;
  AnimationController _paintingAnimController;

  bool _drawable;
  bool _gravitySensorEnabled;
  double _headerHeight = 0;

  List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  List<double> accelerometer;
  List<double> userAccelerometer;
  final List<double> accelerometerOfGravity = [0, 0, 0]; // x, y, z.

  @override
  void initState() {
    super.initState();

    _weatherKindIn = widget.weatherKind;
    _daylightIn = widget.daylight;

    _switchInProgress = 1;

    _drawable = widget.drawable;
    _gravitySensorEnabled = widget.gravitySensorEnabled;

    _paintingAnimController = AnimationController(
      duration: const Duration(milliseconds: 9007199254740992),
      vsync: this,
    );
    Tween<double>(begin: 0, end: 1).animate(_paintingAnimController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _paintingAnimController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _paintingAnimController.forward();
        }
      });
    _paintingAnimController.forward();

    _switchAnimController = null;

    _painterIn = getCustomPainter(_weatherKindIn, _daylightIn, _paintingAnimController);
    _gradientIn = getGradient(_weatherKindIn, _daylightIn);

    _painterOut = null;
    _gradientOut = null;

    _registerSensors();
  }

  @override
  void dispose() {
    super.dispose();
    _unregisterSensors();
    _paintingAnimController.dispose();
    _cancelSwitchAnimation();
  }

  @override
  Widget build(BuildContext context) {
    // todo: fix it.
    _headerHeight = max(MediaQuery.of(context).size.height * 0.55, 180.0);

    if (_drawable) {
      if (0 <= _switchInProgress && _switchInProgress < 1) {
        // executing switch animation.
        return Stack(children: [
          _innerBuild(_gradientOut, _painterOut),
          FadeTransition(
              opacity: _switchAnim,
              child: _innerBuild(_gradientIn, _painterIn)
          )
        ]);
      }

      return _innerBuild(_gradientIn, _painterIn);
    } else {
      return Container(child: null);
    }
  }

  Widget _innerBuild(Gradient gradient, CustomPainter painter) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: gradient
      ),
      child: RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: painter
          )
      ),
    );
  }

  void _registerSensors() {
    SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST
    ).then((value) => {
      _streamSubscriptions.add(value.listen((event) {
        accelerometer = event.data;

        if (Platform.isIOS) {
          for (int i = 0; i < accelerometer.length; i ++) {
            accelerometer[i] *= -9.81;
          }
        }
      }))
    });

    SensorManager().sensorUpdates(
      sensorId: Sensors.LINEAR_ACCELERATION,
      interval: Sensors.SENSOR_DELAY_FASTEST
    ).then((value) => {
      _streamSubscriptions.add(value.listen((event) {
        userAccelerometer = event.data;

        if (Platform.isIOS) {
          for (int i = 0; i < userAccelerometer.length; i ++) {
            userAccelerometer[i] *= -9.81;
          }
        }

        if (_gravitySensorEnabled
            && accelerometer != null
            && userAccelerometer != null
            && accelerometer.length == 3
            && userAccelerometer.length == 3) {

          for (int i = 0; i < accelerometerOfGravity.length; i ++) {
            accelerometerOfGravity[i] = accelerometer[i] - userAccelerometer[i];
          }

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

          _painterIn?._setRotation(rotation2D, rotation3D);
        } else {
          _painterIn?._setRotation(0, 0);
        }
      }))
    });
  }

  void _unregisterSensors() {
    for (StreamSubscription s in _streamSubscriptions) {
      s.cancel();
    }
  }

  void _startSwitchAnimation() {
    _switchAnimController = AnimationController(
        duration: Duration(milliseconds: SWITCH_ANIMATION_DURATION),
        vsync: this
    );

    Animation a = CurvedAnimation(
        parent: _switchAnimController,
        curve: Curves.easeInOutCubic
    );
    a.addListener(() {
      setState(() {
        _switchInProgress = a.value;
      });
    });

    _switchAnim = a;
    a = Tween(begin: 1 - _switchInProgress, end: 1.0).animate(_switchAnim);

    _switchAnimController.forward();
  }

  void _cancelSwitchAnimation() {
    _switchAnimController?.dispose();
    _switchAnimController = null;
  }

  static Color _getBrighterColor(Color color){
    HSVColor hsv = HSVColor.fromColor(color);
    return HSLColor.fromAHSL(
        hsv.alpha,
        hsv.hue,
        max(0, hsv.saturation - 0.25),
        min(1, hsv.value + 0.25)
    ).toColor();
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
  Color getBackgroundColor() => _gradientIn.colors[0];

  @override
  List<Color> getThemeColors(bool lightTheme) {
    Color color = getBackgroundColor();
    if (!lightTheme) {
      color = _getBrighterColor(color);
    }
    return [color, color, color.withAlpha((0.5 * 255).toInt())];
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
      _painterIn._setScrollRate(0);
    } else {
      _painterIn._setScrollRate(1.0 * offset / _headerHeight);
    }
  }

  @override
  void setWeather(WeatherKind weatherKind, bool daylight) {
    if (_weatherKindIn != weatherKind || _daylightIn != daylight) {
      setState(() {
        // save current data.
        _painterOut = _painterIn;
        _gradientOut = _gradientIn;

        // register new data.
        _weatherKindIn = weatherKind;
        _daylightIn = daylight;
        _painterIn = getCustomPainter(weatherKind, daylight, _paintingAnimController);
        _gradientIn = getGradient(weatherKind, daylight);

        _cancelSwitchAnimation();
        _startSwitchAnimation();
      });
    }
  }

  @override
  WeatherKind get weatherKind => _weatherKindIn;
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

  static const DEFAULT_ABS_ACCELERATION = 90.0 / 200.0 / 800.0;

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
}