import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

import '../mtrl_weather_view.dart';

class NullPainter extends MaterialWeatherPainter {

  NullPainter(Listenable repaint) : super(repaint);

  @override
  void paintWithInterval(Canvas canvas, Size size, int intervalInMilli,
      double scrollRate, double rotation2D, double rotation3D) {
    // do nothing.
  }
}

final nullGradient = MaterialBackgroundGradiant(
  Colors.transparent,
  Colors.transparent
);