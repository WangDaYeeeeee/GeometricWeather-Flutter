import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/slide_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/main/appbar_management.dart';
import 'package:geometricweather_flutter/app/main/models.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:provider/provider.dart';

const _ITEM_ANIM_DURATION = 400;

class ManagementArgument {

  final MainViewModel viewModel;

  ManagementArgument(this.viewModel);
}

class ManagementPage extends GeoStatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ManagePageState();
  }
}

class _ManagePageState extends GeoState<ManagementPage> {

  final GlobalKey<SnackBarContainerState> _snackBarContainerKey = GlobalKey();

  bool _showList = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(milliseconds: _ITEM_ANIM_DURATION), () {
      setState(() {
        _showList = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ManagementArgument;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: args.viewModel.listResource),
      ],
      child: PlatformScaffold(
        appBar: getManagementAppBar(
            context,
            args.viewModel,
            _snackBarContainerKey,
            false
        ),
        body: SnackBarContainer(
          key: _snackBarContainerKey,
          child: _showList ? _ManagementBody(
            viewModel: args.viewModel,
            snackBarKey: _snackBarContainerKey,
            onItemClickedCallback: () {
              Navigator.of(context).pop();
            },
          ) : Container(),
        ),
      ),
    );
  }
}

class ManagementFragment extends StatelessWidget {

  ManagementFragment({
    Key key,
    @required this.viewModel,
    @required this.snackBarKey,
  }) : super(key: key);

  final MainViewModel viewModel;

  final GlobalKey<SnackBarContainerState> snackBarKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: viewModel.listResource),
      ],
      child: Stack(children: [
        _ManagementBody(
          viewModel: viewModel,
          snackBarKey: snackBarKey,
          topPadding: getAppBarHeight(context),
          onItemClickedCallback: null,
        ),
        getManagementAppBar(context, viewModel, snackBarKey, true),
      ]),
    );
  }
}

class _ManagementBody extends StatelessWidget {

  _ManagementBody({
    Key key,
    @required this.viewModel,
    @required this.snackBarKey,
    this.topPadding,
    this.onItemClickedCallback,
  }) : super(key: key);

  final MainViewModel viewModel;

  final GlobalKey<SnackBarContainerState> snackBarKey;

  final formattedIdWeatherMap = Map<String, Weather>();
  final formattedIdWidgetMap = Map<String, Widget>();

  final double topPadding;
  final VoidCallback onItemClickedCallback;

  @override
  Widget build(BuildContext context) {
    final resProvider = ResourceProvider(
        context,
        viewModel.settingsManager.resourceProviderId
    );

    return Consumer<LiveData<SelectableLocationListResource>>(builder: (_, listResource, __) {
      Widget list = ReorderableSlideAnimatedListView(
        itemCount: listResource.value.dataList.length,
        builder: (BuildContext context, int index) {

          final location = listResource.value.dataList[index];
          final theme = Theme.of(context);

          final weatherCache = formattedIdWeatherMap[location.formattedId];
          final widgetCache = formattedIdWidgetMap[location.formattedId];
          if (location.weather == weatherCache && widgetCache != null) {
            return WidgetWrapper(widgetCache, ValueKey(location.formattedId));
          }

          List<Widget> columnChildren = [];

          // icon and title.
          List<Widget> iconTitle = [];
          if (location.weather != null) {
            iconTitle.add(
                Padding(
                  padding: EdgeInsets.only(
                    left: normalMargin,
                  ),
                  child: Image(
                    image: resProvider.getWeatherIcon(
                        location.weather.current.weatherCode,
                        isDaylightLocation(location)
                    ),
                    width: 24.0,
                    height: 24.0,
                  ),
                )
            );
          }
          iconTitle.add(
              Padding(
                padding: EdgeInsets.only(
                  left: normalMargin,
                  right: normalMargin,
                ),
                child: Text(location.currentPosition ? S.of(context).current_location : '${
                    getLocationName(context, location)
                }${
                    location.weather == null ? '' : (
                        ', ${location.weather.current.temperature.getTemperature(
                            context,
                            viewModel.settingsManager.temperatureUnit
                        )}'
                    )
                }', style: theme.textTheme.subtitle2),
              )
          );
          columnChildren.add(
              Padding(
                padding: EdgeInsets.only(top: normalMargin),
                child: Row(children: iconTitle),
              )
          );

          // summary.
          if (location.weather != null
              && !isEmptyString(location.weather.current.dailyForecast)) {
            columnChildren.add(
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.0,
                    left: normalMargin,
                    right: normalMargin,
                  ),
                  child: Text(location.weather.current.dailyForecast,
                      style: theme.textTheme.caption
                  ),
                )
            );
          }

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

          Widget item = PlatformInkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren,
              ),
              color: location.formattedId == listResource.value.selectedId
                  ? theme.dividerColor
                  : theme.cardColor,
              margin: EdgeInsets.zero,
            ),
            onTap: () {
              viewModel.setLocation(location.formattedId);
              onItemClickedCallback?.call();
            },
          );

          formattedIdWeatherMap[location.formattedId] = location.weather;
          formattedIdWidgetMap[location.formattedId] = item;
          return WidgetWrapper(item, ValueKey(location.formattedId),);
        },
        reorderCallback: (int oldIndex, int newIndex) {
          if(oldIndex < newIndex) {
            newIndex -= 1;
          }

          viewModel.moveLocation(oldIndex, newIndex);
        },
        padding: EdgeInsets.only(
          top: topPadding ?? MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        baseItemAnimationDuration: _ITEM_ANIM_DURATION,
        initItemOffsetX: Platform.isIOS ? 128.0 : 0.0,
        initItemOffsetY: Platform.isIOS ? 0.0 : 128.0,
      );

      return Stack(children: [
        getTabletAdaptiveWidthBox(context, list),
        Visibility(
          visible: !_containsCurrentLocation(listResource.value.dataList),
          child: Positioned(
            bottom: 0.0,
            right: 0.0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(normalMargin),
                child: FloatingActionButton(
                  child: PlatformIconButton(
                    cupertinoIcon: Icon(CupertinoIcons.location,
                      color: Colors.black,
                    ),
                    materialIcon: Icon(Icons.location_on_outlined,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: ThemeColors.colorAlert,
                  onPressed: () {

                  },
                ),
              ),
            ),
          ),
        ),
      ]);
    });
  }

  bool _containsCurrentLocation(List<Location> list) {
    for (Location l in list) {
      if (l.currentPosition) {
        return true;
      }
    }
    return false;
  }
}