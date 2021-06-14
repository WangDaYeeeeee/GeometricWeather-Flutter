// @dart=2.12

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';

class TrendScrollBar extends StatefulWidget {

  TrendScrollBar(this.child, this.margin);

  final Widget child;
  final double margin;

  @override
  State<StatefulWidget> createState() {
    return _TrendScrollBarState();
  }
}

class _TrendScrollBarState extends State<TrendScrollBar> {

  _TrendScrollBarPainter? _painter;
  bool? _lightTheme;

  double _offset = 0;
  double _minOffset = 0;
  double _maxOffset = 1;

  @override
  Widget build(BuildContext context) {
    bool lightNow = Theme.of(context).brightness == Brightness.light;
    if (_painter == null || _lightTheme == null || _lightTheme != lightNow) {
      _painter = _TrendScrollBarPainter(
          lightNow
              ? Color.fromARGB((0.02 * 255).toInt(), 0, 0, 0)
              : Color.fromARGB((0.08 * 255).toInt(), 0, 0, 0)
      );
      _lightTheme = lightNow;
    }

    double itemWidth = getTrendItemWidth(context, widget.margin);

    return NotificationListener<ScrollNotification>(
      child: Stack(children: [
        widget.child,
        IgnorePointer(
          child: Align(
            alignment: Alignment(
                -1 + ((_offset - _minOffset) / (_maxOffset - _minOffset)) * 2,
                0
            ),
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size(itemWidth, double.infinity),
                painter: _painter,
              ),
            ),
          ),
        ),
      ]),
      onNotification: (ScrollNotification notification) {
        // never consume scroll notification.
        setState(() {
          _offset = notification.metrics.pixels;
          _minOffset = notification.metrics.minScrollExtent;
          _maxOffset = notification.metrics.maxScrollExtent;
        });
        return false;
      },
    );
  }
}

class _TrendScrollBarPainter extends CustomPainter {

  _TrendScrollBarPainter(this._color);

  final _paint = Paint()
    ..isAntiAlias = true
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  final Color _color;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.shader = ui.Gradient.linear(
      Offset(0, 0),
      Offset(0, size.height),
      [Colors.transparent, _color, Colors.transparent],
      [0.0, 0.5, 1.0]
    );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}