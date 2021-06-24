import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_refresh.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/main/items/_base.dart';
import 'package:geometricweather_flutter/app/main/page_management.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/app/main/appbar_main.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:ink_page_indicator/ink_page_indicator.dart';
import 'package:provider/provider.dart';

import 'models.dart';

final _InitializationHolder _initHolder = _InitializationHolder();
class _InitializationHolder {

  MainViewModel viewModel;
  bool initFlag = true;

  Future<ThemeProvider> getViewModelInstance() async {
    viewModel = await MainViewModel.getInstance();
    return viewModel.themeManager.themeProvider;
  }

  void checkToInitialize() {
    if (!initFlag) {
      return;
    }
    initFlag = false;

    viewModel.init();
  }
}
Future<ThemeProvider> preloadMainViewModel() => _initHolder.getViewModelInstance();

const SWITCH_DURATION = 350;

enum _MainListState {
  noCache, loadingWithoutCache, hasCache,
}

class MainPage extends GeoStatefulWidget {

  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends GeoState<MainPage>
    with TickerProviderStateMixin {

  GlobalKey<SnackBarContainerState> _snackBarContainerKey = GlobalKey();
  GlobalKey<WeatherViewState> _weatherViewKey = GlobalKey();
  GlobalKey<NestedRefreshIndicatorState> _refreshIndicatorKey = GlobalKey();
  GlobalKey<MainAppBarState> _appBarKey = GlobalKey();

  ScrollController _scrollController = new ScrollController();

  String _currentLocationFormattedId;
  WeatherSource _currentWeatherSource;
  bool _currentLightTheme;
  int _currentWeatherTimeStamp;

  LiveData<_MainListState> _listState = LiveData(null);
  bool _swipeRefreshing = false;

  int _switchPreviewOffset = 0;

  double _scrollOffset = 0;
  double _headerHeight;

  VoidCallback _onEventChanged;

  @override
  void initState() {
    super.initState();
    _initHolder.checkToInitialize();
    _ensureListState();

    _initHolder.viewModel.themeManager.registerWeatherViewThemeDelegate(
        MaterialWeatherViewThemeDelegate()
    );
    _initHolder.viewModel.event.addListener(_onEventChanged = () {
      // list state.
      _ensureListState();

      // refresh.
      _swipeRefreshing = _initHolder.viewModel.event.value.status == ResourceStatus.LOADING
          && _initHolder.viewModel.event.value.initStage == InitializationStage.INITIALIZATION_DONE;
      if (_swipeRefreshing) {
        _refreshIndicatorKey.currentState?.show();
      }

      // feedback.
      switch (_initHolder.viewModel.event.value.locationEvent) {
        case LocationEvent.GET_GEO_POSITION_FAILED:
        case LocationEvent.LOCATOR_FAILED:
        case LocationEvent.LOCATOR_DISABLED:
          _snackBarContainerKey.currentState?.show(
              S.of(context).feedback_location_failed,
          );
          break;

        case LocationEvent.LOCATOR_PERMISSION_DENIED:
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_request_location_permission_failed,
          );
          break;

        case LocationEvent.GET_WEATHER_FAILED:
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_get_weather_failed,
          );
          break;

        case LocationEvent.UPDATE_FROM_BACKGROUND:
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_updated_in_background,
          );
          break;

        default:
          break;
      }
    });

    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset;
      _weatherViewKey.currentState?.onScroll(_scrollOffset);
      _appBarKey.currentState?.update(
          _getAppBarTitle(),
          _scrollOffset,
          _headerHeight ?? _getHeaderHeight(),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _initHolder.viewModel.dispose(context);
    _initHolder.viewModel.event.removeListener(_onEventChanged);
    _initHolder.viewModel.themeManager.unregisterWeatherViewThemeDelegate();

    super.dispose();
  }

  @override
  void onVisibilityChanged(bool visible) {
    if (visible) {
      _initHolder.viewModel.checkToUpdate();
    }
    _weatherViewKey.currentState?.drawable = visible;
  }

  @override
  Widget build(BuildContext context) {
    _headerHeight = _getHeaderHeight();
    final bool lightTheme = Theme.of(context).brightness == Brightness.light;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _initHolder.viewModel.currentLocation),
        ChangeNotifierProvider.value(value: _listState),
        ChangeNotifierProvider.value(value: _initHolder.viewModel.indicator),
      ],
      child: PlatformScaffold(
        body: SnackBarContainer(
          key: _snackBarContainerKey,
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape && isTabletDevice(context)) {
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 380.0,
                      height: double.infinity,
                      child: _getManagementFragment(context),
                    ),
                    Expanded(
                      child: _getMainFragment(context, lightTheme),
                    ),
                  ],
                );
              }

              return _getMainFragment(context, lightTheme);
            },
          ),
        ),
      ),
    );
  }

  Widget _getManagementFragment(BuildContext context) {
    return ManagementFragment(
      viewModel: _initHolder.viewModel,
      snackBarKey: _snackBarContainerKey,
    );
  }

  Widget _getMainFragment(BuildContext context, bool lightTheme) {
    return Consumer<LiveData<Location>>(builder: (_, currentLocation, __) {
      return Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          MaterialWeatherView(
            key: _weatherViewKey,
            weatherKind: _getWeatherKind(),
            daylight: _isWeatherViewDaylight(),
          ),
          SwipeSwitchLayout(
            child: NestedRefreshIndicator(
              key: _refreshIndicatorKey,
              child: Consumer<LiveData<_MainListState>>(builder: (_, listState, __) {
                switch (listState.value) {
                  case _MainListState.noCache:
                    return PlatformInkWell(
                      child: Container(),
                      onTap: () {
                        _initHolder.viewModel.updateWeather(context);
                      },
                    );

                  case _MainListState.loadingWithoutCache:
                    return Center(
                      child: Platform.isIOS ? Theme(
                          data: ThemeData(
                              cupertinoOverrideTheme: CupertinoThemeData(
                                  brightness: Brightness.dark
                              )
                          ),
                          child: CupertinoActivityIndicator(
                            radius: 12.0,
                          )
                      ) : CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );

                  default:
                    return _getListView(currentLocation.value);
                }
              }),
              edgeOffset: getAppBarHeight(context),
              onRefresh: _onRefresh,
              color: _initHolder.viewModel.themeManager.getWeatherThemeColors(
                  context,
                  currentLocation.value.currentWeatherCode,
                  _initHolder.viewModel.themeManager.daytime,
                  lightTheme
              )[0],
            ),
            swipeEnabled: (
                _initHolder.viewModel.validLocationList?.length ?? 0
            ) > 1,
            onSwipe: _onSwiping,
            onSwitch: _onSwitch,
          ),
          MainAppBar(
            _appBarKey,
            _initHolder.viewModel.themeManager,
            title: _getAppBarTitle(),
            scrollOffset: _scrollOffset,
            headerHeight: _headerHeight,
          ),
          Consumer<LiveData<Indicator>>(builder: (_, indicator, __) {
            final color = Theme
                .of(context)
                .textTheme
                .bodyText2
                .color;

            return Visibility(
              visible: indicator.value.total > 1,
              child: Positioned(
                bottom: 0,
                child: SafeArea(
                  child: getTabletAdaptiveWidthBox(
                    context,
                    InkPageIndicator(
                      page: ValueNotifier(indicator.value.index.toDouble()),
                      pageCount: indicator.value.total,
                      gap: 8.0,
                      padding: 16.0,
                      shape: IndicatorShape.circle(4.0),
                      activeColor: color,
                      inactiveColor: color.withAlpha((255 * 0.1).toInt()),
                      inkColor: color.withAlpha((255 * 0.1).toInt()),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  void _ensureListState() {
    if (_initHolder.viewModel.event.value.data.weather == null) {
      if (_initHolder.viewModel.event.value.status == ResourceStatus.LOADING) {
        _listState.value = _MainListState.loadingWithoutCache;

        _initHolder.viewModel.updateWeather(context);
      } else {
        _listState.value = _MainListState.noCache;
      }
    } else {
      _listState.value = _MainListState.hasCache;
    }
  }

  Widget _getListView(Location location) {
    bool executeAnimation = true;
    if (location.formattedId == _currentLocationFormattedId
        && location.weatherSource == _currentWeatherSource
        && location.weather != null
        && location.weather.base.timeStamp == _currentWeatherTimeStamp
        && _currentLightTheme != null
        && _currentLightTheme == _initHolder.viewModel.themeManager.isLightTheme(context)) {
      executeAnimation = false;
    }

    _currentLocationFormattedId = location.formattedId;
    _currentWeatherSource = location.weatherSource;
    _currentLightTheme = _initHolder.viewModel.themeManager.isLightTheme(context);
    _currentWeatherTimeStamp = location.weather?.base?.timeStamp ?? -1;

    return getList(
      context,
      _scrollController,
      _weatherViewKey,
      _initHolder.viewModel.settingsManager,
      _initHolder.viewModel.themeManager,
      location.weather,
      location.timezone,
      executeAnimation,
      () {
        Timer.run(() {
          _weatherViewKey.currentState?.onScroll(0);
          _appBarKey.currentState?.update(
            _getAppBarTitle(),
            0,
            _headerHeight ?? _getHeaderHeight(),
          );
        });
      }
    );
  }

  WeatherKind _getWeatherKind() => weatherCodeToWeatherKind(
      _switchPreviewOffset == 0
          ? _initHolder.viewModel.currentLocation.value.currentWeatherCode
          : _initHolder.viewModel.getLocationFromList(_switchPreviewOffset).currentWeatherCode
  );

  bool _isWeatherViewDaylight() => _switchPreviewOffset == 0
      ? _initHolder.viewModel.themeManager.daytime
      : isDaylightLocation(_initHolder.viewModel.getLocationFromList(_switchPreviewOffset));

  String _getAppBarTitle() => _switchPreviewOffset == 0 ? getLocationName(
      context,
      _initHolder.viewModel.currentLocation.value
  ) : getLocationName(
      context,
      _initHolder.viewModel.getLocationFromList(_switchPreviewOffset)
  );

  double _getHeaderHeight() =>
      _initHolder.viewModel.themeManager.getHeaderHeight(context);

  void _resetUIUpdateFlag() {
    _currentLocationFormattedId = null;
    _currentWeatherSource = null;
    _currentWeatherTimeStamp = -1;
  }

  bool _isValidUIUpdateFlag() {
    return _currentLocationFormattedId != null
        && _currentWeatherSource != null
        && _currentWeatherTimeStamp != -1;
  }

  Future<void> _onRefresh() async {
    _swipeRefreshing = true;

    _initHolder.viewModel.updateWeather(context);

    while (_swipeRefreshing) {
      await Future.delayed(Duration(milliseconds: 32));
    }
  }

  void _onSwiping(double progress) {
    if (_switchPreviewOffset == 0) {
      if (progress.abs() >= 1) {
        _switchPreviewOffset = progress > 0 ? 1 : -1;
        _weatherViewKey.currentState?.setWeather(
          _getWeatherKind(),
          _isWeatherViewDaylight()
        );
      }
    } else {
      if (progress.abs() <= 0.5) {
        _switchPreviewOffset = 0;
        _weatherViewKey.currentState?.setWeather(
            _getWeatherKind(),
            _isWeatherViewDaylight()
        );
      }
    }
  }

  Future<void> _onSwitch(int positionChanging) async {
    _resetUIUpdateFlag();

    // switch location.
    _initHolder.viewModel.offsetLocation(positionChanging);

    // wait widget tree building.
    while (!_isValidUIUpdateFlag()) {
      await Future.delayed(Duration(milliseconds: 32));
    }
  }
}