import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class GeoSizeChangedLayoutNotification extends LayoutChangedNotification{

  Size size;

  GeoSizeChangedLayoutNotification(this.size);
}

class GeoSizeChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  const GeoSizeChangedLayoutNotifier({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _RenderSizeChangedWithCallback createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(
        onLayoutChangedCallback: (Size size) {
          GeoSizeChangedLayoutNotification(size).dispatch(context);
        }
    );
  }
}

typedef VoidCallbackWithParam = Function(Size size);

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    RenderBox child,
    @required this.onLayoutChangedCallback,
  }) : assert(onLayoutChangedCallback != null),
        super(child);

  final VoidCallbackWithParam onLayoutChangedCallback;

  Size _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize)
      onLayoutChangedCallback(size);
    _oldSize = size;
  }
}