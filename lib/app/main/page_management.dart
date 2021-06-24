import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/onetime_flow_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/main/appbar_management.dart';
import 'package:geometricweather_flutter/app/main/models.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:provider/provider.dart';

class ManagementPage extends StatelessWidget {

  ManagementPage({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final MainViewModel viewModel;

  final GlobalKey<SnackBarContainerState> _snackBarContainerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: viewModel.listResource),
      ],
      child: PlatformScaffold(
        appBar: getManagementAppBar(context, false),
        body: SnackBarContainer(
          key: _snackBarContainerKey,
          child: _ManagementBody(
            viewModel: viewModel,
            snackBarKey: _snackBarContainerKey,
            onItemClickedCallback: () {
              Navigator.of(context).pop();
            },
          ),
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
        getManagementAppBar(context, true),
      ]),
    );
  }
}

class _ManagementBody extends StatelessWidget {

  _ManagementBody({
    Key key,
    @required this.viewModel,
    @required this.snackBarKey,
    this.topPadding = 0.0,
    this.onItemClickedCallback,
  }) : super(key: key);

  final MainViewModel viewModel;

  final GlobalKey<SnackBarContainerState> snackBarKey;

  final double topPadding;
  final VoidCallback onItemClickedCallback;

  @override
  Widget build(BuildContext context) {
    final resProvider = ResourceProvider(
        context,
        viewModel.settingsManager.resourceProviderId
    );

    return Consumer<LiveData<SelectableLocationListResource>>(builder: (_, listResource, __) {
      return Stack(children: [
        OnetimeFlowAnimatedListView(
          itemCount: listResource.value.dataList.length,
          builder: (BuildContext context, int index) {

            final location = listResource.value.dataList[index];
            final theme = Theme.of(context);

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
                  child: Text('${getLocationName(context, location)}${
                      location.weather == null ? null : (
                          ', ${location.weather.current.temperature.getTemperature(
                              context,
                              viewModel.settingsManager.temperatureUnit
                          )}'
                      )
                  }', style: theme.textTheme.subtitle1),
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

            return PlatformInkWell(
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
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 1.0);
          },
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
        ),
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