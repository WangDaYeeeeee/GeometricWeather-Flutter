// @dart=2.12

import 'package:flutter/widgets.dart';

class SearchBarTween extends RectTween {
  
  SearchBarTween({
    Rect? begin,
    Rect? end
  }) : super(
    begin: begin, 
    end: end
  );

  @override
  Rect lerp(double t) {
    if (begin == null || end == null) {
      return end ?? Rect.zero;
    }

    final verticalT = Curves.easeOutCubic.transform(t);
    final horizontalT = Curves.easeInCubic.transform(t);

    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, horizontalT),
      lerpDouble(begin!.top, end!.top, verticalT),
      lerpDouble(begin!.right, end!.right, horizontalT),
      lerpDouble(begin!.bottom, end!.bottom, verticalT),
    );
  }

  double lerpDouble(num a, num b, double t) {
    return a + (b - a) * t;
  }
}