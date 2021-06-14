import 'dart:ui';

import 'package:flutter/material.dart';

const DEFAULT_PADDING_TOP = 24.0;
const DEFAULT_PADDING_BOTTOM = 36.0;
const POLYLINE_SIZE = 3.5;
const HISTOGRAM_WIDTH = 7.0;
const CHART_LINE_SIZE = 1.0;
const TEXT_MARGIN = 2.0;

const SHADOW_ALPHA_FACTOR_LIGHT = 0.15;
const SHADOW_ALPHA_FACTOR_DARK = 0.3;

class ValueRange<T extends num> {

  final T min;
  final T max;

  ValueRange(this.min, this.max);
}

Color getDividerColor(bool lightTheme) => lightTheme
    ? Colors.black.withAlpha((255 * 0.025).toInt())
    : Colors.white.withAlpha((255 * 0.05).toInt());