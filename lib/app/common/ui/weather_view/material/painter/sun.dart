import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/_utils.dart';

import '../mtrl_weather_view.dart';

class SunPainter extends MaterialWeatherPainter {

  static const SUN_COLOR = Color(0xFFfd5411);

  final Paint _paint = new Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  final List<double> _angles = [0, 0, 0];
  final List<double> _unitSizes = [0, 0, 0];

  SunPainter(Listenable repaint) : super(repaint);

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalWithMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    _ensureUnitSizes(size);

    for (int i = 0; i < _angles.length; i ++) {
      _angles[i] = (_angles[i] + (90.0 / (3000 + 1000 * i) * intervalWithMilli)) % 90;
    }

    if (scrollRate < 1) {
      double deltaX = sin(rotation2D * pi / 180.0) * 0.3 * size.width;
      double deltaY = sin(rotation3D * pi / 180.0) * -0.3 * size.width + sinkDistance;

      // 1.
      canvas.translate(size.width + deltaX, 0.0333 * size.width + deltaY);

      _paint.color = SUN_COLOR.withAlpha(((1 - scrollRate) * 255 * 0.40).toInt());
      canvas.rotate(toRadians(_angles[0]));
      for (int i = 0; i < 4; i ++) {
        canvas.drawRect(
            Rect.fromLTRB(-_unitSizes[0], -_unitSizes[0], _unitSizes[0], _unitSizes[0]),
            _paint
        );
        canvas.rotate(toRadians(22.5));
      }
      canvas.rotate(toRadians(-90 - _angles[0]));

      // 2.
      canvas.translate(0.1 * deltaX, 0.1 * deltaY);

      _paint.color = SUN_COLOR.withAlpha(((1 - scrollRate) * 255 * 0.16).toInt());
      canvas.rotate(toRadians(_angles[1]));
      for (int i = 0; i < 4; i ++) {
        canvas.drawRect(
            Rect.fromLTRB(-_unitSizes[1], -_unitSizes[1], _unitSizes[1], _unitSizes[1]),
            _paint
        );
        canvas.rotate(toRadians(22.5));
      }
      canvas.rotate(toRadians(-90 - _angles[1]));

      // 3.
      canvas.translate(0.1 * deltaX, 0.1 * deltaY);

      _paint.color = SUN_COLOR.withAlpha(((1 - scrollRate) * 255 * 0.08).toInt());
      canvas.rotate(toRadians(_angles[2]));
      for (int i = 0; i < 4; i ++) {
        canvas.drawRect(
            Rect.fromLTRB(-_unitSizes[2], -_unitSizes[2], _unitSizes[2], _unitSizes[2]),
            _paint
        );
        canvas.rotate(toRadians(22.5));
      }
      canvas.rotate(toRadians(-90 - _angles[2]));
    }
  }

  void _ensureUnitSizes(Size size) {
    _unitSizes[0] = 0.5 * 0.47 * size.width;
    _unitSizes[1] = 1.7794 * _unitSizes[0];
    _unitSizes[2] = 3.0594 * _unitSizes[0];
  }
}

final sunGradient = MaterialBackgroundGradiant(
    Color(0xFFfdbc4c),
    Color(0xFFff9900)
);