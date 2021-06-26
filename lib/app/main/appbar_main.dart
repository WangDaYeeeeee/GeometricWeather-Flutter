import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/main/page_management.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';

class MainAppBar extends StatefulWidget {

  MainAppBar(Key key, this.viewModel, {
    @required this.title,
    @required this.scrollOffset,
    @required this.headerHeight,
    @required this.lightTheme,
  }): super(key: key);

  final MainViewModel viewModel;

  final String title;
  final double scrollOffset;
  final double headerHeight;
  final bool lightTheme;

  @override
  State<StatefulWidget> createState() {
    return Platform.isIOS ? _CupertinoAppBarState() : _MaterialAppBarState();
  }
}

abstract class MainAppBarState extends State<MainAppBar> {

  String _title;
  double _scrollOffset;
  double _headerHeight;
  bool _lightTheme;

  @override
  void initState() {
    super.initState();

    _title = widget.title;
    _scrollOffset = widget.scrollOffset;
    _headerHeight = widget.headerHeight;
    _lightTheme = widget.lightTheme;
  }

  @override
  void didUpdateWidget(covariant MainAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(
      widget.title,
      widget.scrollOffset,
      widget.headerHeight,
      widget.lightTheme,
    );
  }

  void update(
      String title,
      double scrollOffset,
      double headerHeight,
      bool lightTheme);
}

class _CupertinoAppBarState extends MainAppBarState {

  @override
  void update(
      String title,
      double scrollOffset,
      double headerHeight,
      bool lightTheme) {

    if (_title == title
        && _headerHeight == headerHeight
        && (_scrollOffset > _headerHeight) == (scrollOffset > headerHeight)
        && _lightTheme == lightTheme) {
      _innerUpdate(title, scrollOffset, headerHeight, lightTheme);
    } else {
      setState(() {
        _innerUpdate(title, scrollOffset, headerHeight, lightTheme);
      });
    }
  }

  void _innerUpdate(
      String title,
      double scrollOffset,
      double headerHeight,
      bool lightTheme) {

    _title = title;
    _scrollOffset = scrollOffset;
    _headerHeight = headerHeight;
    _lightTheme = lightTheme;
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
                : _getSettingsIcon(context, _lightTheme, headerHidden),
            title: Text(_title,
                style: _scrollOffset > _headerHeight ? TextStyle(
                    color: widget.viewModel.themeManager.isLightTheme(context)
                        ? Colors.black
                        : Colors.white
                ) : TextStyle(
                    color: Colors.white
                ),
            ),
            trailingActions: orientation == Orientation.landscape && isTabletDevice(context)
                ? [_getSettingsIcon(context, _lightTheme, headerHidden)]
                : [_getManagementIcon(context, widget.viewModel, _lightTheme, headerHidden)],
            backgroundColor: Colors.transparent,
            cupertino: (_, __) => CupertinoNavigationBarData(
              brightness: _scrollOffset > _headerHeight ? (
                  widget.viewModel.themeManager.isLightTheme(context)
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
  void update(
      String title,
      double scrollOffset,
      double headerHeight,
      bool lightTheme) {

    if (_title == title
        && _headerHeight == headerHeight
        && !_shouldUpdateTranslation(scrollOffset)
        && _lightTheme == lightTheme) {
      _innerUpdate(title, scrollOffset, headerHeight, lightTheme);
    } else {
      setState(() {
        _innerUpdate(title, scrollOffset, headerHeight, lightTheme);
      });
    }
  }

  void _innerUpdate(
      String title,
      double scrollOffset,
      double headerHeight,
      bool lightTheme) {

    _title = title;
    _scrollOffset = scrollOffset;
    _headerHeight = headerHeight;
    _lightTheme = lightTheme;
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
              _getSettingsIcon(context, _lightTheme, false)
            ] : [
              _getManagementIcon(context, widget.viewModel, _lightTheme, false),
              _getSettingsIcon(context, _lightTheme, false)
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
    MainViewModel viewModel,
    bool lightTheme,
    bool iOSHeaderHidden) => _PlatformAppBarIconButton(context,
  materialIconData: Icons.domain,
  cupertinoIconData: CupertinoIcons.building_2_fill,
  lightTheme: lightTheme,
  iOSHeaderHidden: iOSHeaderHidden,
  onPressed: () {
      Navigator.pushNamed(context, Routers.ROUTER_ID_MANAGEMENT,
        arguments: ManagementArgument(viewModel),
      );
  },
);

Widget _getSettingsIcon(
    BuildContext context,
    bool lightTheme,
    bool iOSHeaderHidden) => _PlatformAppBarIconButton(context,
  materialIconData: Icons.settings_outlined,
  cupertinoIconData: CupertinoIcons.settings,
  lightTheme: lightTheme,
  iOSHeaderHidden: iOSHeaderHidden,
  onPressed: () {
      Navigator.pushNamed(context, Routers.ROUTER_ID_ABOUT);
  },
);

class _PlatformAppBarIconButton extends PlatformIconButton {

  _PlatformAppBarIconButton(BuildContext context, {
    IconData materialIconData,
    IconData cupertinoIconData,
    bool lightTheme,
    bool iOSHeaderHidden,
    void Function() onPressed
  }): super(
      materialIcon: Icon(materialIconData),
      cupertinoIcon: Icon(cupertinoIconData,
        color: iOSHeaderHidden ? (
            lightTheme ? CupertinoColors.black : CupertinoColors.white
        ) : CupertinoColors.white
      ),
      cupertino: (_, __) => CupertinoIconButtonData(
          padding: EdgeInsets.zero
      ),
      onPressed: onPressed
  );
}