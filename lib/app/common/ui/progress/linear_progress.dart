// @dart=2.12

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const INNER_MARGIN = 2.0;

const BACKGROUND_ALPHA = 50;

class LinearProgressView extends StatefulWidget {

  LinearProgressView({
    Key? key,
    required this.initVisible,
    required this.duration,
    required this.progress,
    this.beginColor = Colors.grey,
    this.endColor = Colors.black,
  }): assert(0.0 <= progress && progress <= 1.0),
        super(key: key);

  final bool initVisible;

  final int duration;
  final double progress;
  final Color beginColor;
  final Color endColor;

  @override
  State<StatefulWidget> createState() {
    return LinearProgressViewState();
  }
}

class LinearProgressViewState extends State<LinearProgressView>
    with TickerProviderStateMixin {

  AnimationController? _progressAnimController;
  Animation<double>? _progressAnim;
  Animation<Color?>? _colorAnim;

  _ProgressPainter? _painter;

  @override
  void initState() {
    super.initState();

    _progressAnimController = AnimationController(
        duration: Duration(milliseconds: widget.duration),
        vsync: this
    );

    _progressAnim = Tween(
        begin: 0.0,
        end: widget.progress
    ).animate(
        CurvedAnimation(
          parent: _progressAnimController!,
          curve: Curves.easeInOutQuint,
        )
    );
    _colorAnim = ColorTween(
        begin: widget.beginColor,
        end: widget.endColor
    ).animate(
        CurvedAnimation(
          parent: _progressAnimController!,
          curve: Curves.easeInOutQuint,
        )
    );

    if (widget.initVisible) {
      _progressAnimController!.forward(from: 1.0);
    }
    _painter = _ProgressPainter(
      _progressAnimController!,
      _progressAnim!,
      _colorAnim!,
    );
  }

  @override
  void dispose() {
    _progressAnimController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LinearProgressView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _painter = _ProgressPainter(
        _progressAnimController!,
        _progressAnim!,
        _colorAnim!,
      );
    });
  }

  void executeAnimations({double from = 0.0}) {
    if (!widget.initVisible) {
      _progressAnimController?.forward(from: from);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _painter,
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {

  _ProgressPainter(
      AnimationController controller,
      this._progressAnim,
      this._colorAnim): super(repaint: controller);

  final _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Animation<double> _progressAnim;
  final Animation<Color?> _colorAnim;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.strokeWidth = size.height - 2 * INNER_MARGIN;

    // background.
    _paint.color = (
        _colorAnim.value ?? Colors.transparent
    ).withAlpha(BACKGROUND_ALPHA);
    canvas.drawLine(
        Offset(
            INNER_MARGIN + _paint.strokeWidth / 2.0,
            size.height / 2.0
        ),
        Offset(
            size.width - INNER_MARGIN - _paint.strokeWidth / 2.0,
            size.height / 2.0
        ),
        _paint
    );

    // foreground.
    _paint.color = _colorAnim.value ?? Colors.transparent;
    canvas.drawLine(
        Offset(
            INNER_MARGIN + _paint.strokeWidth / 2.0,
            size.height / 2.0
        ),
        Offset(
            INNER_MARGIN + _paint.strokeWidth / 2.0 + (
                size.width - 2 * INNER_MARGIN - _paint.strokeWidth
            ) * _ensureProgressInBound(_progressAnim.value),
            size.height / 2.0
        ),
        _paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

double _ensureProgressInBound(double progress) {
  progress = max(0.0, progress);
  progress = min(1.0, progress);
  return progress;
}