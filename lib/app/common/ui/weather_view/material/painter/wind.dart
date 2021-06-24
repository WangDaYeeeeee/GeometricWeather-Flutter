import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/_utils.dart';

class Wind {

  double x;
  double y;
  double width;
  double height;

  Rect rect;
  double speed;

  Color color;
  double scale;

  int _viewWidth;
  int _viewHeight;

  int _canvasSize;

  double _maxWidth;
  double _minWidth;
  double _maxHeight;
  double _minHeight;

  Wind(int viewWidth, int viewHeight, Color color, double scale) {
    _viewWidth = viewWidth;
    _viewHeight = viewHeight;

    _canvasSize = pow(viewWidth * viewWidth + viewHeight * viewHeight, 0.5).toInt();

    this.rect = Rect.zero;
    this.speed = viewWidth / 100.0;
    this.color = color;
    this.scale = scale;

    this._maxHeight = 0.0111 * viewWidth;
    this._minHeight = 0.0093 * viewWidth;
    this._maxWidth = _maxHeight * 20;
    this._minWidth = _minHeight * 15;

    init(true);
  }

  void init(bool firstTime) {
    Random r = new Random();
    y = r.nextInt(_canvasSize).toDouble();
    if (firstTime) {
      x = (r.nextInt((_canvasSize - _maxHeight).toInt()) - _canvasSize).toDouble();
    } else {
      x = -_maxHeight;
    }
    width = _minWidth + r.nextDouble() * (_maxWidth - _minWidth);
    height = _minHeight + r.nextDouble() * (_maxHeight - _minHeight);

    buildRectF();
  }

  void buildRectF() {
    double x = this.x - (_canvasSize - _viewWidth) * 0.5;
    double y = this.y - (_canvasSize - _viewHeight) * 0.5;
    rect = Rect.fromLTWH(x, y, width * scale, height * scale);
  }

  void move(int interval, double deltaRotation3D) {
    x += speed * interval
        * (pow(scale, 1.5)
            + 5 * sin(deltaRotation3D * pi / 180.0) * cos(16 * pi / 180.0));
    y -= speed * interval
        * 5 * sin(deltaRotation3D * pi / 180.0) * sin(16 * pi / 180.0);

    if (x >= _canvasSize) {
      init(false);
    } else {
      buildRectF();
    }
  }
}

class WindPainter extends MaterialWeatherPainter {
  
  WindPainter(Listenable repaint) : super(repaint) {
    _paint = new Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    _lastRotation3D = INITIAL_ROTATION_3D;
  }

  Paint _paint;
  List<Wind> _winds;

  double _lastRotation3D;
  static const double INITIAL_ROTATION_3D = 1000;

  Size _size;
  
  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureElements(size);

    for (Wind w in _winds) {
      w.move(intervalInMilli, _lastRotation3D == INITIAL_ROTATION_3D ? 0 : rotation3D - _lastRotation3D);
    }
    _lastRotation3D = rotation3D;

    if (scrollRate < 1) {
      rotation2D -= 16;
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(toRadians(rotation2D));
      canvas.translate(-size.width / 2, -size.height / 2);

      for (Wind w in _winds) {
        _paint.color = w.color.withAlpha(((1 - scrollRate) * 255).toInt());
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                w.rect,
                Radius.circular(min(w.rect.width, w.rect.height) / 2.0)
            ),
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

    var colors = [
      Color.fromARGB(255, 240, 200, 148),
      Color.fromARGB(255, 237, 178, 100),
      Color.fromARGB(255, 209, 142, 54)
    ];
    var scales = [0.6, 0.8, 1.0];

    _winds = [];
    for (int i = 0; i < 51; i ++) {
      _winds.add(
          Wind(
              size.width.toInt(),
              size.height.toInt(),
              colors[i < 17 ? 0 : (i < 34 ? 1 : 2)],
              scales[i < 17 ? 0 : (i < 34 ? 1 : 2)]
          )
      );
    }
  }
}

final windGradient = MaterialBackgroundGradiant(
    Color(0xFFe99e3c),
    Color(0xFFff8300)
);