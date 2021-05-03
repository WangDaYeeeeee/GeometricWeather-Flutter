import 'package:flutter/cupertino.dart';

class SwipeSwitchLayout extends StatelessWidget {

  final Widget child;
  final bool swipeEnabled;

  SwipeSwitchLayout({
    this.child,
    this.swipeEnabled = true
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,

    );
  }
}