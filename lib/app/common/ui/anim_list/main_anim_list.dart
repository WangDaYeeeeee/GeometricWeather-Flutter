// @dart=2.12

import 'dart:async';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const FLOW_ANIMATION_DURATION = 500;

class ItemWrapper {

  ItemWrapper(this.item, this.callback);

  final Widget item;
  final EnterScreenCallback? callback;
}

class _KeyWrapper {

  _KeyWrapper(this.key, this.callback);

  final GlobalKey<_AnimatedItemState> key;
  final EnterScreenCallback? callback;
}

typedef ItemBuilder = ItemWrapper Function(
    BuildContext context,
    int index,
    bool initVisible);

typedef EnterScreenCallback = void Function();

enum _ItemState {
  hidden,
  animating,
  visible,
}

class MainAnimatedListView extends StatefulWidget {

  MainAnimatedListView({
    Key? key,
    required this.builder,
    required this.itemCount,
    required this.scrollController,
    this.baseItemAnimationDuration = FLOW_ANIMATION_DURATION,
    this.initItemOffsetY = 50.0,
    this.initItemScale = 1.1,
  }): super(key: key);

  final ItemBuilder builder;
  final int itemCount;
  final ScrollController scrollController;

  final int baseItemAnimationDuration;
  final double initItemOffsetY;
  final double initItemScale;

  @override
  State<StatefulWidget> createState() {
    return _MainAnimatedListViewState();
  }
}

class _MainAnimatedListViewState extends State<MainAnimatedListView> {

  final animationMap = Map<int, AnimationController>();
  int lastAnimateIndex = -1;

  final keyMap = Map<int, _KeyWrapper>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainAnimatedListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      // re-execute those uncompleted item animations.
      lastAnimateIndex -= animationMap.length;
      animationMap.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.scrollController.position.didEndScroll();
    });

    final widgets = <Widget>[];
    for (int i = 0; i < widget.itemCount; i ++) {
      final initVisible = i <= lastAnimateIndex
          && animationMap[i] == null;

      final key = GlobalKey<_AnimatedItemState>();
      final itemWrapper = widget.builder(context, i, initVisible);

      if (!initVisible) {
        keyMap[i] = _KeyWrapper(key, itemWrapper.callback);
      }

      widgets.add(
          _AnimatedItem(
            key,
            animationMap,
            itemWrapper.item,
            i,
            initVisible,
            widget.baseItemAnimationDuration,
            widget.initItemOffsetY,
            widget.initItemScale,
          )
      );
    }

    return NotificationListener<ScrollNotification>(
      child: ListView(
        controller: widget.scrollController,
        children: widgets,
        cacheExtent: 999999999,
      ),
      onNotification: _handleScroll,
    );
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification.context == null) {
      return false;
    }

    final sliverMultiBoxAdaptorElement = findSliverMultiBoxAdaptorElement(
        notification.context!);
    if (sliverMultiBoxAdaptorElement == null) {
      return false;
    }

    void onVisitChildren(Element element) {

      final SliverMultiBoxAdaptorParentData? oldParentData
      = element.renderObject?.parentData as SliverMultiBoxAdaptorParentData;
      if (oldParentData == null) {
        return;
      }

      final boundFirst = oldParentData.layoutOffset;
      if ((boundFirst ?? 0.0) <= notification.metrics.pixels
          + notification.metrics.viewportDimension) {
        lastAnimateIndex = max(lastAnimateIndex, oldParentData.index ?? -1);
      }

      final keyWrapper = keyMap.remove(lastAnimateIndex);
      if (keyWrapper != null) {
        Timer.run(() {
          keyWrapper.key.currentState?.enterScreen(keyWrapper.callback);
        });
      }
    }

    sliverMultiBoxAdaptorElement.visitChildren(onVisitChildren);
    return false;
  }

  SliverMultiBoxAdaptorElement? findSliverMultiBoxAdaptorElement(
      BuildContext context) {

    if (context is SliverMultiBoxAdaptorElement) {
      return context;
    }

    SliverMultiBoxAdaptorElement? target;
    context.visitChildElements((child) {
      target ??= findSliverMultiBoxAdaptorElement(child);
    });
    return target;
  }
}

class _AnimatedItem extends StatefulWidget {

  _AnimatedItem(
      Key key,
      this.animationMap,
      this.child,
      this.index,
      this.initVisible,
      this.baseDuration,
      this.initOffsetY,
      this.initScale): super(key: key);

  final Map<int, AnimationController> animationMap;
  final Widget child;
  final int index;
  final bool initVisible;
  final int baseDuration;
  final double initOffsetY;
  final double initScale;

  @override
  State<StatefulWidget> createState() {
    return _AnimatedItemState();
  }
}

class _AnimatedItemState extends State<_AnimatedItem>
    with TickerProviderStateMixin {

  _ItemState state = _ItemState.hidden;

  AnimationController? flowAnimController;
  Animation<double>? opacityAnim;
  Animation<Offset>? positionAnim;
  Animation<double>? scaleAnim;

  @override
  void initState() {
    super.initState();

    ensureAnimations();

    state = widget.initVisible ? _ItemState.visible : _ItemState.hidden;
    if (state == _ItemState.visible) {
      flowAnimController?.forward(from: 1.0);
    }
  }

  @override
  void dispose() {
    flowAnimController?.dispose();
    widget.animationMap.remove(widget.index);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _AnimatedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      setState(() {
        // check if widget change.
      });
    }
  }

  void ensureAnimations() {
    int pendingCount = widget.animationMap.length;
    int duration = max(
        widget.baseDuration - pendingCount * 50.0,
        200
    ).toInt();
    int delay = pendingCount * 200;

    flowAnimController = AnimationController(
        duration: Duration(
            milliseconds: delay + duration,
        ),
        vsync: this
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        state = _ItemState.visible;
        widget.animationMap.remove(widget.index);
      }
    });

    opacityAnim = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(
        CurvedAnimation(
          parent: flowAnimController!,
          curve: Interval(
            1.0 * delay / (delay + duration),
            1.0,
            curve: Curves.ease,
          ),
        )
    );
    positionAnim = Tween(
        begin: Offset(0.0, widget.initOffsetY),
        end: Offset.zero
    ).animate(
        CurvedAnimation(
          parent: flowAnimController!,
          curve: Interval(
            1.0 * delay / (delay + duration),
            1.0,
            curve: Curves.easeOutBack,
          ),
        )
    );
    scaleAnim = Tween(
        begin: widget.initScale,
        end: 1.0
    ).animate(
        CurvedAnimation(
          parent: flowAnimController!,
          curve: Interval(
            1.0 * delay / (delay + duration),
            1.0,
            curve: Curves.ease,
          ),
        )
    );
  }

  void enterScreen(EnterScreenCallback? callback) {
    if (state == _ItemState.hidden) {
      setState(() {
        state = _ItemState.animating;
        ensureAnimations();

        widget.animationMap[widget.index] = flowAnimController!;
        flowAnimController!.forward();
        callback?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flowAnimController!,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: opacityAnim!.value,
          child: Transform.translate(
            offset: positionAnim!.value,
            child: Transform.scale(
              scale: scaleAnim!.value,
              child: child,
            ),
          ),
        );
      }
    );
  }
}