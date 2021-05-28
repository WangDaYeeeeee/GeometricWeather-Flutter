import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/_utils.dart';

enum RainType {
  RAIN_DAY,
  RAIN_NIGHT,
  THUNDERSTORM,
  SLEET_DAY,
  SLEET_NIGHT
}

class _Rain {

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

  _Rain(int viewWidth, int viewHeight, Color color, double scale) {
    _viewWidth = viewWidth;
    _viewHeight = viewHeight;

    _canvasSize = pow(viewWidth * viewWidth + viewHeight * viewHeight, 0.5).toInt();

    this.rect = Rect.zero;
    this.speed = viewWidth / 175;
    this.color = color;
    this.scale = scale;

    this._maxWidth = 0.0111 * viewWidth;
    this._minWidth = 0.0089 * viewWidth;
    this._maxHeight = _maxWidth * 18;
    this._minHeight = _minWidth * 14;

    _init(true);
  }

  void _init(bool firstTime) {
    Random r = new Random();
    x = r.nextInt(_canvasSize).toDouble();
    if (firstTime) {
      y = (r.nextInt((_canvasSize - _maxHeight).toInt()) - _canvasSize).toDouble();
    } else {
      y = -_maxHeight * (1 + 2 * r.nextDouble());
    }
    width = _minWidth + r.nextDouble() * (_maxWidth - _minWidth);
    height = _minHeight + r.nextDouble() * (_maxHeight - _minHeight);

    _buildRect();
  }

  void _buildRect() {
    double x = this.x - (_canvasSize - _viewWidth) * 0.5;
    double y = this.y - (_canvasSize - _viewHeight) * 0.5;
    rect = Rect.fromLTWH(x, y, width * scale, height * scale);
  }

  void move(int interval, double deltaRotation3D) {
    y += speed * interval
        * (pow(scale, 1.5)
            - 5 * sin(deltaRotation3D * pi / 180.0) * cos(8 * pi / 180.0));
    x -= speed * interval
        * 5 * sin(deltaRotation3D * pi / 180.0) * sin(8 * pi / 180.0);

    if (y >= _canvasSize) {
      _init(false);
    } else {
      _buildRect();
    }
  }
}

class _Thunder {

  int r;
  int g;
  int b;
  double alpha;

  int _progress;
  int _duration;
  int _delay;

  _Thunder() {
    this.r = this.g = this. b = 255;
    _init();
    _computeFrame();
  }

  void _init() {
    _progress = 0;
    _duration = 300;
    _delay = new Random().nextInt(5000) + 3000;
  }

  void _computeFrame() {
    if (_progress < _duration) {
      if (_progress < 0.25 * _duration) {
        alpha = _progress / 0.25 / _duration;
      } else if (_progress < 0.5 * _duration) {
        alpha = 1 - (_progress - 0.25 * _duration) / 0.25 / _duration;
      } else if (_progress < 0.75 * _duration) {
        alpha = (_progress - 0.5 * _duration) / 0.25 / _duration;
      } else {
        alpha = 1 - (_progress - 0.75 * _duration) / 0.25 / _duration;
      }
    } else {
      alpha = 0;
    }
  }

  void shine(int interval) {
    _progress += interval;
    if (_progress > _duration + _delay) {
      _init();
    }
    _computeFrame();
  }
}

class RainPainter extends MaterialWeatherPainter {

  RainPainter(this._type, Listenable repaint) : super(repaint) {
    _paint = new Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    _lastRotation3D = INITIAL_ROTATION_3D;
  }

  final RainType _type;

  Paint _paint;
  List<_Rain> _rains;
  _Thunder _thunder;

  double _lastRotation3D;
  static const INITIAL_ROTATION_3D = 1000.0;

  Size _size;

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureElements(size);

    for (_Rain r in _rains) {
      r.move(intervalInMilli, _lastRotation3D == INITIAL_ROTATION_3D ? 0 : rotation3D - _lastRotation3D);
    }
    if (_thunder != null) {
      _thunder.shine(intervalInMilli);
    }
    _lastRotation3D = rotation3D;

    if (scrollRate < 1) {
      rotation2D += 8;
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(toRadians(rotation2D));
      canvas.translate(-size.width / 2, -size.height / 2);

      for (_Rain r in _rains) {
        _paint.color = r.color.withAlpha(((1 - scrollRate) * 255).toInt());
        canvas.drawRect(r.rect, _paint);
      }
      if (_thunder != null) {
        canvas.drawColor(
            Color.fromARGB(
                ((1 - scrollRate) * _thunder.alpha * 255).toInt(),
                _thunder.r,
                _thunder.g,
                _thunder.b
            ),
            BlendMode.srcOver
        );
      }
    }
  }

  void _ensureElements(Size size) {
    if (_size != null && _size == size) {
      return;
    }
    _size = size;

    int rainCount;
    List<Color> colors;
    var scales = [0.6, 0.8, 1.0];

    switch (_type) {
      case RainType.RAIN_DAY:
        rainCount = 51;
        _thunder = null;

        colors = [
          Color.fromARGB(255, 223, 179, 114),
          Color.fromARGB(255, 152, 175, 222),
          Color.fromARGB(255, 255, 255, 255)
        ];
      break;

      case RainType.RAIN_NIGHT:
        rainCount = 51;
        _thunder = null;

        colors = [
          Color.fromARGB(255, 182, 142, 82),
          Color.fromARGB(255, 88, 92, 113),
          Color.fromARGB(255, 255, 255, 255)
        ];
      break;

      case RainType.THUNDERSTORM:
        rainCount = 45;
        _thunder = new _Thunder();

        colors = [
          Color.fromARGB(255, 182, 142, 82),
          Color.fromARGB(255, 88, 92, 113),
          Color.fromARGB(255, 255, 255, 255)
        ];
        break;

      case RainType.SLEET_DAY:
        rainCount = 45;
        _thunder = null;

        colors = [
          Color.fromARGB(255, 128, 197, 255),
          Color.fromARGB(255, 185, 222, 255),
          Color.fromARGB(255, 255, 255, 255)
        ];
        break;

      case RainType.SLEET_NIGHT:
        rainCount = 45;
        _thunder = null;

        colors = [
          Color.fromARGB(255, 40, 102, 155),
          Color.fromARGB(255, 99, 144, 182),
          Color.fromARGB(255, 255, 255, 255)
        ];
        break;
    }

    _rains = [];
    for (int i = 0; i < rainCount; i ++) {
      _rains.add(
          _Rain(
              size.width.toInt(),
              size.height.toInt(),
              colors[i < (rainCount / 3) ? 0 : (i < (rainCount / 3 * 2) ? 1 : 2)],
              scales[i < (rainCount / 3) ? 0 : (i < (rainCount / 3 * 2) ? 1 : 2)]
          )
      );
    }
  }
}

const rainDayGradient = LinearGradient(
    colors: [
      Color(0xFF4097e7),
      Color(0xFF0061ff)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const rainNightGradient = LinearGradient(
    colors: [
      Color(0xFF264e8f),
      Color(0xFF252f60)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const sleetDayGradient = LinearGradient(
    colors: [
      Color(0xFF68baff),
      Color(0xFF0071ff)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const sleetNightGradient = LinearGradient(
    colors: [
      Color(0xFF1a5b92),
      Color(0xFF263f56)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const thunderstormGradient = LinearGradient(
    colors: [
      Color(0xFF2b1d45),
      Color(0xFF1a0c26)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);