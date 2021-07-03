import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/app_bar.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

Widget getAppBar(
    BuildContext context,
    FocusNode focusNode,
    ValueChanged<String> onSubmitCallback) {

  final appBarHeight = getAppBarHeight(context);
  final statusBarHeight = MediaQuery.of(context).padding.top;

  return GeoPlatformAppBar(context,
    leading: Platform.isAndroid ? PlatformIconButton(
      materialIcon: Icon(Icons.arrow_back,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      cupertinoIcon: Icon(CupertinoIcons.back),
      onPressed: () {
        Navigator.pop(context);
      }
    ) : GeoPlatformAppBarBackLeading(context,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: SizedBox(
      height: appBarHeight - statusBarHeight,
      child: Padding(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 3.0 : 0.0
        ),
        child: PlatformTextField(
          autofocus: Platform.isIOS,
          focusNode: focusNode,
          hintText: S.of(context).feedback_search_location,
          textInputAction: TextInputAction.search,
          onSubmitted: onSubmitCallback,
          material: (context, _) => MaterialTextFieldData(
            style: Theme.of(context).textTheme.subtitle2,
            decoration: InputDecoration(border: InputBorder.none),
          ),
          cupertino: (context, _) => CupertinoTextFieldData(
            style: Theme.of(context).textTheme.subtitle2,
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ),
    ),
    backgroundColor: Platform.isIOS
        ? getCupertinoAppBarBackground(context)
        : Theme.of(context).dividerColor,
  );
}