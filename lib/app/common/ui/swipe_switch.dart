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

enum _DragState {
  idle,
  dragging,
}

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

  bool onSwitchRunning = false;

  _DragState state = _DragState.idle;

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
                if (state == _DragState.dragging) {
                  notification.disallowGlow();
                  return true;
                }
                return false;
              },
            ),
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollStartNotification) {
                // reset drag state when scroll start.
                state = _DragState.idle;
              } else if (notification is ScrollUpdateNotification) {
                if (_shouldStartDragging(notification)) {
                  _onDragStart();
                }

                if (state == _DragState.dragging) {
                  if (notification.dragDetails != null
                      && (notification.metrics.atEdge || notification.metrics.outOfRange)) {
                    _onDragUpdate(-notification.scrollDelta);
                  } else {
                    // if drag details is nonnull,
                    // it means user canceled the nested scrolling by reversed scroll.
                    _onDragEnd(
                      forceCancel: notification.dragDetails != null
                    );
                  }
                  return true;
                }
              } else if (notification is OverscrollNotification) {
                if (_shouldStartDragging(notification)) {
                  _onDragStart();
                }

                if (state == _DragState.dragging) {
                  if (notification.dragDetails != null) {
                    _onDragUpdate(- 0.5 * notification.overscroll);
                  } else {
                    _onDragEnd();
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

  bool _shouldStartDragging(ScrollNotification notification) {
    bool validDrag = (
        notification is ScrollUpdateNotification
            && notification.dragDetails != null
    ) || (
        notification is OverscrollNotification
            && notification.dragDetails != null
    );
    return state == _DragState.idle
        && validDrag
        && notification.metrics.axis == Axis.horizontal
        && (notification.metrics.atEdge || notification.metrics.outOfRange);
  }

  void _onDragStart() {
    cancelResetAnimation();

    state = _DragState.dragging;
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
    state = _DragState.idle;

    if (forceCancel || offsetX.abs() < getTriggerDistance()) {
      startResetAnimation();
    } else {
      // notify outside.
      if (widget.onSwitch != null && !onSwitchRunning) {
        onSwitchRunning = true;
        widget.onSwitch(offsetX > 0 ? -1 : 1).then((_) {
          setState(() {
            setOffset(0);
          });
        });
      } else {
        onSwitchRunning = false;
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

        if (widget.onSwipe != null) {
          widget.onSwipe(progressX);
        }
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