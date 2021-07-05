import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/platform.dart';

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

  @mustCallSuper
  void onVisibilityChanged(bool visible) {
    if (visible) {
      Timer.run(() {
        setSystemBarStyle();
      });
    }
  }

  void setSystemBarStyle() {
    // set style of status bar by control the brightness of app bar.
    if (GeoPlatform.isMaterialStyle) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          )
      );
    }
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