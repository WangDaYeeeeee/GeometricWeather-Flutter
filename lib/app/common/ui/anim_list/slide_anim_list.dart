// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/interaction.dart';

const FLOW_ANIMATION_DURATION = 400;

class SlideAnimatedListView extends StatelessWidget {

  SlideAnimatedListView({
    Key? key,
    required this.builder,
    required this.itemCount,
    this.scrollController,
    this.padding,
    this.baseItemAnimationDuration = FLOW_ANIMATION_DURATION,
    this.initItemOffsetX = 50.0,
    this.initItemOffsetY = 0.0,
  }): super(key: key);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  final int baseItemAnimationDuration;
  final double initItemOffsetX;
  final double initItemOffsetY;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      key: key,
      child: ListView.builder(
        controller: scrollController,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: getTabletAdaptiveWidthBox(
              context,
              AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: baseItemAnimationDuration),
                child: SlideAnimation(
                  verticalOffset: initItemOffsetY,
                  horizontalOffset: initItemOffsetX,
                  curve: Curves.easeOutCubic,
                  child: FadeInAnimation(
                    child: builder(context, index),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
            ),
          );
        },
        padding: padding,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      ),
    );
  }
}

typedef IndexedWidgetWrapperBuilder = WidgetWrapper Function(
    BuildContext context,
    int index);

typedef IndexedDismissCallback = void Function(
    DismissDirection direction,
    int index);

typedef IndexedConfirmDismissCallback = Future<bool?> Function(
    DismissDirection direction,
    int index);

class WidgetWrapper {

  final Widget item;
  final Key key;

  WidgetWrapper(this.item, this.key);
}

class DraggableSlideAnimatedListView extends StatelessWidget {

  DraggableSlideAnimatedListView({
    Key? key,
    required this.builder,
    required this.dismissCallback,
    required this.reorderCallback,
    required this.itemCount,
    this.confirmCallback,
    this.startBackgroundBuilder,
    this.endBackgroundBuilder,
    this.scrollController,
    this.padding,
    this.baseItemAnimationDuration = FLOW_ANIMATION_DURATION,
    this.initItemOffsetX = 50.0,
    this.initItemOffsetY = 0.0,
  }): super(key: key);

  final IndexedWidgetWrapperBuilder builder;
  final IndexedDismissCallback dismissCallback;
  final ReorderCallback reorderCallback;
  final IndexedConfirmDismissCallback? confirmCallback;
  final IndexedWidgetBuilder? startBackgroundBuilder;
  final IndexedWidgetBuilder? endBackgroundBuilder;
  final int itemCount;
  final ScrollController? scrollController;
  final EdgeInsets? padding;

  final int baseItemAnimationDuration;
  final double initItemOffsetX;
  final double initItemOffsetY;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      key: key,
      child: ReorderableListView.builder(
        scrollController: scrollController,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          final wrapper = builder(context, index);

          return Center(
            key: wrapper.key,
            child: getTabletAdaptiveWidthBox(
              context,
              ReorderableDelayedDragStartListener(
                child: Dismissible(
                  key: wrapper.key,
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: baseItemAnimationDuration),
                    child: SlideAnimation(
                      verticalOffset: initItemOffsetY,
                      horizontalOffset: initItemOffsetX,
                      curve: Curves.easeOutCubic,
                      child: FadeInAnimation(
                        child: wrapper.item,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
                  onDismissed: (DismissDirection direction) {
                    dismissCallback(direction, index);
                  },
                  confirmDismiss: confirmCallback == null ? null : (direction) {
                    return confirmCallback!(direction, index);
                  },
                  background: startBackgroundBuilder == null
                      ? null
                      : startBackgroundBuilder!(context, index),
                  secondaryBackground: endBackgroundBuilder == null
                      ? null
                      : endBackgroundBuilder!(context, index),
                ),
                index: index
              ),
            ),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          // These two lines are workarounds for ReorderableListView problems
          if (newIndex > itemCount) {
            newIndex = itemCount;
          }
          if (oldIndex < newIndex) {
            newIndex --;
          }
          if (newIndex != oldIndex) {
            reorderCallback(oldIndex, newIndex);
          }
        },
        padding: padding,
        buildDefaultDragHandles: false,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        proxyDecorator: (Widget child, int index, Animation<double> animation) {
          return _HapticItem(
            Center(
              child: getTabletAdaptiveWidthBox(
                context,
                DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        spreadRadius: 4.0,
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HapticItem extends StatefulWidget {

  _HapticItem(this.child): super();

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _HapticItemState();
  }
}

class _HapticItemState extends State<_HapticItem> {

  @override
  void initState() {
    super.initState();
    haptic();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}