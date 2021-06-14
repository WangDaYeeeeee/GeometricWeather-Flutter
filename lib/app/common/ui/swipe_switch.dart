import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/ui/size_changed_notifier.dart';

///  progress:
///   0: reset position.
///  -1: already move to the trigger position of left item.
///   1: already move to the trigger position of right item.
typedef OnSwipeCallback = void Function(double progress);

///  position:
///  -1: switch to left item.
///   1: switch to right item.
typedef OnSwitchCallback = Future<void> Function(int positionChanging);

const RESET_ANIMATION_DURATION = 800;
const SWIPE_RATIO = 0.4;

class SwipeSwitchLayout extends StatefulWidget {

  final Widget child;
  final bool swipeEnabled;
  final OnSwipeCallback onSwipe;
  final OnSwitchCallback onSwitch;

  SwipeSwitchLayout({
    this.child,
    this.swipeEnabled = true,
    this.onSwipe,
    this.onSwitch,
    Key key
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SwipeSwitchLayoutState();
  }
}

class _SwipeSwitchLayoutState extends State<SwipeSwitchLayout>
    with TickerProviderStateMixin {

  double offsetX;
  double progressX;
  double triggerDistanceX = 100;

  // true  : dragging.
  // false : idle.
  // null  : pending because listening the scroll start event.
  bool dragging = false;

  AnimationController resetController;

  @override
  void initState() {
    super.initState();
    setOffset(0);
  }

  @override
  void dispose() {
    super.dispose();
    cancelResetAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return Container();
    }

    return GestureDetector(
      child: Transform.translate(
        offset: Offset(getOffset(), 0),
        child: Opacity(
          opacity: max(1 - progressX.abs(), 0),
          child: NotificationListener<ScrollNotification>(
            child: NotificationListener<OverscrollIndicatorNotification>(
              child: NotificationListener<GeoSizeChangedLayoutNotification>(
                child: GeoSizeChangedLayoutNotifier(
                  child: widget.child,
                ),
                onNotification: (GeoSizeChangedLayoutNotification notification) {
                  triggerDistanceX = notification.size.width / 5.0;
                  return true;
                },
              ),
              onNotification: (OverscrollIndicatorNotification notification) {
                if (dragging != null) {
                  dragging = null;
                  return true;
                }
                return false;
              },
            ),
            onNotification: (ScrollNotification notification) {
              if (dragging != null && !dragging) {
                // idle.
                if (notification is ScrollStartNotification
                    && notification.dragDetails != null) {
                  dragging = null;
                  return false;
                }
              }

              if (dragging != null && !dragging) {
                return false;
              }

              if (notification is ScrollUpdateNotification) {
                if (dragging == null) {
                  dragging = notification.metrics.axis == Axis.horizontal
                      && (notification.metrics.atEdge || notification.metrics.outOfRange);
                }
                if (dragging) {
                  if (notification.dragDetails != null
                      && (notification.metrics.atEdge || notification.metrics.outOfRange)) {
                    _onDragUpdate(-notification.scrollDelta);
                  } else {
                    _onDragEnd(forceCancel: true);
                  }
                  return true;
                }
              } else if (notification is OverscrollNotification) {
                if (dragging == null) {
                  dragging = notification.metrics.axis == Axis.horizontal
                      && (notification.metrics.atEdge || notification.metrics.outOfRange);
                }
                if (dragging) {
                  if (notification.dragDetails != null) {
                    _onDragUpdate(-notification.overscroll);
                  } else {
                    _onDragEnd(forceCancel: true);
                  }
                  return true;
                }
              } else if (notification is ScrollEndNotification) {
                _onDragEnd();
                return true;
              }

              return false;
            }
          )
        ),
      ),
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (DragStartDetails details) {
        _onDragStart();
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _onDragUpdate(details.delta.dx);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _onDragEnd();
      },
    );
  }

  void _onDragStart() {
    cancelResetAnimation();

    dragging = true;
    setState(() {
      // do not reset offsetX as 0, we might just stop a reset animation.
      setOffset(offsetX);
    });
  }

  void _onDragUpdate(double dx) {
    setState(() {
      setOffset(offsetX + dx);

      if (widget.onSwipe != null) {
        widget.onSwipe(progressX);
      }
    });
  }

  void _onDragEnd({
    bool forceCancel = false
  }) {
    dragging = false;

    if (forceCancel || offsetX.abs() < getTriggerDistance()) {
      startResetAnimation();
    } else {
      // notify outside.
      if (widget.onSwitch != null) {
        widget.onSwitch(offsetX > 0 ? -1 : 1).then((_) {
          setState(() {
            setOffset(0);
          });
        });
      } else {
        setState(() {
          setOffset(0);
        });
      }
    }
  }

  void setOffset(double offset) {
    offsetX = offset;
    progressX = -1.0 * offsetX / getTriggerDistance();
  }

  double getOffset() => SWIPE_RATIO * offsetX;

  double getTriggerDistance() => triggerDistanceX;

  void startResetAnimation() {
    resetController = AnimationController(
      duration: Duration(milliseconds: RESET_ANIMATION_DURATION),
      vsync: this
    );

    Animation a = CurvedAnimation(
        parent: resetController,
        curve: Curves.elasticOut
    );
    a.addListener(() {
      setState(() {
        setOffset(a.value);
      });
    });

    a = Tween(begin: offsetX, end: 0.0).animate(a);

    resetController.forward();
  }

  void cancelResetAnimation() {
    resetController?.dispose();
    resetController = null;
  }
}