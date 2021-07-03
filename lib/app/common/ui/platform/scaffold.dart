// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';

class GeoPlatformScaffold extends PlatformScaffold {

  GeoPlatformScaffold({
    Key? key,
    PlatformAppBar? appBar,
    Widget? body,
  }) : super(
    key: key,
    appBar: appBar,
    body: InsetsCompatBodyWrapper(body: body),
    material: (BuildContext context, PlatformTarget platform) {
      return MaterialScaffoldData(resizeToAvoidBottomInset: false);
    }
  );
}