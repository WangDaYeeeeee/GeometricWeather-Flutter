import 'package:flutter/widgets.dart';

final routeObserver = RouteObserver<PageRoute>();

abstract class GeoStatefulWidget extends StatefulWidget {

  GeoStatefulWidget({Key key}) : super(key: key);
}

abstract class GeoState<T extends GeoStatefulWidget> extends State<T>
    with RouteAware, WidgetsBindingObserver {

  bool topLevelWidget = true;
  bool appResumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
  }

  void onVisibilityChanged(bool visible) {
    // do nothing.
  }

  @override
  void didPush() {
    topLevelWidget = true;
    onVisibilityChanged(topLevelWidget && appResumed);
  }

  @override
  void didPop() {
    topLevelWidget = false;
    onVisibilityChanged(topLevelWidget && appResumed);
  }

  @override
  void didPushNext() {
    topLevelWidget = false;
    onVisibilityChanged(topLevelWidget && appResumed);
  }

  @override
  void didPopNext() {
    topLevelWidget = true;
    onVisibilityChanged(topLevelWidget && appResumed);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      appResumed = true;
      onVisibilityChanged(topLevelWidget && appResumed);
    } else if (state == AppLifecycleState.paused) {
      appResumed = false;
      onVisibilityChanged(topLevelWidget && appResumed);
    }
  }
}