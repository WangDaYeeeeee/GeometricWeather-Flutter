import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';

double appBarHeight;

Widget getAppBar(
    BuildContext context,
    String title,
    ThemeManager themeManager,
    double scrollOffset,
    double headerHeight) {
  if (appBarHeight == null) {
    appBarHeight = getAppBarHeight(context);
  }

  return Transform.translate(
    offset: Offset(
        0.0,
        Platform.isIOS ? 0 : (
            scrollOffset > headerHeight - appBarHeight - 162.0
                ? (headerHeight - appBarHeight - 162.0 - scrollOffset)
                : 0
        ),
    ),
    child: _getAppBar(
        context,
        title,
        themeManager,
        scrollOffset > headerHeight
    ),
  );
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

class InitializationAnimation extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _InitializationAnimationState();
  }
}

class _InitializationAnimationState extends State<InitializationAnimation>
    with TickerProviderStateMixin {

  AnimationController _rotationAnimController;
  Animation<double> _rotationAnimation;
  ResourceProvider _resProvider;

  static const int ANIM_CYCLE_DURATION = 5000;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _rotationAnimController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_rotationAnimController == null) {
      _rotationAnimController = AnimationController(
        duration: const Duration(milliseconds: ANIM_CYCLE_DURATION),
        vsync: this,
      );

      _rotationAnimation = Tween(begin: 0.0, end: 5.0).animate(
          CurvedAnimation(
              parent: _rotationAnimController,
              curve: Curves.easeInOutBack
          )
      );
      _rotationAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _rotationAnimController.forward(from: 0.0);
        }
      });
      _rotationAnimController.forward(from: 0.0);

      _resProvider = ResourceProvider(context, DefaultResourceProvider.PROVIDER_ID);
    }

    return Center(
      child: RotationTransition(
        child: Image(
          image: _resProvider.getSunDrawable(),
          width: 128.0,
          height: 128.0,
        ),
        turns: _rotationAnimation,
      ),
    );
  }
}