import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/_utils.dart';

class _Meteor {

  double x;
  double y;
  double width;
  double height;

  Rect rectF;
  double speed;

  Color color;
  double scale;

  int _viewWidth;
  int _viewHeight;
  int _canvasSize;

  double _maxHeight;
  double _minHeight;

  _Meteor(int viewWidth, int viewHeight, Color color, double scale) { // 1, 0.7, 0.4
    _viewWidth = viewWidth;
    _viewHeight = viewHeight;

    _canvasSize = pow(viewWidth * viewWidth + viewHeight * viewHeight, 0.5).toInt();

    this.width = viewWidth * 0.0088 * scale;

    this.rectF = Rect.zero;
    this.speed = viewWidth / 200.0;
    this.color = color;
    this.scale = scale;

    this._maxHeight = 1.1 * viewWidth / cos(60.0 * pi / 180.0);
    this._minHeight = _maxHeight * 0.7;

    _init(true);
  }

  void _init(bool firstTime) {
    Random r = new Random();

    x = r.nextInt(_canvasSize).toDouble();
    if (firstTime) {
      y = r.nextInt(_canvasSize) - _maxHeight - _canvasSize;
    } else {
      y = -_maxHeight;
    }
    height = _minHeight + r.nextDouble() * (_maxHeight - _minHeight);

    _buildRect();
  }

  void _buildRect() {
    double x = this.x - (_canvasSize - _viewWidth) * 0.5;
    double y = this.y - (_canvasSize - _viewHeight) * 0.5;
    rectF = Rect.fromLTWH(x, y, width, height);
  }

  void move(int interval, double deltaRotation3D) {
    x -= speed * interval * 5
        * sin(deltaRotation3D * pi / 180.0) * cos(60 * pi / 180.0);
    y += speed * interval * (pow(scale, 0.5)
            - 5 * sin(deltaRotation3D * pi / 180.0) * sin(60 * pi / 180.0));

    if (y >= _canvasSize) {
      _init(false);
    } else {
      _buildRect();
    }
  }
}

class _Star {

  double centerX;
  double centerY;
  double radius;

  Color color;
  double alpha;

  int duration;
  int progress;

  _Star(double centerX, double centerY, double radius,
      Color color, int duration, int initProgress) {
    this.centerX = centerX;
    this.centerY = centerY;

    this.radius = radius * (0.7 + 0.3 * new Random().nextDouble());

    this.color = color;

    this.duration = duration;
    this.progress = initProgress % duration;

    _computeAlpha(duration, progress);
  }

  void shine(int interval) {
    progress = (progress + interval) % duration;
    _computeAlpha(duration, progress);
  }

  void _computeAlpha(int duration, int progress) {
    if (progress < 0.5 * duration) {
      alpha = progress / 0.5 / duration;
    } else {
      alpha = 1 - (progress - 0.5 * duration) / 0.5 / duration;
    }
    alpha = alpha * 0.66 + 0.33;
  }
}

class MeteorShowerPainter extends MaterialWeatherPainter {

  Paint _paint;
  List<_Meteor> _meteors;
  List<_Star> _stars;

  double _lastRotation3D;
  static const INITIAL_ROTATION_3D = 1000.0;

  Size _size;

  MeteorShowerPainter(Listenable repaint) : super(repaint) {
    _paint = new Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    _lastRotation3D = INITIAL_ROTATION_3D;
  }

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureElements(size);

    for (_Meteor m in _meteors) {
      m.move(intervalInMilli, _lastRotation3D == INITIAL_ROTATION_3D ? 0 : rotation3D - _lastRotation3D);
    }
    for (_Star s in _stars) {
      s.shine(intervalInMilli);
    }
    _lastRotation3D = rotation3D;

    if (scrollRate < 1) {
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(toRadians(rotation2D));
      canvas.translate(-size.width / 2, -size.height / 2);

      for (_Star s in _stars) {
        _paint.color = s.color.withAlpha(((1 - scrollRate) * s.alpha * 255).toInt());
        _paint.strokeWidth = s.radius * 2;
        canvas.drawPoints(PointMode.points, [Offset(s.centerX, s.centerY)], _paint);
      }

      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(toRadians(60));
      canvas.translate(-size.width / 2, -size.height / 2);
      for (_Meteor m in _meteors) {
        _paint.color = m.color.withAlpha(((1 - scrollRate) * 255).toInt());
        _paint.strokeWidth = m.rectF.width;
        canvas.drawLine(
            m.rectF.topCenter,
            m.rectF.bottomCenter,
            _paint
        );
      }
    }
  }

  void _ensureElements(Size size) {
    if (_size != null && _size == size) {
      return;
    }
    _size = size;

    Random random = new Random();

    var colors = [
      Color.fromARGB(255, 210, 247, 255),
      Color.fromARGB(255, 208, 233, 255),
      Color.fromARGB(255, 175, 201, 228),
      Color.fromARGB(255, 164, 194, 220),
      Color.fromARGB(255, 97, 171, 220),
      Color.fromARGB(255, 74, 141, 193),
      Color.fromARGB(255, 54, 66, 119),
      Color.fromARGB(255, 34, 48, 74),
      Color.fromARGB(255, 236, 234, 213),
      Color.fromARGB(255, 240, 220, 151)
    ];

    _meteors = [];
    for (int i = 0; i < 15; i ++) {
      _meteors.add(
        _Meteor(
            size.width.toInt(),
            size.height.toInt(),
            colors[random.nextInt(colors.length)],
            random.nextDouble()
        )
      );
    }

    _stars = [];
    int canvasSize = pow(pow(size.width, 2) + pow(size.height, 2), 0.5).toInt();
    int width = canvasSize;
    int height = ((canvasSize - size.height) * 0.5 + size.width * 1.1111).toInt();
    double radius = 0.0028 * size.width;
    for (int i = 0; i < 100; i ++) {
      int x = (random.nextInt(width) - 0.5 * (canvasSize - size.width)).toInt();
      int y = (random.nextInt(height) - 0.5 * (canvasSize - size.height)).toInt();

      bool newPosition = true;
      for (int j = 0; j < i; j ++) {
        if (_stars[j].centerX == x && _stars[j].centerY == y) {
          newPosition = false;
          break;
        }
      }
      if (newPosition) {
        int duration = 1500 + random.nextInt(3) * 500;
        _stars.add(
          _Star(
              x.toDouble(),
              y.toDouble(),
              radius,
              colors[random.nextInt(colors.length)],
              duration,
              random.nextInt(duration)
          )
        );
      } else {
        i --;
      }
    }
  }
}

final metroShowerGradient = MaterialBackgroundGradiant(
    Color(0xFF141b2c),
    Color(0xFF000000)
);