// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

const FLOW_ANIMATION_DURATION = 500;

class OnetimeFlowAnimatedListView extends StatelessWidget {

  OnetimeFlowAnimatedListView({
    Key? key,
    required this.builder,
    required this.itemCount,
    this.scrollController,
    this.baseItemAnimationDuration = FLOW_ANIMATION_DURATION,
    this.initItemOffsetY = 50.0,
    this.initItemScale = 1.1,
  }): super(key: key);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final ScrollController? scrollController;

  final int baseItemAnimationDuration;
  final double initItemOffsetY;
  final double initItemScale;

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
                curve: Curves.easeOutBack,
                child: ScaleAnimation(
                  scale: initItemScale,
                  curve: Curves.easeOutSine,
                  child: FadeInAnimation(
                    child: builder(context, index),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}