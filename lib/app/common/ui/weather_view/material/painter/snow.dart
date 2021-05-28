import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/_utils.dart';

class Snow {

  double _cx;
  double _cy;

  double centerX;
  double centerY;
  double radius;

  Color color;
  double scale;

  double speedX;
  double speedY;

  int _viewWidth;
  int _viewHeight;

  int _canvasSize;

  Snow(int viewWidth, int viewHeight, Color color, double scale) {
    _viewWidth = viewWidth;
    _viewHeight = viewHeight;

    _canvasSize = pow(viewWidth * viewWidth + viewHeight * viewHeight, 0.5).toInt();

    this.radius = viewWidth * 0.0213 * scale;

    this.color = color;
    this.scale = scale;

    this.speedY = viewWidth / 350;

    _init(true);
  }

  void _init(bool firstTime) {
    Random r = new Random();
    _cx = r.nextInt(_canvasSize).toDouble();
    if (firstTime) {
      _cy = (r.nextInt((_canvasSize - radius).toInt()) - _canvasSize).toDouble();
    } else {
      _cy = -radius;
    }
    speedX = (r.nextDouble() * speedY * (r.nextBool() ? 1 : -1)).toDouble();

    _computeCenterPosition();
  }

  void _computeCenterPosition() {
    centerX = _cx - (_canvasSize - _viewWidth) * 0.5;
    centerY = _cy - (_canvasSize - _viewHeight) * 0.5;
  }

  void move(int interval, double deltaRotation3D) {
    _cx += speedX * interval * pow(scale, 1.5);
    _cy += speedY * interval * (pow(scale, 1.5) - 5 * sin(deltaRotation3D * pi / 180.0));

    if (centerY >= _canvasSize) {
      _init(false);
    } else {
      _computeCenterPosition();
    }
  }
}

class SnowPainter extends MaterialWeatherPainter {

  SnowPainter(this._daylight, Listenable repaint) : super(repaint) {
    _paint = new Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    _lastRotation3D = INITIAL_ROTATION_3D;
  }

  final bool _daylight;

  Paint _paint;
  List<Snow> _snows;

  double _lastRotation3D;
  static const INITIAL_ROTATION_3D = 1000.0;

  Size _size;

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureSnows(size);

    for (Snow s in _snows) {
      s.move(intervalInMilli, _lastRotation3D == INITIAL_ROTATION_3D ? 0 : rotation3D - _lastRotation3D);
    }
    _lastRotation3D = rotation3D;

    if (scrollRate < 1) {
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(toRadians(rotation2D));
      canvas.translate(-size.width / 2, -size.height / 2);

      for (Snow s in _snows) {
        _paint.color = s.color.withAlpha(((1 - scrollRate) * 255).toInt());
        canvas.drawCircle(Offset(s.centerX, s.centerY), s.radius, _paint);
      }
    }
  }

  void _ensureSnows(Size size) {
    if (_size != null && _size == size) {
      return;
    }
    _size = size;

    var colors = _daylight ? [
      Color.fromARGB(255, 128, 197, 255),
      Color.fromARGB(255, 185, 222, 255),
      Color.fromARGB(255, 255, 255, 255)
    ] : [
      Color.fromARGB(255, 40, 102, 155),
      Color.fromARGB(255, 99, 144, 182),
      Color.fromARGB(255, 255, 255, 255)
    ];
    var scales = [0.6, 0.8, 1.0];

    _snows = [];
    for (int i = 0; i < 51; i ++) {
      _snows.add(
        Snow(
          size.width.toInt(),
          size.height.toInt(),
          colors[i < 17 ? 0 : (i < 34 ? 1 : 2)],
          scales[i < 17 ? 0 : (i < 34 ? 1 : 2)]
        )
      );
    }
  }
}

const snowDayGradient = LinearGradient(
    colors: [
      Color(0xFF68baff),
      Color(0xFF0066ff)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const snowNightGradient = LinearGradient(
    colors: [
      Color(0xFF1a5b92),
      Color(0xFF2c4253)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);