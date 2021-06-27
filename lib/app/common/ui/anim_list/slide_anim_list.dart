// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
          return AnimationConfiguration.staggeredList(
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
          );
        },
        padding: padding,
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

          return Dismissible(
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
          );
        },
        onReorder: reorderCallback,
        padding: padding,
      ),
    );
  }
}