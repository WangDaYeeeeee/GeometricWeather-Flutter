import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/_utils.dart';

class _Hail {

  double _cx;
  double _cy;

  double centerX;
  double centerY;
  double size;
  double rotation;

  double speedRotation;
  double speedX;
  double speedY;

  Color color;
  double scale;

  int _viewWidth;
  int _viewHeight;

  int _canvasSize;

  _Hail(int viewWidth, int viewHeight, Color color, double scale) {
    _viewWidth = viewWidth;
    _viewHeight = viewHeight;

    _canvasSize = pow(viewWidth * viewWidth + viewHeight * viewHeight, 0.5).toInt();

    this.size = 0.0324 * viewWidth * 1.25;
    this.speedY = viewWidth / 200.0;
    this.color = color;
    this.scale = scale;

    _init(true);
  }

  void _init(bool firstTime) {
    Random r = new Random();
    _cx = r.nextInt(_canvasSize).toDouble();
    if (firstTime) {
      _cy = (r.nextInt((_canvasSize - size).toInt()) - _canvasSize).toDouble();
    } else {
      _cy = -size;
    }
    rotation = 360.0 * r.nextDouble();

    speedRotation = 360.0 / 500.0 * r.nextDouble();
    speedX = 0.75 * (r.nextDouble() * speedY * (r.nextBool() ? 1 : -1)).toDouble();
    _computeCenterPosition();
  }

  void _computeCenterPosition() {
    centerX = _cx - (_canvasSize - _viewWidth) * 0.5;
    centerY = _cy - (_canvasSize - _viewHeight) * 0.5;
  }

  void move(int interval, double deltaRotation3D) {
    _cx += speedX * interval * pow(scale, 1.5);
    _cy += speedY * interval * (pow(scale, 1.5) - 5 * sin(deltaRotation3D * pi / 180.0));
    rotation = (rotation + speedRotation * interval) % 360;

    if (_cy - size >= _canvasSize) {
      _init(false);
    } else {
      _computeCenterPosition();
    }
  }
}

class HailPainter extends MaterialWeatherPainter {

  Paint _paint;
  Path _path;
  List<_Hail> _hails;
  bool _daylight;

  double _lastRotation3D;
  static const INITIAL_ROTATION_3D = 1000.0;

  Size _size;

  HailPainter(this._daylight, Listenable repaint) : super(repaint) {
    _paint = new Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    _path = Path();

    _lastRotation3D = INITIAL_ROTATION_3D;
  }

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureHails(size);

    for (_Hail h in _hails) {
      h.move(intervalInMilli, _lastRotation3D == INITIAL_ROTATION_3D ? 0 : rotation3D - _lastRotation3D);
    }
    _lastRotation3D = rotation3D;

    if (scrollRate < 1) {
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(toRadians(rotation2D));
      canvas.translate(-size.width / 2, -size.height / 2);

      for (_Hail h in _hails) {
        canvas.translate(h.centerX, h.centerY);
        canvas.rotate(toRadians(h.rotation));

        _paint.color = h.color.withAlpha(((1 - scrollRate) * 255).toInt());
        canvas.drawRect(
            Rect.fromCenter(
                center: Offset(0, 0),
                width: h.size,
                height: h.size
            ),
            _paint
        );

        canvas.rotate(toRadians(-h.rotation));
        canvas.translate(-h.centerX, -h.centerY);
      }
    }
  }

  void _ensureHails(Size size) {
    if (_size != null && _size == size) {
      return;
    }
    _size = size;

    var colors = _daylight ? [
      Color.fromARGB(255, 101, 134, 203),
      Color.fromARGB(255, 152, 175, 222),
      Color.fromARGB(255, 255, 255, 255)
    ] : [
      Color.fromARGB(255, 64, 67, 85),
      Color.fromARGB(255, 127, 131, 154),
      Color.fromARGB(255, 255, 255, 255)
    ];
    var scales = [0.6, 0.8, 1.0];

    _hails = [];
    for (int i = 0; i < 51; i ++) {
      _hails.add(
        _Hail(
          size.width.toInt(),
          size.height.toInt(),
          colors[i < 17 ? 0 : (i < 34 ? 1 : 2)],
          scales[i < 17 ? 0 : (i < 34 ? 1 : 2)]
        )
      );
    }
  }
}

final hailDayGradient = MaterialBackgroundGradiant(
    Color(0xFF5074c1),
    Color(0xFF072a7c)
);

final hailNightGradient = MaterialBackgroundGradiant(
    Color(0xFF2a3445),
    Color(0xFF010110)
);