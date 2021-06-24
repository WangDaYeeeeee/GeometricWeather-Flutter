import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/app_bar.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

Widget getManagementAppBar(BuildContext context, bool fragment) {
  if (Platform.isIOS) {
    if (fragment) {
      return Column(children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4.0,
              sigmaY: 4.0,
            ),
            child: SizedBox(
              height: getAppBarHeight(context) - 0.5,
              child: Container(
                color: ThemeColors.primaryColor.withAlpha(
                    (255 * 0.1).toInt()
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 12.0,
                  ),
                  child: PlatformAppBarIconButton(context,
                    materialIconData: Icons.add,
                    cupertinoIconData: CupertinoIcons.add,
                    onPressed: () {
                      // todo: search.
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: 0.5,
        )
      ]);
    }

    return GeoPlatformAppBar(context,
      leading: GeoPlatformAppBarBackLeading(context,
          onPressed: () {
            Navigator.of(context).pop();
          }
      ),
      title: GeoPlatformAppBarTitle(context, S.of(context).action_manage),
      trailingActions: [
        PlatformAppBarIconButton(context,
          materialIconData: Icons.add,
          cupertinoIconData: CupertinoIcons.add,
          onPressed: () {
            // todo: search.
          },
        ),
      ],
    );
  }

  return GeoPlatformAppBar(context,
    title: PlatformInkWell(
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: normalMargin,
                right: normalMargin,
              ),
              child: Icon(Icons.search),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: normalMargin,
              ),
              child: Text(S.of(context).feedback_search_location,
                softWrap: false,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(cardRadius)
            )
        ),
        margin: EdgeInsets.all(littleMargin),
      ),
      onTap: () {
        // todo: search.
      },
    ),
  );
}