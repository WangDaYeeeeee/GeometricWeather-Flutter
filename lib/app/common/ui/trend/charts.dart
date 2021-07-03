// @dart=2.12

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';

import '_base.dart';

abstract class AbsChartItemView extends StatelessWidget {

  AbsChartItemView({
    Key? key,
    this.paddingTop,
    this.paddingBottom,
    this.lightColor,
    this.darkColor,
    this.dividerColor,
    this.textStyle,
  }): super(key: key);

  final double? paddingTop;
  final double? paddingBottom;

  final Color? lightColor;
  final Color? darkColor;
  final Color? dividerColor;

  final TextStyle? textStyle;
}

class PolylineAndHistogramView extends AbsChartItemView {

  PolylineAndHistogramView({
    Key? key,
    double? paddingTop,
    double? paddingBottom,
    Color? lightColor,
    Color? darkColor,
    this.histogramColor,
    Color? dividerColor,
    this.highPolyLineValues,
    this.highPolyLineDescription,
    this.lowPolyLineValues,
    this.lowPolyLineDescription,
    this.histogramValue,
    this.histogramDescription,
    this.polyLineRange,
    this.histogramRange,
  }): super(
    key: key,
    paddingTop: paddingTop,
    paddingBottom: paddingBottom,
    lightColor: lightColor,
    darkColor: darkColor,
    dividerColor: dividerColor,
  );

  final Color? histogramColor;

  final List<double?>? highPolyLineValues;
  final String? highPolyLineDescription;

  final List<double?>? lowPolyLineValues;
  final String? lowPolyLineDescription;

  final double? histogramValue;
  final String? histogramDescription;

  final ValueRange<double>? polyLineRange;
  final ValueRange<double>? histogramRange;

  @override
  Widget build(BuildContext context) {
    List<double?>? highValues;
    if (highPolyLineValues != null
        && polyLineRange != null
        && highPolyLineDescription != null) {
      highValues = highPolyLineValues!.map((e) {
        if (e == null) {
          return null;
        }

        return (e - polyLineRange!.min)
            / (polyLineRange!.max - polyLineRange!.min);
      }).toList();
    }

    List<double?>? lowValues;
    if (lowPolyLineValues != null
        && polyLineRange != null
        && lowPolyLineDescription != null) {
      lowValues = lowPolyLineValues!.map((e) {
        if (e == null) {
          return null;
        }
        return (e - polyLineRange!.min)
            / (polyLineRange!.max - polyLineRange!.min);
      }).toList();
    }

    bool lightTheme = Theme.of(context).brightness == Brightness.light;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _PolylineAndHistogramPainter(
          highValues,
          lowValues,
          histogramValue == null
              || histogramRange == null
              || histogramDescription == null
              ? null
              : (histogramValue! - histogramRange!.min) / (histogramRange!.max - histogramRange!.min),
          highPolyLineDescription,
          lowPolyLineDescription,
          histogramDescription,
          lightColor ?? Colors.black,
          darkColor ?? Colors.black,
          histogramColor ?? Colors.grey,
          getDividerColor(lightTheme),
          Theme.of(context).cardColor,
          Theme.of(context).textTheme.caption?.copyWith(
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
          Theme.of(context).textTheme.caption?.copyWith(
            fontSize: Theme.of(context).textTheme.overline?.fontSize,
          ),
          getCurrentTextDirection(context),
          paddingTop ?? DEFAULT_PADDING_TOP,
          paddingBottom ?? DEFAULT_PADDING_BOTTOM,
          lightTheme,
        ),
      ),
    );
  }
}

class _PolylineAndHistogramPainter extends CustomPainter {

  _PolylineAndHistogramPainter(
      this._highPolyLineValues,
      this._lowPolyLineValues,
      this._histogramValue,
      this._highPolyLineDescription,
      this._lowPolyLineDescription,
      this._histogramDescription,
      this._highPolyColor,
      this._lowPolyColor,
      this._histogramColor,
      this._dividerColor,
      this._backgroundColor,
      this._polyDescriptionStyle,
      this._histogramDescriptionStyle,
      this._textDirection,
      this._paddingTop,
      this._paddingBottom,
      this._lightTheme,
  ):assert((_highPolyLineValues?.length ?? 3) == 3),
        assert((_lowPolyLineValues?.length ?? 3) == 3),
        super();

  final _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  final _path = Path();

  // 0 - 1.
  final List<double?>? _highPolyLineValues;
  final List<double?>? _lowPolyLineValues;
  final double? _histogramValue;

  final String? _highPolyLineDescription;
  final String? _lowPolyLineDescription;
  final String? _histogramDescription;

  final Color _highPolyColor;
  final Color _lowPolyColor;
  final Color _histogramColor;
  final Color _dividerColor;
  final Color _backgroundColor;

  final TextStyle? _polyDescriptionStyle;
  final TextStyle? _histogramDescriptionStyle;
  final TextDirection? _textDirection;

  final double _paddingTop;
  final double _paddingBottom;

  final bool _lightTheme;

  @override
  void paint(Canvas canvas, Size size) {
    // high poly shadow.
    if (_highPolyLineValues != null && !isEmptyString(_highPolyLineDescription)) {
      // shadow.
      _paint.shader = ui.Gradient.linear(
          Offset(0, _paddingTop),
          Offset(0, size.height - _paddingBottom),
          [
            Color.alphaBlend(
                _highPolyColor.withAlpha((
                    (_lightTheme
                        ? SHADOW_ALPHA_FACTOR_LIGHT
                        : SHADOW_ALPHA_FACTOR_DARK) * 255
                ).toInt()),
                _backgroundColor
            ),
            _backgroundColor,
          ]
      );
      _paint.color = Colors.black;
      _paint.style = PaintingStyle.fill;

      if (_highPolyLineValues![0] != null && _highPolyLineValues![2] != null) {
        // center items.
        _path.reset();
        _path.moveTo(_getRtlX(size, -0.5), _valueToY(size, _highPolyLineValues![0]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _highPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width + 0.5), _valueToY(size, _highPolyLineValues![2]!));
        _path.lineTo(_getRtlX(size, size.width + 0.5), size.height - _paddingBottom);
        _path.lineTo(_getRtlX(size, -0.5), size.height - _paddingBottom);
        _path.close();
        canvas.drawPath(_path, _paint);
      } else if (_highPolyLineValues![0] == null) {
        // start item.
        _path.reset();
        _path.moveTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _highPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width), _valueToY(size, _highPolyLineValues![2]!));
        _path.lineTo(_getRtlX(size, size.width), size.height - _paddingBottom);
        _path.lineTo(_getRtlX(size, size.width / 2.0), size.height - _paddingBottom);
        _path.close();
        canvas.drawPath(_path, _paint);
      } else {
        // end item.
        _path.reset();
        _path.moveTo(_getRtlX(size, 0), _valueToY(size, _highPolyLineValues![0]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _highPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), size.height - _paddingBottom);
        _path.lineTo(_getRtlX(size, 0), size.height - _paddingBottom);
        _path.close();
        canvas.drawPath(_path, _paint);
      }
    }

    // time line.
    _paint.shader = null;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = CHART_LINE_SIZE;
    _paint.color = _dividerColor;
    canvas.drawLine(
        Offset(size.width / 2.0, _paddingTop),
        Offset(size.width / 2.0, size.height - _paddingBottom),
        _paint
    );

    // histogram.
    if (_histogramValue != null && _histogramValue != 0
        && _histogramDescription != null) {
      _paint.style = PaintingStyle.fill;
      _paint.color = _histogramColor;

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                size.width / 2.0 - HISTOGRAM_WIDTH / 2.0,
                _valueToY(size, _histogramValue!),
                HISTOGRAM_WIDTH,
                (size.height - _paddingTop - _paddingBottom) * _histogramValue!,
              ),
              Radius.circular(HISTOGRAM_WIDTH / 2.0)
          ), 
          _paint
      );

      final histogramTextPainter = TextPainter(
        text: TextSpan(
          text: _histogramDescription,
          style: _histogramDescriptionStyle,
        ),
        textAlign: TextAlign.center,
        textDirection: _textDirection,
      )..layout();
      
      histogramTextPainter.paint(
          canvas, 
          Offset(
              size.width / 2.0 - histogramTextPainter.width / 2.0,
              size.height - _paddingBottom + TEXT_MARGIN + 1.5 * HISTOGRAM_WIDTH
          )
      );
    }

    // high poly line.
    if (_highPolyLineValues != null && !isEmptyString(_highPolyLineDescription)) {
      // draw line.
      _paint.shader = null;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = POLYLINE_SIZE;
      _paint.color = _highPolyColor;

      if (_highPolyLineValues![0] != null && _highPolyLineValues![2] != null) {
        // center items.
        _path.reset();
        _path.moveTo(_getRtlX(size, 0), _valueToY(size, _highPolyLineValues![0]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _highPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width), _valueToY(size, _highPolyLineValues![2]!));
        canvas.drawPath(_path, _paint);
      } else if (_highPolyLineValues![0] == null) {
        // start item.
        _path.reset();
        _path.moveTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _highPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width), _valueToY(size, _highPolyLineValues![2]!));
        canvas.drawPath(_path, _paint);
      } else {
        // end item.
        _path.reset();
        _path.moveTo(_getRtlX(size, 0), _valueToY(size, _highPolyLineValues![0]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _highPolyLineValues![1]!));
        canvas.drawPath(_path, _paint);
      }

      // text.
      final highPolyTextPainter = TextPainter(
        text: TextSpan(
          text: _highPolyLineDescription,
          style: _polyDescriptionStyle,
        ),
        textAlign: TextAlign.center,
        textDirection: _textDirection,
      )..layout();

      highPolyTextPainter.paint(
          canvas,
          Offset(
              size.width / 2.0 - highPolyTextPainter.width / 2.0,
              _valueToY(
                  size,
                  _highPolyLineValues![1]!
              ) - highPolyTextPainter.height - POLYLINE_SIZE * 0.5 - TEXT_MARGIN
          )
      );
    }

    // low poly line.
    if (_lowPolyLineValues != null && !isEmptyString(_lowPolyLineDescription)) {
      // draw line.
      _paint.shader = null;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = POLYLINE_SIZE;
      _paint.color = _lowPolyColor;

      if (_lowPolyLineValues![0] != null && _lowPolyLineValues![2] != null) {
        // center items.
        _path.reset();
        _path.moveTo(_getRtlX(size, 0), _valueToY(size, _lowPolyLineValues![0]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _lowPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width), _valueToY(size, _lowPolyLineValues![2]!));
        canvas.drawPath(_path, _paint);
      } else if (_lowPolyLineValues![0] == null) {
        // start item.
        _path.reset();
        _path.moveTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _lowPolyLineValues![1]!));
        _path.lineTo(_getRtlX(size, size.width), _valueToY(size, _lowPolyLineValues![2]!));
        canvas.drawPath(_path, _paint);
      } else {
        // end item.
        _path.reset();
        _path.moveTo(_getRtlX(size, 0), _valueToY(size, _lowPolyLineValues![0]!));
        _path.lineTo(_getRtlX(size, size.width / 2.0), _valueToY(size, _lowPolyLineValues![1]!));
        canvas.drawPath(_path, _paint);
      }

      // text.
      final lowPolyTextPainter = TextPainter(
        text: TextSpan(
          text: _lowPolyLineDescription,
          style: _polyDescriptionStyle,
        ),
        textAlign: TextAlign.center,
        textDirection: _textDirection,
      )..layout();

      lowPolyTextPainter.paint(
          canvas,
          Offset(
              size.width / 2.0 - lowPolyTextPainter.width / 2.0,
              _valueToY(
                  size,
                  _lowPolyLineValues![1]!
              ) + POLYLINE_SIZE * 0.5 + TEXT_MARGIN
          )
      );
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