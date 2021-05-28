import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';

Widget getAppBar(BuildContext context, String title) {

  // todo: tablet.

  if (Platform.isIOS) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: kToolbarHeight + MediaQuery.of(context).padding.top
      ),
      child: PlatformAppBar(
        leading: _getSettingsIcon(context),
        title: Text(title,
          style: TextStyle(color: Colors.white)
        ),
        trailingActions: [ _getManagementIcon(context) ],
        backgroundColor: Colors.transparent,
        material: (_, __) => MaterialAppBarData(
            brightness: Brightness.dark,
            elevation: 0
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          brightness: Brightness.dark,
        ),
      ),
    );
  }

  return ConstrainedBox(
    constraints: BoxConstraints(
        maxHeight: kToolbarHeight + MediaQuery.of(context).padding.top
    ),
    child: PlatformAppBar(
      title: Text(title),
      trailingActions: [
        _getManagementIcon(context),
        _getSettingsIcon(context)
      ],
      backgroundColor: Colors.transparent,
      material: (_, __) => MaterialAppBarData(
          brightness: Brightness.dark,
          elevation: 0
      ),
      cupertino: (_, __) => CupertinoNavigationBarData(
        brightness: Brightness.dark,
      ),
    ),
  );
}

Widget _getManagementIcon(BuildContext context) => _PlatformAppBarIconButton(context,
  materialIconData: Icons.domain,
  cupertinoIconData: CupertinoIcons.building_2_fill,
  onPressed: () {
  // todo: management.
  },
);

Widget _getSettingsIcon(BuildContext context) => _PlatformAppBarIconButton(context,
  materialIconData: Icons.settings_outlined,
  cupertinoIconData: CupertinoIcons.settings,
  onPressed: () {
    Navigator.pushNamed(context, Routers.ROUTER_ID_ABOUT);
  },
);

class _PlatformAppBarIconButton extends PlatformIconButton {

  _PlatformAppBarIconButton(BuildContext context, {
    IconData materialIconData,
    IconData cupertinoIconData,
    void Function() onPressed
  }): super(
      materialIcon: Icon(materialIconData),
      cupertinoIcon: Icon(cupertinoIconData,
          color: CupertinoColors.white
      ),
      cupertino: (_, __) => CupertinoIconButtonData(
          padding: EdgeInsets.zero
      ),
      onPressed: onPressed
  );
}