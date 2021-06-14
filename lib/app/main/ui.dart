import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';

class MainAppBar extends StatefulWidget {

  MainAppBar(Key key, this.themeManager, {
    this.title,
    this.scrollOffset,
    this.headerHeight,
  }): super(key: key);

  final ThemeManager themeManager;
  final double headerHeight;

  final String title;
  final double scrollOffset;

  @override
  State<StatefulWidget> createState() {
    return MainAppBarState();
  }
}

class MainAppBarState extends State<MainAppBar> {

  String _title;
  double _scrollOffset;
  double _headerHeight;

  @override
  void initState() {
    super.initState();

    _title = widget.title;
    _scrollOffset = widget.scrollOffset;
    _headerHeight = widget.headerHeight;
  }

  @override
  void didUpdateWidget(covariant MainAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(widget.title, widget.scrollOffset, widget.headerHeight);
  }

  void update(String title, double scrollOffset, double headerHeight) {
    setState(() {
      _title = title;
      _scrollOffset = scrollOffset;
      _headerHeight = headerHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = getAppBarHeight(context);

    return Transform.translate(
      offset: Offset(
        0.0,
        Platform.isIOS ? 0 : (
            _scrollOffset > _headerHeight - appBarHeight - 162.0
                ? (_headerHeight - appBarHeight - 162.0 - _scrollOffset)
                : 0
        ),
      ),
      child: _getAppBar(
          context,
          _title,
          widget.themeManager,
          _scrollOffset > _headerHeight
      ),
    );
  }
}

Widget _getAppBar(
    BuildContext context,
    String title,
    ThemeManager themeManager,
    bool headerHidden) {

  // todo: tablet.

  if (Platform.isIOS) {
    return SizedBox(
      width: double.infinity,
      height: getAppBarHeight(context),
      child: PlatformAppBar(
        leading: _getSettingsIcon(context, themeManager, headerHidden),
        title: Text(title,
            style: headerHidden
                ? TextStyle(color: themeManager.isLightTheme(context) ? Colors.black : Colors.white)
                : TextStyle(color: Colors.white)
        ),
        trailingActions: [ _getManagementIcon(context, themeManager, headerHidden) ],
        backgroundColor: Colors.transparent,
        cupertino: (_, __) => CupertinoNavigationBarData(
          brightness: headerHidden
              ? (themeManager.isLightTheme(context) ? Brightness.light : Brightness.dark)
              : Brightness.dark,
        ),
      ),
    );
  }

  // material.
  return SizedBox(
    width: double.infinity,
    height: getAppBarHeight(context),
    child: PlatformAppBar(
      title: Text(title),
      trailingActions: [
        _getManagementIcon(context, themeManager, false),
        _getSettingsIcon(context, themeManager, false)
      ],
      backgroundColor: Colors.transparent,
      material: (_, __) => MaterialAppBarData(
          brightness: Brightness.dark,
          elevation: 0
      ),
    ),
  );
}

Widget _getManagementIcon(
    BuildContext context,
    ThemeManager themeManager,
    bool iOSHeaderHidden) => _PlatformAppBarIconButton(context,
  materialIconData: Icons.domain,
  cupertinoIconData: CupertinoIcons.building_2_fill,
  themeManager: themeManager,
  iOSHeaderHidden: iOSHeaderHidden,
  onPressed: () {
  // todo: management.
  },
);

Widget _getSettingsIcon(
    BuildContext context,
    ThemeManager themeManager,
    bool iOSHeaderHidden) => _PlatformAppBarIconButton(context,
  materialIconData: Icons.settings_outlined,
  cupertinoIconData: CupertinoIcons.settings,
  themeManager: themeManager,
  iOSHeaderHidden: iOSHeaderHidden,
  onPressed: () {
    Navigator.pushNamed(context, Routers.ROUTER_ID_ABOUT);
  },
);

class _PlatformAppBarIconButton extends PlatformIconButton {

  _PlatformAppBarIconButton(BuildContext context, {
    IconData materialIconData,
    IconData cupertinoIconData,
    ThemeManager themeManager,
    bool iOSHeaderHidden,
    void Function() onPressed
  }): super(
      materialIcon: Icon(materialIconData),
      cupertinoIcon: Icon(cupertinoIconData,
          color: iOSHeaderHidden
              ? (themeManager.isLightTheme(context) ? CupertinoColors.black : CupertinoColors.white)
              : CupertinoColors.white
      ),
      cupertino: (_, __) => CupertinoIconButtonData(
          padding: EdgeInsets.zero
      ),
      onPressed: onPressed
  );
}