// @dart=2.12

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';

import '_base.dart';

class TrendBackgroundView extends StatelessWidget {

  TrendBackgroundView({
    Key? key,
    this.paddingTop,
    this.paddingBottom,
    this.highHorizontalValues,
    this.highHorizontalStartDescriptions,
    this.highHorizontalEndDescriptions,
    this.lowHorizontalValues,
    this.lowHorizontalStartDescriptions,
    this.lowHorizontalEndDescriptions,
    this.valueRange,
  }): super(
    key: key
  );

  final double? paddingTop;
  final double? paddingBottom;

  final List<double>? highHorizontalValues;
  final List<String>? highHorizontalStartDescriptions;
  final List<String?>? highHorizontalEndDescriptions;

  final List<double>? lowHorizontalValues;
  final List<String>? lowHorizontalStartDescriptions;
  final List<String?>? lowHorizontalEndDescriptions;

  final ValueRange<double>? valueRange;

  @override
  Widget build(BuildContext context) {
    List<double>? highHorizontalValList;
    if (highHorizontalValues != null) {
      highHorizontalValList = highHorizontalValues!.map((e) {
        return (e - valueRange!.min)
            / (valueRange!.max - valueRange!.min);
      }).toList();
    }

    List<double>? lowHorizontalValList;
    if (lowHorizontalValues != null) {
      lowHorizontalValList = lowHorizontalValues!.map((e) {
        return (e - valueRange!.min)
            / (valueRange!.max - valueRange!.min);
      }).toList();
    }

    bool lightTheme = Theme.of(context).brightness == Brightness.light;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _TrendBackgroundPainter(
          highHorizontalValList,
          lowHorizontalValList,
          highHorizontalStartDescriptions,
          highHorizontalEndDescriptions,
          lowHorizontalStartDescriptions,
          lowHorizontalEndDescriptions,
          getDividerColor(lightTheme),
          Theme.of(context).textTheme.caption?.copyWith(
            fontSize: Theme.of(context).textTheme.overline?.fontSize,
          ),
          getCurrentTextDirection(context),
          paddingTop ?? DEFAULT_PADDING_TOP,
          paddingBottom ?? DEFAULT_PADDING_BOTTOM,
        ),
      ),
    );
  }
}

class _TrendBackgroundPainter extends CustomPainter {

  _TrendBackgroundPainter(
      this._highHorizontalValues,
      this._lowHorizontalValues,
      this._highHorizontalStartDescriptions,
      this._highHorizontalEndDescriptions,
      this._lowHorizontalStartDescriptions,
      this._lowHorizontalEndDescriptions,
      this._dividerColor,
      this._horizontalDescriptionStyle,
      this._textDirection,
      this._paddingTop,
      this._paddingBottom): super();

  final _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  // 0 - 1.
  final List<double>? _highHorizontalValues;
  final List<double>? _lowHorizontalValues;

  final List<String>? _highHorizontalStartDescriptions;
  final List<String?>? _highHorizontalEndDescriptions;
  final List<String>? _lowHorizontalStartDescriptions;
  final List<String?>? _lowHorizontalEndDescriptions;

  final Color _dividerColor;

  final TextStyle? _horizontalDescriptionStyle;
  final TextDirection? _textDirection;

  final double _paddingTop;
  final double _paddingBottom;

  @override
  void paint(Canvas canvas, Size size) {
    // horizontal lines.
    if (_highHorizontalValues != null) {
      // high.
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = CHART_LINE_SIZE;
      _paint.color = _dividerColor;

      for (int i = 0; i < _highHorizontalValues!.length; i ++) {
        final y = _valueToY(size, _highHorizontalValues![i]);
        canvas.drawLine(
            Offset(0.0, y),
            Offset(size.width, y),
            _paint
        );

        if (_highHorizontalStartDescriptions != null) {
          final highStartTextPainter = TextPainter(
            text: TextSpan(
              text: _highHorizontalStartDescriptions![i],
              style: _horizontalDescriptionStyle,
            ),
            textAlign: TextAlign.center,
            textDirection: _textDirection,
          )..layout();

          highStartTextPainter.paint(
              canvas,
              Offset(
                  _getRtlX(size, 2 * CHART_LINE_SIZE + TEXT_MARGIN),
                  y - TEXT_MARGIN - 2 * CHART_LINE_SIZE - highStartTextPainter.height
              )
          );

          if (_highHorizontalEndDescriptions?[i] != null) {
            final highEndTextPainter = TextPainter(
              text: TextSpan(
                text: _highHorizontalEndDescriptions![i],
                style: _horizontalDescriptionStyle,
              ),
              textAlign: TextAlign.center,
              textDirection: _textDirection,
            )..layout();

            highEndTextPainter.paint(
                canvas,
                Offset(
                    _getRtlX(size, size.width - 2 * CHART_LINE_SIZE - TEXT_MARGIN - highEndTextPainter.width),
                    y - TEXT_MARGIN - 2 * CHART_LINE_SIZE - highEndTextPainter.height
                )
            );
          }
        }
      }
    }
    if (_lowHorizontalValues != null) {
      // low.
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = CHART_LINE_SIZE;
      _paint.color = _dividerColor;

      for (int i = 0; i < _lowHorizontalValues!.length; i ++) {
        final y = _valueToY(size, _lowHorizontalValues![i]);
        canvas.drawLine(
            Offset(0.0, y),
            Offset(size.width, y),
            _paint
        );

        if (_lowHorizontalStartDescriptions != null) {
          final lowStartTextPainter = TextPainter(
            text: TextSpan(
              text: _lowHorizontalStartDescriptions![i],
              style: _horizontalDescriptionStyle,
            ),
            textAlign: TextAlign.center,
            textDirection: _textDirection,
          )..layout();

          lowStartTextPainter.paint(
              canvas,
              Offset(
                  _getRtlX(size, 2 * CHART_LINE_SIZE + TEXT_MARGIN),
                  y + TEXT_MARGIN + 2 * CHART_LINE_SIZE
              )
          );

          if (_lowHorizontalEndDescriptions?[i] != null) {
            final lowEndTextPainter = TextPainter(
              text: TextSpan(
                text: _lowHorizontalEndDescriptions![i],
                style: _horizontalDescriptionStyle,
              ),
              textAlign: TextAlign.center,
              textDirection: _textDirection,
            )..layout();

            lowEndTextPainter.paint(
                canvas,
                Offset(
                    _getRtlX(size, size.width - 2 * CHART_LINE_SIZE - TEXT_MARGIN - lowEndTextPainter.width),
                    y + TEXT_MARGIN + 2 * CHART_LINE_SIZE
                )
            );
          }
        }
      }
    }
  }

  double _getRtlX(Size size, double x) {
    return _textDirection == ui.TextDirection.ltr ? x : size.width - x;
  }

  double _valueToY(Size size, double value) {
    // padding bottom is the y coordinate of value 0.
    // padding top is the y coordinate of value 1.
    return size.height - _paddingBottom - (
        (size.height - _paddingTop - _paddingBottom) * value
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}