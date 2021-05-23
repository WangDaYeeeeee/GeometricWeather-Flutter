import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformAppBarIconButton extends PlatformIconButton {

  PlatformAppBarIconButton({
    IconData materialIconData,
    IconData cupertinoIconData,
    void Function() onPressed
  }): super(
    materialIcon: Icon(materialIconData),
    cupertinoIcon: Icon(cupertinoIconData),
    cupertino: (_, __) => CupertinoIconButtonData(
        padding: EdgeInsets.zero
    ),
    onPressed: onPressed
  );
}