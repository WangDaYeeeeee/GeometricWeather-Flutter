// @dart=2.12

import 'package:flutter/widgets.dart';

import 'model.dart';
import 'snackbar.dart';

class SnackBarContainer extends StatefulWidget {

  SnackBarContainer({
    Key? key,
    this.child
  }): super(key: key);

  final Widget? child;

  @override
  State<StatefulWidget> createState() {
    return SnackBarContainerState();
  }
}

class SnackBarContainerState extends State<SnackBarContainer> {

  SnackBarModel? _currentSnackBar;
  SnackBarModel? _nextSnackBar;

  GlobalKey<SnackBarViewState> _snackBarKey = GlobalKey();

  @override
  void didUpdateWidget(covariant SnackBarContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      // check update.
    });
  }

  SnackBarModel show(String content, {
    int duration = DURATION_SHORT,
    String? action,
    VoidCallback? actionCallback,
    VoidCallback? dismissCallback,
  }) {
    final snackBarStatus = _snackBarKey.currentState?.status;
    final dismissCallbackWrap = () {
      setState(() {
        _currentSnackBar = _nextSnackBar;
        _nextSnackBar = null;

        _snackBarKey = GlobalKey();
      });

      dismissCallback?.call();
    };

    SnackBarModel result;

    if (_currentSnackBar == null || snackBarStatus == null) {
      // there is not a snack bar is been showing.
      result = SnackBarModel(content,
          action: action,
          actionCallback: actionCallback,
          dismissCallback: dismissCallbackWrap,
          duration: duration
      );
      setState(() {
        _currentSnackBar = result;
        _snackBarKey = GlobalKey();
      });
    } else {
      _snackBarKey.currentState?.hide();
      result = SnackBarModel(content,
          action: action,
          actionCallback: actionCallback,
          dismissCallback: dismissCallbackWrap,
          duration: duration
      );
      _nextSnackBar = result;
    }

    return result;
  }

  void dismiss(SnackBarModel target) {
    if (target == _currentSnackBar) {
      _snackBarKey.currentState?.hide();
    } else if (target == _nextSnackBar) {
      _nextSnackBar = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (widget.child != null) {
      children.add(
        Align(
          alignment: Alignment.center,
          child: widget.child!,
        )
      );
    }
    if (_currentSnackBar != null) {
      children.add(
        Align(
          alignment: Alignment.bottomCenter,
          child: SnackBarView(
            key: _snackBarKey,
            model: _currentSnackBar!,
          ),
        )
      );
    }

    return Stack(children: children);
  }
}