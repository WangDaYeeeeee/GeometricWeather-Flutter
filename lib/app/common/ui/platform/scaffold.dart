// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class GeoPlatformScaffold extends PlatformScaffold {

  GeoPlatformScaffold({
    Key? key,
    PlatformAppBar? appBar,
    Widget? body,
    Color? backgroundColor,
  }) : super(
    key: key,
    appBar: appBar,
    body: body,
    backgroundColor: backgroundColor,
    material: (BuildContext context, PlatformTarget platform) {
      return MaterialScaffoldData(resizeToAvoidBottomInset: false);
    }
  );
}