import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/theme.dart';

class PlatformAppBarIconButton extends PlatformIconButton {

  PlatformAppBarIconButton(BuildContext context, {
    IconData materialIconData,
    IconData cupertinoIconData,
    void Function() onPressed
  }): super(
    materialIcon: Icon(materialIconData),
    cupertinoIcon: Icon(cupertinoIconData,
        color: Theme.of(context).brightness == Brightness.light
            ? CupertinoColors.black
            : CupertinoColors.white
    ),
    cupertino: (_, __) => CupertinoIconButtonData(
        padding: EdgeInsets.zero
    ),
    onPressed: onPressed
  );
}

class GeoPlatformAppBarBackLeading extends PlatformAppBarIconButton {

  GeoPlatformAppBarBackLeading(BuildContext context, {
    void Function() onPressed
  }): super(context,
      materialIconData: Icons.arrow_back,
      cupertinoIconData: CupertinoIcons.back,
      onPressed: onPressed
  );
}

class GeoPlatformAppBar extends PlatformAppBar {

  GeoPlatformAppBar(BuildContext context, {
    Key key,
    Key widgetKey,
    Widget title,
    Color backgroundColor,
    Widget leading,
    List<Widget> trailingActions,
    bool automaticallyImplyLeading
  }) : super(
    key: key,
    widgetKey: widgetKey,
    title: title,
    backgroundColor: backgroundColor,
    leading: leading,
    trailingActions: trailingActions,
    automaticallyImplyLeading: automaticallyImplyLeading,
    material: (_,  __) => MaterialAppBarData(
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).primaryColor
    ),
    cupertino: (_, __) => CupertinoNavigationBarData(
        brightness: Theme.of(context).brightness,
        backgroundColor: getCupertinoAppbarBackground(context)
    )
  );
}

class GeoPlatformAppBarTitle extends Text {

  GeoPlatformAppBarTitle(BuildContext context, String data) : super(data,
    style: Platform.isIOS
        ? TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? CupertinoColors.black
                : CupertinoColors.white
        ) : null
  );
}