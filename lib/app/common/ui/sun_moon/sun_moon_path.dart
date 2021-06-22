// @dart=2.12

import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const PATH_WIDTH = 4.0;
const DIVIDER_WIDTH = 1.0;
const ICON_SIZE = 24.0;

const SHADOW_ALPHA = 50;
const DIVIDER_ALPHA = 100;

const MAX_ROTATION = 7.0;

class SunMoonPathView extends StatefulWidget {

  SunMoonPathView({
    Key? key,
    required this.initVisible,
    required this.width,
    required this.sunDuration,
    required this.moonDuration,
    required this.sunProgress,
    required this.moonProgress,
    required this.sunIcon,
    required this.moonIcon,
    this.sunPathColor = Colors.yellow,
    this.moonPathColor = Colors.blue,
    required this.theme,
  }): assert(0.0 <= sunProgress && sunProgress <= 1.0),
        assert(0.0 <= (moonProgress ?? 0.0) && (moonProgress ?? 0.0) <= 1.0),
        super(key: key);

  final bool initVisible;
  final double width;

  final int sunDuration;
  final int? moonDuration;
  final double sunProgress;
  final double? moonProgress;
  final ImageProvider sunIcon;
  final ImageProvider moonIcon;
  final Color sunPathColor;
  final Color moonPathColor;

  final ThemeData theme;

  @override
  State<StatefulWidget> createState() {
    return SunMoonPathViewState();
  }
}

class SunMoonPathViewState extends State<SunMoonPathView>
    with TickerProviderStateMixin {

  AnimationController? _sunMoonAnimController;
  Animation<double>? _sunProgressAnim;
  Animation<double>? _sunRotationAnim;
  Animation<double>? _moonProgressAnim;
  Animation<double>? _moonRotationAnim;

  _PathPainter? _pathPainter;
  _DividerPainter? _dividerPainter;
  _ShadowPainter? _shadowPainter;

  @override
  void initState() {
    super.initState();

    int totalDuration = max(widget.sunDuration, widget.moonDuration ?? 0);
    _sunMoonAnimController = AnimationController(
        duration: Duration(milliseconds: totalDuration),
        vsync: this
    );
    _sunProgressAnim = Tween(
        begin: 0.0,
        end: widget.sunProgress
    ).animate(
        CurvedAnimation(
          parent: _sunMoonAnimController!,
          curve: Interval(0.0, 1.0 * widget.sunDuration / totalDuration,
            curve: Curves.easeInOutQuint,
          ),
        )
    );
    _sunRotationAnim = Tween(
        begin: 0.0,
        end: widget.sunProgress == 0 ? 0.0 : max(
            1.0,
            (widget.sunProgress * MAX_ROTATION).toInt().toDouble()
        )
    ).animate(
        CurvedAnimation(
          parent: _sunMoonAnimController!,
          curve: Interval(0.0, 1.0 * widget.sunDuration / totalDuration,
            curve: Curves.easeInOutQuint,
          ),
        )
    );
    if (widget.moonDuration != null && widget.moonProgress != null) {
      _moonProgressAnim = Tween(
          begin: 0.0,
          end: widget.moonProgress!
      ).animate(
          CurvedAnimation(
            parent: _sunMoonAnimController!,
            curve: Interval(0.0, 1.0 * widget.moonDuration! / totalDuration,
              curve: Curves.easeInOutQuint,
            ),
          )
      );
      _moonRotationAnim = Tween(
          begin: 0.0,
          end: widget.moonProgress! == 0 ? 0.0 : max(
              1.0,
              (widget.moonProgress! * MAX_ROTATION).toInt().toDouble()
          )
      ).animate(
          CurvedAnimation(
            parent: _sunMoonAnimController!,
            curve: Interval(0.0, 1.0 * widget.moonDuration! / totalDuration,
              curve: Curves.easeInOutQuint,
            ),
          )
      );
    }

    if (widget.initVisible) {
      _sunMoonAnimController!.forward(from: 1.0);
    }

    _pathPainter = _PathPainter(
      _sunMoonAnimController!,
      _sunProgressAnim!,
      widget.sunPathColor,
      _moonProgressAnim,
      widget.moonPathColor,
    );
    _dividerPainter = _DividerPainter(widget.sunPathColor);
    _shadowPainter = _ShadowPainter(
      _sunMoonAnimController!,
      _sunProgressAnim!,
      _moonProgressAnim,
      widget.sunPathColor,
      widget.moonPathColor,
      widget.theme.cardColor,
    );
  }

  @override
  void dispose() {
    _sunMoonAnimController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SunMoonPathView oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _pathPainter = _PathPainter(
        _sunMoonAnimController!,
        _sunProgressAnim!,
        widget.sunPathColor,
        _moonProgressAnim,
        widget.moonPathColor,
      );
      _dividerPainter = _DividerPainter(widget.sunPathColor);
      _shadowPainter = _ShadowPainter(
        _sunMoonAnimController!,
        _sunProgressAnim!,
        _moonProgressAnim,
        widget.sunPathColor,
        widget.moonPathColor,
        widget.theme.cardColor,
      );
    });
  }

  void executeAnimations({double from = 0.0}) {
    if (!widget.initVisible) {
      _sunMoonAnimController?.forward(from: from);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _shadowPainter,
        ),
      ),
      RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _dividerPainter,
        ),
      ),
      RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _pathPainter,
        ),
      )
    ];

    if (_moonProgressAnim != null) {
      children.add(
        _getIconWidget(widget.moonIcon, _moonProgressAnim!, _moonRotationAnim!)
      );
    }
    children.add(
        _getIconWidget(widget.sunIcon, _sunProgressAnim!, _sunRotationAnim!)
    );

    return Stack(children: children);
  }

  Widget _getIconWidget(
      ImageProvider iconProvider,
      Animation<double> progressAnim,
      Animation<double> rotationAnim) {
    return AnimatedBuilder(
      animation: _sunMoonAnimController!,
      child: Image(
        image: iconProvider,
        width: ICON_SIZE,
        height: ICON_SIZE,
      ),
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: _getIconPosition(
              Size(widget.width, widget.width / 2.0),
              widget.width / 2.0,
              progressAnim.value
          ) - Offset(
              ICON_SIZE / 2.0,
              ICON_SIZE / 2.0
          ),
          child: Transform.rotate(
            angle: _toRadians(rotationAnim.value * 360.0),
            child: child,
          ),
        );
      }
    );
  }
}

class _PathPainter extends CustomPainter {

  _PathPainter(
      AnimationController controller,
      this._sunProgressAnim,
      this._sunPathColor,
      this._moonProgressAnim,
      this._moonPathColor): super(repaint: controller);

  final _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Animation<double> _sunProgressAnim;
  final Color _sunPathColor;
  Animation<double>? _moonProgressAnim;
  final Color _moonPathColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.0;
    final arcRect = Rect.fromLTWH(0, 0, 2 * radius, 2 * radius);

    // moon path.
    if (_moonProgressAnim != null) {
      _paint.strokeWidth = PATH_WIDTH;
      _paint.color = _moonPathColor;
      canvas.drawArc(
          arcRect,
          _toRadians(180),
          _toRadians(180 * _ensureProgressInBound(_moonProgressAnim!.value)),
          false,
          _paint
      );
    }

    // sun path.
    _paint.strokeWidth = PATH_WIDTH;
    _paint.color = _sunPathColor;
    canvas.drawArc(
        arcRect,
        _toRadians(180),
        _toRadians(180 * _ensureProgressInBound(_sunProgressAnim.value)),
        false,
        _paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _DividerPainter extends CustomPainter {

  _DividerPainter(this._sunPathColor): super();

  final _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Color _sunPathColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.0;
    final arcRect = Rect.fromLTWH(0, 0, 2 * radius, 2 * radius);

    // divider.
    _paint.strokeWidth = DIVIDER_WIDTH;
    _paint.color = _sunPathColor.withAlpha(DIVIDER_ALPHA);
    canvas.drawDashLine(
        Offset(0, radius),
        Offset(size.width, radius),
        5.0,
        5.0,
        _paint
    );
    canvas.drawDashArc(
        arcRect,
        _toRadians(180),
        _toRadians(180),
        5.0,
        5.0,
        _paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _ShadowPainter extends CustomPainter {

  _ShadowPainter(
      AnimationController controller,
      this._sunProgressAnim,
      this._moonProgressAnim,
      this._sunPathColor,
      this._moonPathColor,
      this._backgroundColor): super(repaint: controller);

  final _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Animation<double> _sunProgressAnim;
  Animation<double>? _moonProgressAnim;
  final Color _sunPathColor;
  final Color _moonPathColor;
  final Color _backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.0;
    final arcRect = Rect.fromLTWH(0, 0, 2 * radius, 2 * radius);
    canvas.clipRect(Rect.fromLTWH(0, 0, 2 * radius, radius));

    final _shadowColorX1 = Color.alphaBlend(
        (_moonProgressAnim != null
            && _sunProgressAnim.value > _moonProgressAnim!.value
            ? _sunPathColor : _moonPathColor).withAlpha(SHADOW_ALPHA),
        _backgroundColor
    );
    final _shadowColorX2 = Color.alphaBlend(
        _sunPathColor.withAlpha(SHADOW_ALPHA),
        _shadowColorX1
    );

    // shadow.
    // x1.
    if (_moonProgressAnim == null
        || _sunProgressAnim.value != _moonProgressAnim!.value) {
      _paint.color = Colors.black;
      _paint.style = PaintingStyle.fill;
      _paint.shader = ui.Gradient.linear(
        Offset(0.0, 0.0),
        Offset(0.0, radius),
        [_shadowColorX1, _backgroundColor],
      );

      double maxProgress = max(
          _sunProgressAnim.value,
          _moonProgressAnim?.value ?? 0.0
      );
      canvas.drawArc(
          arcRect,
          _toRadians(180 - maxProgress * 180),
          _toRadians(maxProgress * 180 * 2),
          false,
          _paint
      );
    }

    // x2.
    if (_moonProgressAnim != null) {
      _paint.shader = ui.Gradient.linear(
        Offset(0.0, 0.0),
        Offset(0.0, radius),
        [_shadowColorX2, _backgroundColor],
      );

      double minProgress = min(_sunProgressAnim.value, _moonProgressAnim!.value);
      canvas.drawArc(
          arcRect,
          _toRadians(180 - minProgress * 180),
          _toRadians(minProgress * 180 * 2),
          false,
          _paint
      );
    }

    _paint.shader = null;
    _paint.style = PaintingStyle.stroke;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

extension CanvasExt on Canvas {

  void drawDashLine(
      Offset p1,
      Offset p2,
      double dashWidth,
      double spaceWidth,
      Paint paint) {
    assert(dashWidth > 0);
    assert(spaceWidth > 0);

    double radians;

    if (p1.dx == p2.dx) {
      radians = (p1.dy < p2.dy) ? pi / 2 : pi / -2;
    } else {
      radians = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    }

    this.save();
    this.translate(p1.dx, p1.dy);
    this.rotate(radians);

    var matrix = Matrix4.identity();
    matrix.translate(p1.dx, p1.dy);
    matrix.rotateZ(radians);
    matrix.invert();

    var endPoint = MatrixUtils.transformPoint(matrix, p2);

    double tmp = 0;
    double length = endPoint.dx;
    double delta;

    while (tmp < length) {
      delta = (tmp + dashWidth < length) ? dashWidth : length - tmp;
      this.drawLine(Offset(tmp, 0), Offset(tmp + delta, 0), paint);
      if (tmp + delta >= length) {
        break;
      }

      tmp = tmp + dashWidth + spaceWidth < length
          ? (tmp + dashWidth + spaceWidth)
          : length;
    }

    this.restore();
  }

  void drawDashArc(
      Rect rect,
      double startAngle,
      double sweepAngle,
      double dashWidth,
      double spaceWidth,
      Paint paint) {
    assert(rect.width == rect.height);
    assert(dashWidth > 0);
    assert(spaceWidth > 0);

    double dashDeltaRadians = dashWidth / (rect.width / 2.0);
    double spaceDeltaRadians = spaceWidth / (rect.width / 2.0);

    for (
    double r = startAngle;
    r < startAngle + sweepAngle;
    r += dashDeltaRadians + spaceDeltaRadians
    ) {
      drawArc(rect, r, dashDeltaRadians, false, paint);
    }
  }
}

double _toRadians(double degrees) {
  return degrees * pi / 180.0;
}

double _toDegrees(double radians) {
  return radians * 180.0 / pi;
}

double _ensureProgressInBound(double progress) {
  progress = max(0.0, progress);
  progress = min(1.0, progress);
  return progress;
}

Offset _getIconPosition(Size size, double radius, double progress) {
  progress = _ensureProgressInBound(progress);
  double radians = _toRadians(180.0 * progress);
  double h = radius * sin(radians);
  double x = radius * cos(radians);

  return Offset(
      size.width / 2.0 - x,
      radius - h
  );
}