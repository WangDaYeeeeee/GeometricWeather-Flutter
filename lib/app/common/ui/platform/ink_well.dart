import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/utils/platform.dart';

class PlatformInkWell extends StatefulWidget {

  PlatformInkWell({
    Key key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  }): super(key: key);

  final Widget child;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final GestureLongPressCallback onLongPress;

  @override
  State<StatefulWidget> createState() {
    return _PlatformInkWellState();
  }
}

class _PlatformInkWellState extends State<PlatformInkWell> {

  bool _pressDown = false;

  @override
  Widget build(BuildContext context) {
    if (GeoPlatform.isMaterialStyle) {
      return InkWell(
          child: widget.child,
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          onLongPress: widget.onLongPress
      );
    } else if (GeoPlatform.isCupertinoStyle) {
      return GestureDetector(
        child: AnimatedOpacity(
          child: widget.child,
          opacity: _pressDown ? 0.5 : 1.0,
          duration: Duration(milliseconds: 200),
        ),
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          setState(() {
            _pressDown = true;
          });
        },
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onLongPress: widget.onLongPress,
        onPanEnd: (_) {
          setState(() {
            _pressDown = false;
          });
        },
        onPanCancel: () {
          setState(() {
            _pressDown = false;
          });
        },
      );
    } else {
      return GestureDetector(
          child: widget.child,
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          onLongPress: widget.onLongPress
      );
    }
  }
}