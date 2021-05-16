import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class IntervalComputer {

  int _currentTime;
  int _lastTime;
  int _interval;

  IntervalComputer() {
    _currentTime = -1;
    _lastTime = -1;
    _interval = 0;
  }

  int invalidate() {
    _currentTime = DateTime.now().millisecondsSinceEpoch;
    _interval = _lastTime == -1 ? 0 : (_currentTime - _lastTime);
    _lastTime = _currentTime;

    return _interval;
  }

  int get interval => _interval;
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