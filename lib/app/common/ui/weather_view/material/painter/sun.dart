import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/painter/utils.dart';

import '../mtrl_weather_view.dart';

class SunPainter extends MaterialWeatherPainter  {

  static const SUN_COLOR = Color(0xFFfd5411);

  final Paint _paint = new Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  final List<double> _angles = [0, 0, 0];
  final List<double> _unitSizes = [0, 0, 0];

  final IntervalComputer _intervalComputer = IntervalComputer();

  @override
  double rotation2D = 0;
  @override
  double rotation3D = 0;
  @override
  double scrollRate = 0;

  SunPainter(Listenable repaint) : super(repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _ensureUnitSizes(size);
    double interval = _intervalComputer.invalidate();

    for (int i = 0; i < _angles.length; i ++) {
      _angles[i] = (_angles[i] + (90.0 / (3000 + 1000 * i) * interval)) % 90;
    }

    if (scrollRate < 1) {
      double deltaX = sin(rotation2D * pi / 180.0) * 0.3 * size.width;
      double deltaY = sin(rotation3D * pi / 180.0) * -0.3 * size.width;

      canvas.translate(
          size.width + deltaX, 0.0333 * size.width + deltaY);

      _paint.color = SUN_COLOR.withAlpha(((1 - scrollRate) * 255 * 0.40).toInt());
      canvas.rotate(_angles[0]);
      for (int i = 0; i < 4; i ++) {
        canvas.drawRect(
            Rect.fromLTRB(-_unitSizes[0], -_unitSizes[0], _unitSizes[0], _unitSizes[0]),
            _paint
        );
        canvas.rotate(22.5);
      }
      canvas.rotate(-90 - _angles[0]);

      _paint.color = SUN_COLOR.withAlpha(((1 - scrollRate) * 255 * 0.16).toInt());
      canvas.rotate(_angles[1]);
      for (int i = 0; i < 4; i ++) {
        canvas.drawRect(
            Rect.fromLTRB(-_unitSizes[1], -_unitSizes[1], _unitSizes[1], _unitSizes[1]),
            _paint
        );
        canvas.rotate(22.5);
      }
      canvas.rotate(-90 - _angles[1]);

      _paint.color = SUN_COLOR.withAlpha(((1 - scrollRate) * 255 * 0.08).toInt());
      canvas.rotate(_angles[2]);
      for (int i = 0; i < 4; i ++) {
        canvas.drawRect(
            Rect.fromLTRB(-_unitSizes[2], -_unitSizes[2], _unitSizes[2], _unitSizes[2]),
            _paint
        );
        canvas.rotate(22.5);
      }
      canvas.rotate(-90 - _angles[2]);
    }
  }

  void _ensureUnitSizes(Size size) {
    _unitSizes[0] = 0.5 * 0.47 * size.width;
    _unitSizes[1] = 1.7794 * _unitSizes[0];
    _unitSizes[2] = 3.0594 * _unitSizes[0];
  }
}

const sunGradient = LinearGradient(
  colors: [
    Color(0xFFfdbc4c),
    Color(0xFFff9900)
  ],
  begin: AlignmentDirectional.center,
  end: AlignmentDirectional.bottomCenter
);