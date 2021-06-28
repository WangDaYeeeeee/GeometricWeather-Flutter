import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/app_bar.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/search/page_search.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

Widget getManagementAppBar(
    BuildContext context,
    MainViewModel viewModel,
    GlobalKey<SnackBarContainerState> snackBarKey,
    bool fragment) {

  if (Platform.isIOS) {
    if (fragment) {
      return Column(children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
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
                      Navigator.pushNamed(
                          context,
                          Routers.ROUTER_ID_SEARCH
                      ).then((value) {
                        if (value != null && value is Location) {
                          _onAddLocation(context, viewModel, snackBarKey, value);
                        }
                      });
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
            Navigator.pushNamed(
                context,
                Routers.ROUTER_ID_SEARCH
            ).then((value) {
              if (value != null && value is Location) {
                _onAddLocation(context, viewModel, snackBarKey, value);
              }
            });
          },
        ),
      ],
    );
  }

  // android.

  final appBarHeight = getAppBarHeight(context);
  final statusBarHeight = MediaQuery.of(context).padding.top;

  return GeoPlatformAppBar(context,
    title: SizedBox(
      height: appBarHeight - statusBarHeight,
      child: Padding(
        padding: EdgeInsets.only(
          top: littleMargin,
          bottom: littleMargin,
        ),
        child: Hero(
          tag: HERO_TAG_SEARCH_BAR,
          child: Card(
            child: PlatformInkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: normalMargin,
                      right: normalMargin,
                    ),
                    child: Icon(Icons.search,
                      color: Theme.of(context).textTheme.caption?.color,
                    ),
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
              onTap: () {
                Navigator.pushNamed(
                    context,
                    Routers.ROUTER_ID_SEARCH
                ).then((value) {
                  if (value != null && value is Location) {
                    _onAddLocation(context, viewModel, snackBarKey, value);
                  }
                });
              },
            ),
            color: Theme.of(context).dividerColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(
                        (appBarHeight - statusBarHeight - 2 * littleMargin) / 2.0
                    )
                )
            ),
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(0.0),
          ),
        ),
      ),
    ),
    automaticallyImplyLeading: false,
  );
}

void _onAddLocation(
    BuildContext context,
    MainViewModel viewModel,
    GlobalKey<SnackBarContainerState> snackBarKey,
    Location location) {
  viewModel.addLocation(location);

  snackBarKey.currentState?.show(S.of(context).feedback_collect_succeed);
}