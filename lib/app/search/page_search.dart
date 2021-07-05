import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/slide_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/heros/durations.dart';
import 'package:geometricweather_flutter/app/common/ui/heros/tweens.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/scaffold.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/platform.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/search/appbar.dart';
import 'package:geometricweather_flutter/app/search/view_model.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:provider/provider.dart';

const _ITEM_ANIM_DURATION = 400;

const HERO_TAG_SEARCH_BAR = 'search_bar';

class SearchPage extends GeoStatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends GeoState<SearchPage> {

  final _viewModel = SearchViewModel();
  final _snackBarContainerKey = GlobalKey<SnackBarContainerState>();

  FocusNode _focusNode;
  Timer _timer;

  Key _listKey = UniqueKey();
  bool _loading = false;
  String _query = '';

  @override
  void initState() {
    super.initState();

    if (GeoPlatform.isMaterialStyle) {
      _focusNode = FocusNode();
      _timer = Timer(Duration(milliseconds: SEARCH_BAR_HERO_DURATION + 200), () {
        _focusNode?.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode?.dispose();

    _viewModel.dispose(context);

    super.dispose();
  }

  @override
  void setSystemBarStyle() {
    if (GeoPlatform.isMaterialStyle) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.black.withAlpha(androidStatusBarMaskAlpha),
            systemNavigationBarColor: Colors.transparent,
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page = MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel.loading),
      ],
      child: GeoPlatformScaffold(
        appBar: getAppBar(context, _focusNode, (String value) {
          _viewModel.search(value);
        }),
        body: Stack(children: [

          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SnackBarContainer(
              key: _snackBarContainerKey,
              child: Consumer<LiveData<bool>>(builder: (_, loading, __) {
                if (_loading != loading.value) {
                  _loading = loading.value;
                  _listKey = UniqueKey();
                }

                if (loading.value) {
                  return Center(
                    child: PlatformCircularProgressIndicator(),
                  );
                }

                if (!isEmptyString(_viewModel.query)
                    && _query != _viewModel.query
                    && _viewModel.results.value.dataList.isEmpty) {
                  _query = _viewModel.query;
                  Timer.run(() {
                    _snackBarContainerKey.currentState?.show(
                        S.of(context).feedback_search_nothing
                    );
                  });
                }

                return SlideAnimatedListView(
                  key: _listKey,
                  itemCount: _viewModel.results.value.dataList.length,
                  builder: (BuildContext context, int index) {

                    final location = _viewModel.results.value.dataList[index];
                    final theme = Theme.of(context);

                    List<Widget> columnChildren = [];

                    // title.
                    columnChildren.add(
                        Padding(
                          padding: EdgeInsets.only(
                            top: normalMargin,
                            left: normalMargin,
                            right: normalMargin,
                          ),
                          child: Text(getLocationName(context, location),
                              style: theme.textTheme.subtitle2
                          ),
                        )
                    );

                    // location.
                    columnChildren.add(
                        Padding(
                          padding: EdgeInsets.only(
                            left: normalMargin,
                            top: normalMargin,
                            right: normalMargin,
                          ),
                          child: Text(location.toString(),
                              style: theme.textTheme.caption.copyWith(
                                color: theme.textTheme.bodyText2.color,
                              )
                          ),
                        )
                    );

                    // powered by.
                    columnChildren.add(
                        Padding(
                          padding: EdgeInsets.only(
                            top: 2.0,
                            left: normalMargin,
                            right: normalMargin,
                            bottom: normalMargin,
                          ),
                          child: Text('Powered by ${location.weatherSource.url}',
                              style: theme.textTheme.overline?.copyWith(
                                color: location.weatherSource.color,
                              )
                          ),
                        )
                    );

                    // divider.
                    columnChildren.add(Divider(height: 1.0));

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      child: PlatformInkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: columnChildren,
                        ),
                        onTap: () {
                          Navigator.pop(context, location);
                        },
                      ),
                      margin: EdgeInsets.zero,
                    );
                  },
                  baseItemAnimationDuration: _ITEM_ANIM_DURATION,
                  initItemOffsetX: GeoPlatform.isCupertinoStyle ? 128.0 : 0.0,
                  initItemOffsetY: GeoPlatform.isCupertinoStyle ? 0.0 : 128.0,
                );
              }),
            ),
          ),
        ]),
      ),
    );

    return GeoPlatform.isMaterialStyle ? Hero(
      tag: HERO_TAG_SEARCH_BAR,
      child: page,
      createRectTween: (Rect begin, Rect end) {
        return SearchBarTween(
          begin: begin,
          end: end,
        );
      },
    ) : page;
  }
}