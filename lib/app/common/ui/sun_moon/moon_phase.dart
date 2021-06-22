// @dart=2.12

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const DIVIDER_WIDTH = 1.5;
const INNER_MARGIN = 1.5;

class MoonPhaseView extends StatefulWidget {

  MoonPhaseView({
    Key? key,
    required this.initVisible,
    required this.duration,
    required this.angle,
    this.lightColor = Colors.white,
    this.darkColor = Colors.black,
    required this.theme,
  }): assert(0 <= angle && angle <= 360),
        super(key: key);

  final bool initVisible;

  final int duration;
  final double angle;
  final Color lightColor;
  final Color darkColor;

  final ThemeData theme;

  @override
  State<StatefulWidget> createState() {
    return MoonPhaseViewState();
  }
}

class MoonPhaseViewState extends State<MoonPhaseView>
    with TickerProviderStateMixin {

  AnimationController? _angleController;
  Animation<double>? _angleAnim;

  _MoonPhasePainter? _painter;

  @override
  void initState() {
    super.initState();

    _angleController = AnimationController(
        duration: Duration(milliseconds: widget.duration),
        vsync: this
    );
    _angleAnim = Tween(
        begin: 0.0,
        end: widget.angle
    ).animate(
        CurvedAnimation(
          parent: _angleController!,
          curve: Curves.easeInOutQuint,
        )
    );

    if (widget.initVisible) {
      _angleController!.forward(from: 1.0);
    }

    _painter = _MoonPhasePainter(
      _angleController!,
      _angleAnim!,
      widget.lightColor,
      widget.darkColor,
      widget.theme.brightness == Brightness.light,
    );
  }

  @override
  void dispose() {
    _angleController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MoonPhaseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _painter = _MoonPhasePainter(
        _angleController!,
        _angleAnim!,
        widget.lightColor,
        widget.darkColor,
        widget.theme.brightness == Brightness.light,
      );
    });
  }

  void executeAnimations({double from = 0.0}) {
    if (!widget.initVisible) {
      _angleController?.forward(from: from);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _painter!,
      ),
    );
  }
}

class _MoonPhasePainter extends CustomPainter {

  _MoonPhasePainter(
      AnimationController animationController,
      this._angleAnim,
      this._lightColor,
      this._darkColor,
      this.lightTheme): super(repaint: animationController);
  
  final _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;

  final Animation<double> _angleAnim; // 0 - 360.
  final Color _lightColor;
  final Color _darkColor;
  final bool lightTheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2.0, size.height / 2.0);
    final radius = (min(size.width, size.height) - 2 * INNER_MARGIN) / 2.0;
    final arcRect = Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius);

    _paint.style = PaintingStyle.fill;

    if (_angleAnim.value == 0.0) { // 🌑
      _paint.color = _darkColor;
      canvas.drawCircle(center, radius, _paint);
    } else if (_angleAnim.value < 90.0) { // 🌒
      _paint.color = _lightColor;
      canvas.drawCircle(center, radius, _paint);

      _paint.color = _darkColor;
      canvas.drawArc(arcRect, _toRadians(90.0), _toRadians(180.0), true, _paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: center,
              width: 2 * radius * cos(_toRadians(_angleAnim.value)),
              height: 2 * radius
          ),
          _paint
      );
    } else if (_angleAnim.value == 90.0) { // 🌓
      _paint.color = _darkColor;
      canvas.drawCircle(center, radius, _paint);

      _paint.color = _lightColor;
      canvas.drawArc(arcRect, _toRadians(270.0), _toRadians(180.0), true, _paint);
    } else if (_angleAnim.value < 180.0) { // 🌔
      _paint.color = _darkColor;
      canvas.drawCircle(center, radius, _paint);

      _paint.color = _lightColor;
      canvas.drawArc(arcRect, _toRadians(270.0), _toRadians(180.0), true, _paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: center,
              width: 2 * radius * sin(_toRadians(_angleAnim.value - 90)),
              height: 2 * radius
          ),
          _paint
      );
    } else if (_angleAnim.value == 180.0) { // 🌕
      _paint.color = _lightColor;
      canvas.drawCircle(center, radius, _paint);
    } else if (_angleAnim.value < 270.0) { // 🌖
      _paint.color = _darkColor;
      canvas.drawCircle(center, radius, _paint);

      _paint.color = _lightColor;
      canvas.drawArc(arcRect, _toRadians(90.0), _toRadians(180.0), true, _paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: center,
              width: 2 * radius * cos(_toRadians(_angleAnim.value - 180)),
              height: 2 * radius
          ),
          _paint
      );
    } else if (_angleAnim.value == 270.0) { // 🌗
      _paint.color = _darkColor;
      canvas.drawCircle(center, radius, _paint);

      _paint.color = _lightColor;
      canvas.drawArc(arcRect, _toRadians(90.0), _toRadians(180.0), true, _paint);
    } else { // surface angle < 360. 🌘
      _paint.color = _lightColor;
      canvas.drawCircle(center, radius, _paint);

      _paint.color = _darkColor;
      canvas.drawArc(arcRect, _toRadians(270.0), _toRadians(180.0), true, _paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: center,
              width: 2 * radius * cos(_toRadians(360 - _angleAnim.value)),
              height: 2 * radius
          ),
          _paint
      );
    }

    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = DIVIDER_WIDTH;
    _paint.color = lightTheme ? _darkColor : _lightColor;
    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

double _toRadians(double degrees) {
  return degrees * pi / 180.0;
}

double _toDegrees(double radians) {
  return radians * 180.0 / pi;
}