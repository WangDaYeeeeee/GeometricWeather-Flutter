import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class IntervalComputer {

  int _currentTime;
  int _lastTime;
  int _interval;

  bool _drawable;

  IntervalComputer() {
    _reset();

    _drawable = true;
  }

  void _reset() {
    _currentTime = -1;
    _lastTime = -1;
    _interval = 0;
  }

  int invalidate() {
    if (!_drawable) {
      return 0;
    }

    _currentTime = DateTime.now().millisecondsSinceEpoch;
    _interval = _lastTime == -1 ? 0 : (_currentTime - _lastTime);
    _lastTime = _currentTime;

    return _interval;
  }

  int get interval => _interval;

  set drawable(bool drawable) {
    if (_drawable == drawable) {
      return;
    }

    _drawable = drawable;
    if (_drawable) {
      _reset();
    }
  }
}

double toRadians(double degrees) {
  return degrees * pi / 180.0;
}

double toDegrees(double radians) {
  return radians * 180.0 / pi;
}

class CustomSizeChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  const CustomSizeChangedLayoutNotifier({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _RenderSizeChangedWithCallback createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(
      onLayoutChangedCallback: () {
        SizeChangedLayoutNotification().dispatch(context);
      },
    );
  }
}

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    RenderBox child,
    @required this.onLayoutChangedCallback,
  }) : assert(onLayoutChangedCallback != null),
        super(child);

  final VoidCallback onLayoutChangedCallback;
  Size _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize)
      onLayoutChangedCallback();
    _oldSize = size;
  }
}