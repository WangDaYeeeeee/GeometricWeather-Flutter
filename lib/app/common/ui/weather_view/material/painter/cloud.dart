import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';

enum CloudType {
  CLOUD_DAY,
  CLOUD_NIGHT,
  CLOUDY_DAY,
  CLOUDY_NIGHT,
  THUNDER,
  FOG,
  HAZE
}

class _Cloud {

  double _initCX;
  double _initCY;

  double centerX;
  double centerY;

  double radius;
  double initRadius;
  double scaleRatio;
  double moveFactor;

  Color color;
  double alpha;

  int duration;
  int progress;

  _Cloud(
      double centerX, double centerY,
      double radius, double scaleRatio, double moveFactor,
      Color color, double alpha,
      int duration, int initProgress
  ) {

    _initCX = centerX;
    _initCY = centerY;

    this.centerX = centerX;
    this.centerY = centerY;

    this.initRadius = radius;
    this.scaleRatio = scaleRatio;
    this.moveFactor = moveFactor;

    this.color = color;
    this.alpha = alpha;

    this.duration = duration;
    this.progress = initProgress % duration;

    _computeRadius(duration, progress);
  }

  void move(int interval, double rotation2D, double rotation3D) {
    centerX = _initCX + sin(rotation2D * pi / 180.0) * 0.40 * radius * moveFactor;
    centerY = _initCY - sin(rotation3D * pi / 180.0) * 0.50 * radius * moveFactor;
    progress = (progress + interval) % duration;
    _computeRadius(duration, progress);
  }

  void _computeRadius(int duration, int progress) {
    if (progress < 0.5 * duration) {
      radius = initRadius * (1 + (scaleRatio - 1) * progress / 0.5 / duration);
    } else {
      radius = initRadius * (scaleRatio - (scaleRatio - 1) * (progress - 0.5 * duration) / 0.5 / duration);
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
      Color color,
      int duration, int initProgress) {
    this.centerX = centerX;
    this.centerY = centerY;

    this.radius =  radius * (0.7 + 0.3 * new Random().nextDouble());

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
    this.r = 81;
    this.g = 67;
    this.b = 108;
    _init();
    _computeFrame();
  }

  void _init() {
    _progress = 0;
    _duration = 300;
    _delay = new Random().nextInt(5000) + 2000;
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

class CloudPainter extends MaterialWeatherPainter {

  CloudPainter(this._type, Listenable repaint) : super(repaint) {

    _paint = new Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    _random = Random();

    _thunder = _type == CloudType.THUNDER ? _Thunder() : null;
  }

  CloudType _type;
  Paint _paint;
  Random _random;

  List<_Cloud> _clouds;
  List<_Star> _stars;
  _Thunder _thunder;

  Size _size;

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureElements(size);

    for (_Cloud c in _clouds) {
      c.move(intervalInMilli, rotation2D, rotation3D);
    }
    for (_Star s in _stars) {
      s.shine(intervalInMilli);
    }
    if (_thunder != null) {
      _thunder.shine(intervalInMilli);
    }

    if (scrollRate < 1) {
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
      for (_Star s in _stars) {
        _paint.color = s.color.withAlpha(((1 - scrollRate) * s.alpha * 255).toInt());
        canvas.drawCircle(Offset(s.centerX, s.centerY), s.radius, _paint);
      }
      for (_Cloud c in _clouds) {
        _paint.color = c.color.withAlpha(((1 - scrollRate) * c.alpha * 255).toInt());
        canvas.drawCircle(Offset(c.centerX, c.centerY), c.radius, _paint);
      }
    }
  }

  void _ensureElements(Size size) {
    if (_size != null && _size == size) {
      return;
    }
    _size = size;

    switch(_type) {
      case CloudType.CLOUD_DAY:
      case CloudType.CLOUD_NIGHT: {
        var cloudColor = _type == CloudType.CLOUD_DAY 
            ? Color.fromARGB(255, 203, 245, 255)
            : Color.fromARGB(255, 151, 168, 202);
        var cloudAlphas = [0.40, 0.10];

        _clouds = [
          _Cloud(
            size.width * 0.1529,
            size.width * 0.1529 * 0.5568 + size.width * 0.050,
            size.width * 0.2649, 1.20, _getRandomFactor(1.5, 1.8),
            cloudColor, cloudAlphas[0],
            7000, 0
          ),
          _Cloud(
            size.width * 0.4793,
            size.width * 0.4793 * 0.2185 + size.width * 0.050,
            size.width * 0.2426, 1.20, _getRandomFactor(1.5, 1.8),
            cloudColor, cloudAlphas[0],
            7000, 1500
          ),
          _Cloud(
            size.width * 0.8531,
            size.width * 0.8531 * 0.1286 + size.width * 0.050,
            size.width * 0.2970, 1.20, _getRandomFactor(1.5, 1.8),
            cloudColor, cloudAlphas[0],
            7000, 0
          ),
          _Cloud(
            size.width * 0.0551,
            size.width * 0.0551 * 2.8600 + size.width * 0.050,
            size.width * 0.4125, 1.15, _getRandomFactor(1.3, 1.5),
            cloudColor, cloudAlphas[1],
            7000, 2000
          ),
          _Cloud(
            size.width * 0.4928,
            size.width * 0.4928 * 0.3897 + size.width * 0.050,
            size.width * 0.3521, 1.15, _getRandomFactor(1.3, 1.5),
            cloudColor, cloudAlphas[1],
            7000, 3500
          ),
          _Cloud(
            size.width * 1.0499,
            size.width * 1.0499 * 0.1875 + size.width * 0.050,
            size.width * 0.4186, 1.15, _getRandomFactor(1.3, 1.5),
            cloudColor, cloudAlphas[1],
            7000, 2000
          )
        ];
        break;
      }
      case CloudType.CLOUDY_DAY:
      case CloudType.CLOUDY_NIGHT:
      case CloudType.THUNDER: {
        var cloudColors = _type == CloudType.CLOUDY_DAY ? [
          Color.fromARGB(255, 107, 129, 143),
          Color.fromARGB(255, 117, 135, 147)
        ] : (_type == CloudType.CLOUDY_NIGHT ? [
          Color.fromARGB(255, 16, 32, 39),
          Color.fromARGB(255, 16, 32, 39)
        ] : [
          Color.fromARGB(255, 43, 30, 66),
          Color.fromARGB(255, 53, 38, 78)
        ]);
        var cloudAlphas = _type == CloudType.CLOUDY_DAY ? [0.7, 0.7]
            : (_type == CloudType.CLOUDY_NIGHT ? [0.3, 0.3]
            : [0.8, 0.8]);

        _clouds = [
          _Cloud(
            size.width * 1.0699,
            size.width * 1.1900 * 0.2286 + size.width * 0.11,
            size.width * 0.4694 * 0.9/*0.6277*/, 1.10, _getRandomFactor(1.3, 1.8),
            cloudColors[0], cloudAlphas[0],
            7000, 2000
          ),
          _Cloud(
            size.width * 0.4866,
            size.width * 0.4866 * 0.6064 + size.width * 0.085,
            size.width * 0.3946 * 0.9/*0.5277*/, 1.10, _getRandomFactor(1.3, 1.8),
            cloudColors[0], cloudAlphas[0],
            7000, 3500
          ),
          _Cloud(
            size.width * 0.0351,
            size.width * 0.1701 * 1.4327 + size.width * 0.11,
            size.width * 0.4627 * 0.9/*0.6188*/, 1.10, _getRandomFactor(1.3, 1.8),
            cloudColors[0], cloudAlphas[0],
            7000, 2000
          ),
          _Cloud(
            size.width * 0.8831,
            size.width * 1.0270 * 0.1671 + size.width * 0.07,
            size.width * 0.3238 * 0.9/*0.4330*/, 1.15, _getRandomFactor(1.6, 2),
            cloudColors[1], cloudAlphas[1],
            7000, 0
          ),
          _Cloud(
            size.width * 0.4663,
            size.width * 0.4663 * 0.3520 + size.width * 0.05,
            size.width * 0.2906 * 0.9/*0.3886*/, 1.15, _getRandomFactor(1.6, 2),
            cloudColors[1], cloudAlphas[1],
            7000, 1500
          ),
          _Cloud(
            size.width * 0.1229,
            size.width * 0.0234 * 5.7648 + size.width * 0.07,
            size.width * 0.2972 * 0.9/*0.3975*/, 1.15, _getRandomFactor(1.6, 2),
            cloudColors[1], cloudAlphas[1],
            7000, 0
          )
        ];
        break;
      }
      case CloudType.FOG:
      case CloudType.HAZE:
      {
        var cloudColors = _type == CloudType.FOG ? [
          Color.fromARGB(255, 85, 99, 110),
          Color.fromARGB(255, 91, 104, 114),
          Color.fromARGB(255, 99, 113, 123)
        ] : [
          Color.fromARGB(255, 57, 57, 57),
          Color.fromARGB(255, 48, 48, 48),
          Color.fromARGB(255, 44, 44, 44)
        ];

        var cloudAlphas = [0.8, 0.8, 0.8];

        _clouds = [
          _Cloud(
            size.width * 0.9388,
            size.width * 0.9388 * 0.6101 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1, 1.8),
            cloudColors[0], cloudAlphas[0],
            7000, 2000
          ),
          _Cloud(
            size.width * 0.4833,
            size.width * 0.4833 * 1.0727 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1, 1.8),
            cloudColors[0], cloudAlphas[0],
            7000, 3500
          ),
          _Cloud(
            size.width * 0.0388,
            size.width * 0.0388 * 14.3333 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1, 1.8),
            cloudColors[0], cloudAlphas[0],
            7000, 1700
          ),
          _Cloud(
            size.width * 1.0000,
            size.width * 1.0000 * 0.3046 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1.4, 2.2),
            cloudColors[1], cloudAlphas[1],
            7000, 0
          ),
          _Cloud(
            size.width * 0.5444,
            size.width * 0.5444 * 0.4880 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1.4, 2.2),
            cloudColors[1], cloudAlphas[1],
            7000, 1500
          ),
          _Cloud(
            size.width * 0.1000,
            size.width * 0.1000 * 3.0462 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1.4, 2.2),
            cloudColors[1], cloudAlphas[1],
            7000, 300
          ),
          _Cloud(
            size.width * 0.9250,
            size.width * 0.9250 * 0.0249 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1.8, 2.6),
            cloudColors[2], cloudAlphas[2],
            7000, 0
          ),
          _Cloud(
            size.width * 0.4694,
            size.width * 0.4694 * 0.0489 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1.8, 2.6),
            cloudColors[2], cloudAlphas[2],
            7000, 1200
          ),
          _Cloud(
            size.width * 0.0250,
            size.width * 0.0250 * 0.6820 + size.width * 0.1500,
            size.width * 0.3166, 1.15, _getRandomFactor(1.8, 2.6),
            cloudColors[2], cloudAlphas[2],
            7000, 700
          )
        ];
        break;
      }
      default:
        _clouds = [];
        break;
    }
    
    if (_type != CloudType.CLOUD_NIGHT) {
      _stars = [];
    } else {
      _stars = [];
      Random r = new Random();
      
      int canvasSize = sqrt(pow(size.width, 2) + pow(size.height, 2)).toInt();
      int width = (1.0 * canvasSize).toInt();
      int height = ((canvasSize - size.height) * 0.5 + size.width * 1.1111).toInt();
      double radius = 0.0028 * size.width;
      Color color = Color.fromARGB(255, 255, 255, 255);

      for (int i = 0; i < 30; i ++) {
        double x = r.nextInt(width) - 0.5 * (canvasSize - size.width);
        double y = r.nextInt(height) - 0.5 * (canvasSize - size.height);
        bool newPosition = true;

        for (int j = 0; j < i; j ++) {
          if (_stars[j].centerX == x && _stars[j].centerY == y) {
            newPosition = false;
            break;
          }
        }
        if (newPosition) {
          int duration = 1500 + r.nextInt(3) * 500;
          _stars.add(
            _Star(x, y, radius, color, duration, r.nextInt(duration))
          );
        } else {
          i --;
        }
      }
    }
  }

  _getRandomFactor(double from, double to) {
    return from + _random.nextDouble() % (to - from);
  }
}

const cloudDayGradient = LinearGradient(
    colors: [
      Color(0xFF00a5d9),
      Color(0xFF008cff)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const cloudNightGradient = LinearGradient(
    colors: [
      Color(0xFF222d43),
      Color(0xFF0e0e2d)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const cloudyDayGradient = LinearGradient(
    colors: [
      Color(0xFF607988),
      Color(0xFF2d5879)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const cloudyNightGradient = LinearGradient(
    colors: [
      Color(0xFF263238),
      Color(0xFF080d10)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const thunderGradient = LinearGradient(
    colors: [
      Color(0xFF231739),
      Color(0xFF06040a)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const fogGradient = LinearGradient(
    colors: [
      Color(0xFF4f5d68),
      Color(0xFF1c232d)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);

const hazeGradient = LinearGradient(
    colors: [
      Color(0xFF424242),
      Color(0xFF0d0606)
    ],
    begin: AlignmentDirectional.center,
    end: AlignmentDirectional.bottomCenter
);