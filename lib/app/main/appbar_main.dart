import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
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
    return Platform.isIOS ? _CupertinoAppBarState() : _MaterialAppBarState();
  }
}

abstract class MainAppBarState extends State<MainAppBar> {

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
    update(
        widget.title,
        widget.scrollOffset,
        widget.headerHeight
    );
  }

  void update(String title, double scrollOffset, double headerHeight);
}

class _CupertinoAppBarState extends MainAppBarState {

  @override
  void update(String title, double scrollOffset, double headerHeight) {
    if (_title == title
        && _headerHeight == headerHeight
        && (_scrollOffset > _headerHeight) == (scrollOffset > headerHeight)) {
      _innerUpdate(title, scrollOffset, headerHeight);
    } else {
      setState(() {
        _innerUpdate(title, scrollOffset, headerHeight);
      });
    }
  }

  void _innerUpdate(String title, double scrollOffset, double headerHeight) {
    _title = title;
    _scrollOffset = scrollOffset;
    _headerHeight = headerHeight;
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = getAppBarHeight(context);
    final headerHidden = _scrollOffset > _headerHeight;

    return Transform.translate(
      offset: Offset(
        0.0,
        Platform.isIOS ? 0 : (
            _scrollOffset > _headerHeight - appBarHeight - 162.0
                ? (_headerHeight - appBarHeight - 162.0 - _scrollOffset)
                : 0
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: getAppBarHeight(context),
        child: OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
          return PlatformAppBar(
            leading: orientation == Orientation.landscape && isTabletDevice(context)
                ? null
                : _getSettingsIcon(context, widget.themeManager, headerHidden),
            title: Text(_title,
                style: _scrollOffset > _headerHeight ? TextStyle(
                    color: widget.themeManager.isLightTheme(context)
                        ? Colors.black
                        : Colors.white
                ) : TextStyle(
                    color: Colors.white
                ),
            ),
            trailingActions: orientation == Orientation.landscape && isTabletDevice(context)
                ? [_getSettingsIcon(context, widget.themeManager, headerHidden)]
                : [_getManagementIcon(context, widget.themeManager, headerHidden)],
            backgroundColor: Colors.transparent,
            cupertino: (_, __) => CupertinoNavigationBarData(
              brightness: _scrollOffset > _headerHeight ? (
                  widget.themeManager.isLightTheme(context)
                      ? Brightness.light
                      : Brightness.dark
              ) : Brightness.dark,
            ),
          );
        }),
      ),
    );
  }
}

class _MaterialAppBarState extends MainAppBarState {

  double _appBarHeight;

  @override
  void update(String title, double scrollOffset, double headerHeight) {
    if (_title == title
        && _headerHeight == headerHeight
        && !_shouldUpdateTranslation(scrollOffset)) {
      _innerUpdate(title, scrollOffset, headerHeight);
    } else {
      setState(() {
        _innerUpdate(title, scrollOffset, headerHeight);
      });
    }
  }

  void _innerUpdate(String title, double scrollOffset, double headerHeight) {
    _title = title;
    _scrollOffset = scrollOffset;
    _headerHeight = headerHeight;
  }

  bool _shouldUpdateTranslation(double newOffset) {
    if (_appBarHeight == null) {
      return true;
    }

    if (_headerHeight - _appBarHeight - 162.0 < newOffset
        && newOffset < _headerHeight - 162.0) {
      return true;
    }

    if (_headerHeight - _appBarHeight - 162.0 >= newOffset
        && _headerHeight - _appBarHeight - 162.0 < _scrollOffset) {
      return true;
    }

    if (newOffset >= _headerHeight - 162.0
        && _scrollOffset < _headerHeight - 162.0) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    _appBarHeight = getAppBarHeight(context);

    return Transform.translate(
      offset: Offset(
        0.0,
        _scrollOffset > _headerHeight - _appBarHeight - 162.0
            ? (_headerHeight - _appBarHeight - 162.0 - _scrollOffset)
            : 0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: getAppBarHeight(context),
        child: OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
          return PlatformAppBar(
            title: Text(_title),
            trailingActions: orientation == Orientation.landscape && isTabletDevice(context) ? [
              _getSettingsIcon(context, widget.themeManager, false)
            ] : [
              _getManagementIcon(context, widget.themeManager, false),
              _getSettingsIcon(context, widget.themeManager, false)
            ],
            backgroundColor: Colors.transparent,
            material: (_, __) => MaterialAppBarData(
                brightness: Brightness.dark,
                elevation: 0
            ),
          );
        }),
      ),
    );
  }
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
      Navigator.of(context).pushNamed(Routers.ROUTER_ID_MANAGEMENT);
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
        color: iOSHeaderHidden ? (
            themeManager.isLightTheme(context)
                ? CupertinoColors.black
                : CupertinoColors.white
        ) : CupertinoColors.white
      ),
      cupertino: (_, __) => CupertinoIconButtonData(
          padding: EdgeInsets.zero
      ),
      onPressed: onPressed
  );
}