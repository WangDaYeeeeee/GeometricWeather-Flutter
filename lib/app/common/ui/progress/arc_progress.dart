// @dart=2.12

import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';

const DEFAULT_STROKE_WIDTH = 8.0;
const INNER_MARGIN = 2.0;

const BACKGROUND_ALPHA = 50;
const SHADOW_ALPHA = 25;

class ArcProgressView extends StatefulWidget {

  ArcProgressView({
    Key? key,
    required this.initVisible,
    required this.duration,
    required this.progress,
    required this.number,
    required this.description,
    this.strokeWidth = DEFAULT_STROKE_WIDTH,
    this.beginColor = Colors.grey,
    this.endColor = Colors.black,
    required this.theme,
  }): assert(0.0 <= progress && progress <= 1.0),
        super(key: key);

  final bool initVisible;

  final int duration;
  final double progress;
  final int number;
  final String description;
  final double strokeWidth;
  final Color beginColor;
  final Color endColor;

  final ThemeData theme;

  @override
  State<StatefulWidget> createState() {
    return ArcProgressViewState();
  }
}

class ArcProgressViewState extends State<ArcProgressView>
    with TickerProviderStateMixin {

  AnimationController? _progressAnimController;
  Animation<double>? _progressAnim;
  Animation<Color?>? _colorAnim;
  Animation<double>? _numberAnim;

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
    _numberAnim = Tween(
        begin: 0.0,
        end: widget.number.toDouble()
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
      _numberAnim!,
      widget.strokeWidth,
      widget.theme.cardColor,
      widget.theme.textTheme.headline4?.copyWith(
        color: widget.theme.textTheme.subtitle2?.color
      ),
      widget.description,
      widget.theme.textTheme.caption,
      getCurrentTextDirection(context),
    );
  }

  @override
  void dispose() {
    _progressAnimController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ArcProgressView oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _painter = _ProgressPainter(
        _progressAnimController!,
        _progressAnim!,
        _colorAnim!,
        _numberAnim!,
        widget.strokeWidth,
        widget.theme.cardColor,
        widget.theme.textTheme.headline4?.copyWith(
          color: widget.theme.textTheme.subtitle2?.color
        ),
        widget.description,
        widget.theme.textTheme.caption,
        getCurrentTextDirection(context),
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
      this._colorAnim,
      this._numberAnim,
      this._strokeWidth,
      this._backgroundColor,
      this._numberStyle,
      this._description,
      this._descriptionStyle,
      this._textDirection): super(repaint: controller);

  final _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Animation<double> _progressAnim;
  final Animation<Color?> _colorAnim;
  final Animation<double> _numberAnim;
  final double _strokeWidth;
  final Color _backgroundColor;

  final TextStyle? _numberStyle;
  final String _description;
  final TextStyle? _descriptionStyle;
  final TextDirection _textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.strokeWidth = _strokeWidth;

    // shadow.
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    _paint.shader = ui.Gradient.linear(
      Offset(
          0.0,
          size.height / 2.0 - (
              min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth
          ) / 2.0
      ),
      Offset(
          0.0,
          size.height / 2.0 + (
              min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth
          ) / 2.0
      ),
      [
        Color.alphaBlend(
          (_colorAnim.value ?? Colors.transparent).withAlpha(BACKGROUND_ALPHA),
          _backgroundColor,
        ),
        _backgroundColor
      ],
    );
    if (_progressAnim.value >= 5.0 / 6.0) {
      canvas.drawCircle(
        Offset(size.width / 2.0, size.height / 2.0),
        (min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth) / 2.0,
        _paint
      );
    } else if (1.0 / 6.0 < _progressAnim.value && _progressAnim.value < 5.0 / 6.0) {
      canvas.drawArc(
          Rect.fromCenter(
            center: Offset(size.width / 2.0, size.height / 2.0),
            width: min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth,
            height: min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth,
          ),
          _toRadians(
              180.0 - (_progressAnim.value - 1.0 / 6.0) * 270.0 - _strokeWidth / (
                  min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth
              )
          ),
          _toRadians(
              (_progressAnim.value - 1.0 / 6.0) * 270.0 * 2.0 + 2 * _strokeWidth / (
                  min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth
              )
          ),
          false,
          _paint
      );
    }
    _paint.shader = null;
    _paint.style = PaintingStyle.stroke;

    // background.
    _paint.color = (
        _colorAnim.value ?? Colors.transparent
    ).withAlpha(BACKGROUND_ALPHA);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2.0, size.height / 2.0),
        width: min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth,
        height: min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth,
      ),
      _toRadians(135),
      _toRadians(270),
      false,
      _paint
    );

    // foreground.
    _paint.color = _colorAnim.value ?? Colors.transparent;
    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2.0, size.height / 2.0),
          width: min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth,
          height: min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth,
        ),
        _toRadians(135),
        _toRadians(270 * _ensureProgressInBound(_progressAnim.value)),
        false,
        _paint
    );

    // text.
    final numberPainter = TextPainter(
      text: TextSpan(
        text: (_numberAnim.value).toInt().toString(),
        style: _numberStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: _textDirection,
    )..layout();

    numberPainter.paint(
        canvas,
        Offset(
            size.width / 2.0 - numberPainter.width / 2.0,
            size.height / 2.0 - numberPainter.height / 2.0,
        )
    );

    final descriptionPainter = TextPainter(
      text: TextSpan(
        text: _description,
        style: _descriptionStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: _textDirection,
    )..layout();

    descriptionPainter.paint(
        canvas,
        Offset(
          size.width / 2.0 - descriptionPainter.width / 2.0,
          size.height / 2.0
              + (min(size.width, size.height) - 2 * INNER_MARGIN - _strokeWidth) / 2.0
              - descriptionPainter.height / 2.0,
        )
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

double _toRadians(double degrees) {
  return degrees * pi / 180.0;
}

double _ensureProgressInBound(double progress) {
  progress = max(0.0, progress);
  progress = min(1.0, progress);
  return progress;
}