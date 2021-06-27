import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/slide_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/search/appbar.dart';
import 'package:geometricweather_flutter/app/search/view_model.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:provider/provider.dart';

const _ITEM_ANIM_DURATION = 400;

class SearchPage extends GeoStatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends GeoState<SearchPage> {

  final _viewModel = SearchViewModel();
  final _snackBarContainerKey = GlobalKey<SnackBarContainerState>();

  @override
  void dispose() {
    _viewModel.dispose(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel.results),
        ChangeNotifierProvider.value(value: _viewModel.loading),
      ],
      child: PlatformScaffold(
        appBar: getAppBar(context, (String value) {
          _viewModel.search(value);
        }),
        body: SnackBarContainer(
          key: _snackBarContainerKey,
          child: getTabletAdaptiveWidthBox(
            context,
            Consumer<LiveData<bool>>(builder: (_, loading, __) {
              if (loading.value) {
                return Center(
                  child: PlatformCircularProgressIndicator(),
                );
              }

              if (!isEmptyString(_viewModel.query)
                  && _viewModel.results.value.dataList.isEmpty) {
                Timer.run(() {
                  _snackBarContainerKey.currentState?.show(
                      S.of(context).feedback_search_nothing
                  );
                });
              }

              return SlideAnimatedListView(
                key: UniqueKey(),
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
                            style: theme.textTheme.bodyText2
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

                  return PlatformInkWell(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: columnChildren,
                      ),
                      margin: EdgeInsets.zero,
                    ),
                    onTap: () {
                      Navigator.pop(context, location);
                    },
                  );
                },
                baseItemAnimationDuration: _ITEM_ANIM_DURATION,
                initItemOffsetX: Platform.isIOS ? 128.0 : 0.0,
                initItemOffsetY: Platform.isIOS ? 0.0 : 128.0,
              );
            }),
          ),
        ),
      ),
    );
  }
}