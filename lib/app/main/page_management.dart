import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/slide_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/model.dart';
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

class _ItemWidgetCache {

  final Widget item;
  final Location location;
  final bool selected;
  final bool residential;

  _ItemWidgetCache(this.item, this.location, this.selected, this.residential);
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

  final formattedIdCacheMap = Map<String, _ItemWidgetCache>();

  final double topPadding;
  final VoidCallback onItemClickedCallback;

  @override
  Widget build(BuildContext context) {
    final resProvider = ResourceProvider(
        context,
        viewModel.settingsManager.resourceProviderId
    );

    return Consumer<LiveData<SelectableLocationListResource>>(builder: (_, listResource, __) {
      Widget list = DraggableSlideAnimatedListView(
        itemCount: listResource.value.dataList.length,
        builder: (BuildContext context, int index) {

          final location = listResource.value.dataList[index];
          final theme = Theme.of(context);
          final selected = location.formattedId
              == viewModel.listResource.value.selectedId;
          final residential = location.residentPosition;

          final cache = formattedIdCacheMap[location.formattedId];
          if (cache != null
              && cache.location.weather == location.weather
              && cache.selected == selected
              && cache.residential == residential) {
            return WidgetWrapper(cache.item, ValueKey(location.formattedId));
          }

          Widget item = _getItem(
              context,
              location,
              resProvider,
              theme,
              selected,
              residential
          );

          formattedIdCacheMap[location.formattedId] = _ItemWidgetCache(
              item,
              location,
              selected,
              residential
          );
          return WidgetWrapper(item, ValueKey(location.formattedId),);
        },
        confirmCallback: (DismissDirection direction, int index) async {
          // start to end -> delete location.
          if (direction == DismissDirection.startToEnd) {
            if (viewModel.totalLocationList.length > 1) {
              return true;
            }

            snackBarKey.currentState?.show(
                S.of(context).feedback_location_list_cannot_be_null
            );
            return false;
          }

          // end to start -> set location as resident location or cancel it.
          Location location = viewModel.totalLocationList[index];
          if (!location.currentPosition) {
            viewModel.forceUpdateLocation(
                location.copyOf(residentPosition: !location.residentPosition)
            );
          } else {
            // todo: settings.
          }
          return false;
        },
        dismissCallback: (DismissDirection direction, int index) {
          final location = viewModel.deleteLocation(index);

          SnackBarModel snackBarModel;

          snackBarModel = snackBarKey.currentState?.show(
            S.of(context).feedback_delete_succeed,
            duration: DURATION_LONG,
            action: S.of(context).cancel,
            actionCallback: () {
              viewModel.addLocation(location, index);
              if (snackBarModel != null) {
                snackBarKey.currentState?.dismiss(snackBarModel);
              }
            },
          );
        },
        startBackgroundBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: PlatformIconButton(
              materialIcon: Icon(Icons.delete_outline,
                color: Colors.white,
              ),
              cupertinoIcon: Icon(CupertinoIcons.delete,
                color: Colors.white,
              ),
            ),
          );
        },
        endBackgroundBuilder: (BuildContext context, int index) {
          if (viewModel.totalLocationList[index].currentPosition) {
            return Container(
              color: ThemeColors.primaryDarkColor,
              alignment: Alignment.centerRight,
              child: PlatformIconButton(
                materialIcon: Icon(Icons.settings_outlined,
                  color: Colors.white,
                ),
                cupertinoIcon: Icon(CupertinoIcons.settings,
                  color: Colors.white,
                ),
              ),
            );
          }

          return Container(
            color: ThemeColors.colorAlert,
            alignment: Alignment.centerRight,
            child: PlatformIconButton(
              materialIcon: Icon(Icons.bookmark_outline,
                color: Colors.white,
              ),
              cupertinoIcon: Icon(CupertinoIcons.bookmark,
                color: Colors.white,
              ),
            ),
          );
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

  Widget _getItem(
      BuildContext context,
      Location location,
      ResourceProvider resProvider,
      ThemeData theme,
      bool selected,
      bool residential) {

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
        Expanded(
          child: Padding(
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
          ),
        ),
    );
    columnChildren.add(
        Padding(
          padding: EdgeInsets.only(top: normalMargin),
          child: Flex(
            direction: Axis.horizontal,
            children: iconTitle,
          ),
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

    final stackChildren = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnChildren,
      ),
    ];
    if (residential && !location.currentPosition) {
      stackChildren.add(
        Positioned(
          top: normalMargin,
          right: normalMargin,
          child: Text('●',
            style: theme.textTheme.overline?.copyWith(
              color: ThemeColors.colorAlert,
            ),
          ),
        ),
      );
    }

    return PlatformInkWell(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)
        ),
        child: Stack(children: stackChildren),
        color: selected ? theme.dividerColor : theme.cardColor,
        margin: EdgeInsets.zero,
      ),
      onTap: () {
        viewModel.setLocation(location.formattedId);
        onItemClickedCallback?.call();
      },
    );
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