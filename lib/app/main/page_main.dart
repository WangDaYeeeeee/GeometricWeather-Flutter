import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geometricweather_flutter/app/common/basic/events.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/bus/helper.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/scaffold.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_refresh.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/platform.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/main/items/_base.dart';
import 'package:geometricweather_flutter/app/main/page_management.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/app/main/appbar_main.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:geometricweather_flutter/main.dart';
import 'package:ink_page_indicator/ink_page_indicator.dart';
import 'package:provider/provider.dart';

import 'models.dart';

final _InitializationHolder initHolder = _InitializationHolder();
class _InitializationHolder {

  MainViewModel viewModel;
  bool initFlag = true;

  Future<void> getViewModelInstance() async {
    viewModel = await MainViewModel.getInstance();
  }

  void checkToInitialize() {
    if (!initFlag) {
      return;
    }
    initFlag = false;

    viewModel.init(settingsManager, themeManager);
  }
}
Future<void> preloadMainViewModel() => initHolder.getViewModelInstance();

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

  // global key.
  GlobalKey<SnackBarContainerState> _snackBarContainerKey = GlobalKey();
  GlobalKey<WeatherViewState> _weatherViewKey = GlobalKey();
  GlobalKey<NestedRefreshIndicatorState> _refreshIndicatorKey = GlobalKey();
  GlobalKey<MainAppBarState> _appBarKey = GlobalKey();

  // ui controller.
  ScrollController _scrollController = new ScrollController();

  // cache value of ui update.
  String _currentLocationFormattedId;
  WeatherSource _currentWeatherSource;
  bool _currentLightTheme;
  int _currentWeatherTimeStamp;
  bool _currentLandscape;
  Widget _listCache;

  LocationEvent _lastLocationEvent;

  bool _lightTheme;

  int _switchPreviewOffset = 0;
  double _scrollOffset = 0;
  double _headerHeight;
  final _pageValue = ValueNotifier(0.0);

  // ui status.
  LiveData<_MainListState> _listState = LiveData(_MainListState.noCache);
  bool _swipeRefreshing = false;
  bool _updateUIWhenBecomeVisible = false;

  // listener.
  VoidCallback _onScrollChanged;
  StreamSubscription _updateUIEventSubscription;

  @override
  void initState() {
    super.initState();
    initHolder.checkToInitialize();

    initHolder.viewModel.themeManager.registerWeatherViewThemeDelegate(
        MaterialWeatherViewThemeDelegate()
    );

    if (_onScrollChanged == null) {
      _scrollController.addListener(_onScrollChanged = () {
        _scrollOffset = _scrollController.offset;
        _weatherViewKey.currentState?.onScroll(_scrollOffset);
        if (_lightTheme != null) {
          _appBarKey.currentState?.update(
              _getAppBarTitle(),
              _scrollOffset,
              _headerHeight ?? _getHeaderHeight(),
              _lightTheme,
          );
        }
      });
    }

    _updateUIEventSubscription = EventBus.on<UpdateUIEvent>().listen((event) {
      _updateUIWhenBecomeVisible = true;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _onScrollChanged = null;

    initHolder.viewModel.dispose(context);
    initHolder.viewModel.themeManager.unregisterWeatherViewThemeDelegate();

    _updateUIEventSubscription?.cancel();

    super.dispose();
  }

  @override
  void onVisibilityChanged(bool visible) {
    super.onVisibilityChanged(visible);

    if (visible) {
      initHolder.viewModel.checkToUpdate();
    }
    _weatherViewKey.currentState?.drawable = visible;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      initHolder.viewModel.checkBackgroundUpdate();
    }
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
    _headerHeight = _getHeaderHeight();
    _lightTheme = Theme.of(context).brightness == Brightness.light;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: initHolder.viewModel.currentLocation),
        ChangeNotifierProvider.value(value: initHolder.viewModel.event),
        ChangeNotifierProvider.value(value: _listState),
        ChangeNotifierProvider.value(value: initHolder.viewModel.indicator),
      ],
      child: GeoPlatformScaffold(
        body: SnackBarContainer(
          key: _snackBarContainerKey,
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (isLandscape(context) && isTabletDevice(context)) {
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 380.0,
                      height: double.infinity,
                      child: ManagementFragment(
                        viewModel: initHolder.viewModel,
                        snackBarKey: _snackBarContainerKey,
                      ),
                    ),
                    Expanded(
                      child: _getMainFragment(
                          context,
                          orientation == Orientation.landscape
                      ),
                    ),
                  ],
                );
              }

              return _getMainFragment(
                  context,
                  orientation == Orientation.landscape
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getMainFragment(
      BuildContext context,
      bool landscape) {

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Consumer<LiveData<Location>>(builder: (_, currentLocation, __) {
          return MaterialWeatherView(
            key: _weatherViewKey,
            weatherKind: _getWeatherKind(),
            daylight: _isWeatherViewDaylight(),
          );
        }),
        SwipeSwitchLayout(
          child: Consumer<LiveData<Location>>(builder: (_, currentLocation, __) {
            return NestedRefreshIndicator(
              key: _refreshIndicatorKey,
              child: Consumer<LiveData<_MainListState>>(builder: (_, listState, __) {
                switch (listState.value) {
                  case _MainListState.noCache:
                    return PlatformInkWell(
                      child: Container(),
                      onTap: () {
                        initHolder.viewModel.updateWeather();
                      },
                    );

                  case _MainListState.loadingWithoutCache:
                    return Center(
                      child: GeoPlatform.isCupertinoStyle ? Theme(
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
                    return _getListView(currentLocation.value, landscape);
                }
              }),
              edgeOffset: getAppBarHeight(context),
              onRefresh: _onRefresh,
              color: initHolder.viewModel.themeManager.getWeatherThemeColors(
                  context,
                  currentLocation.value.currentWeatherCode,
                  initHolder.viewModel.themeManager.daytime,
                  _lightTheme,
              )[0],
            );
          }),
          swipeEnabled: (
              initHolder.viewModel.validLocationList?.length ?? 0
          ) > 1,
          onSwipe: _onSwiping,
          onSwitch: _onSwitch,
        ),
        Consumer<LiveData<Location>>(builder: (_, currentLocation, __) {
          return MainAppBar(
            _appBarKey,
            initHolder.viewModel,
            title: _getAppBarTitle(),
            scrollOffset: _scrollOffset,
            headerHeight: _headerHeight,
            lightTheme: _lightTheme,
            settingsButtonCallback: () {
              Navigator.pushNamed(
                  context,
                  Routers.ROUTER_ID_SETTINGS
              ).then((value) async {
                await Future.delayed(Duration(milliseconds: 300));
              }).then((_) {
                if (_updateUIWhenBecomeVisible) {
                  _updateUIWhenBecomeVisible = false;
                  // force update ui.
                  _resetUIUpdateFlag();
                  initHolder.viewModel.offsetLocation(0);
                }
              });
            },
            managementButtonCallback: () {
              Navigator.pushNamed(context, Routers.ROUTER_ID_MANAGEMENT,
                arguments: ManagementArgument(initHolder.viewModel),
              );
            },
          );
        }),
        Consumer<LiveData<Indicator>>(builder: (_, indicator, __) {
          final color = Theme
              .of(context)
              .textTheme
              .bodyText2
              .color;
          _pageValue.value = indicator.value.index.toDouble();

          return Visibility(
            visible: indicator.value.total > 1,
            child: Positioned(
              bottom: 0,
              child: SafeArea(
                left: false,
                right: false,
                child: getTabletAdaptiveWidthBox(
                  context,
                  InkPageIndicator(
                    page: _pageValue,
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
        Consumer<LiveData<MainEvent>>(builder: (_, event, __) {
          _ensureListState(event.value);
          _ensureSwipeRefreshing(event.value);
          _ensureSnackBarNotification(event.value);
          return SizedBox(width: 0.0, height: 0.0);
        }),
      ],
    );
  }

  void _ensureListState(MainEvent event) {
    _MainListState newState;
    if (event.data.weather == null) {
      newState = event.status == ResourceStatus.LOADING
          ? _MainListState.loadingWithoutCache
          : _MainListState.noCache;
    } else {
      newState = _MainListState.hasCache;
    }

    if (newState != _listState.value) {
      _listState.value = newState;
    }
  }

  void _ensureSwipeRefreshing(MainEvent event) {
    _swipeRefreshing = initHolder.viewModel.currentLocation.value?.weather != null
        && event.status == ResourceStatus.LOADING
        && event.initStage == InitializationStage.INITIALIZATION_DONE;
    if (_swipeRefreshing) {
      _refreshIndicatorKey.currentState?.show();
    }
  }

  void _ensureSnackBarNotification(MainEvent event) {
    if (event.locationEvent == _lastLocationEvent) {
      return;
    }
    _lastLocationEvent = event.locationEvent;

    switch (event.locationEvent) {
      case LocationEvent.GET_GEO_POSITION_FAILED:
      case LocationEvent.LOCATOR_FAILED:
      case LocationEvent.LOCATOR_DISABLED:
        Timer.run(() {
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_location_failed,
          );
        });
        break;

      case LocationEvent.LOCATOR_PERMISSION_DENIED:
        Timer.run(() {
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_request_location_permission_failed,
          );
        });
        break;

      case LocationEvent.GET_WEATHER_FAILED:
        Timer.run(() {
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_get_weather_failed,
          );
        });
        break;

      case LocationEvent.UPDATE_FROM_BACKGROUND:
        Timer.run(() {
          _snackBarContainerKey.currentState?.show(
            S.of(context).feedback_updated_in_background,
          );
        });
        break;

      default:
        break;
    }
  }

  Widget _getListView(Location location, bool landscape) {
    bool executeAnimation = true;
    if (location.formattedId == _currentLocationFormattedId
        && location.weatherSource == _currentWeatherSource
        && location.weather != null
        && location.weather.base.timeStamp == _currentWeatherTimeStamp
        && _currentLightTheme != null
        && _currentLightTheme == initHolder.viewModel.themeManager.isLightTheme(context)
        && landscape == _currentLandscape) {
      executeAnimation = false;
    } else {
      Timer.run(() {
        _weatherViewKey.currentState?.onScroll(0);
        _appBarKey.currentState?.update(
          _getAppBarTitle(),
          _scrollOffset = 0,
          _headerHeight ?? _getHeaderHeight(),
          initHolder.viewModel.themeManager.isLightTheme(context)
        );
      });
    }

    _currentLocationFormattedId = location.formattedId;
    _currentWeatherSource = location.weatherSource;
    _currentLightTheme = initHolder.viewModel.themeManager.isLightTheme(context);
    _currentWeatherTimeStamp = location.weather?.base?.timeStamp ?? -1;
    _currentLandscape = landscape;

    // we need to cache the list view widget.
    // create the list view widget will consume a huge time.
    if (_listCache == null || executeAnimation) {
      _listCache = getList(
          context,
          _scrollController,
          _weatherViewKey,
          initHolder.viewModel,
          location.weather,
          location.timezone,
          executeAnimation,
      );
    }

    return _listCache;
  }

  WeatherKind _getWeatherKind() => weatherCodeToWeatherKind(
      _switchPreviewOffset == 0
          ? initHolder.viewModel.currentLocation.value.currentWeatherCode
          : initHolder.viewModel.getLocationFromList(_switchPreviewOffset).currentWeatherCode
  );

  bool _isWeatherViewDaylight() => _switchPreviewOffset == 0
      ? initHolder.viewModel.themeManager.daytime
      : isDaylightLocation(initHolder.viewModel.getLocationFromList(_switchPreviewOffset));

  String _getAppBarTitle() => _switchPreviewOffset == 0 ? getLocationName(
      context,
      initHolder.viewModel.currentLocation.value
  ) : getLocationName(
      context,
      initHolder.viewModel.getLocationFromList(_switchPreviewOffset)
  );

  double _getHeaderHeight() =>
      initHolder.viewModel.themeManager.getHeaderHeight(context);

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

    initHolder.viewModel.updateWeather();

    while (_swipeRefreshing) {
      await Future.delayed(Duration(milliseconds: 32));
    }
  }

  void _onSwiping(double progress) {
    _pageValue.value = initHolder.viewModel.indicator.value.index + max(
        -1.0,
        min(progress, 1.0)
    );

    if (_switchPreviewOffset == 0) {
      if (progress.abs() >= 1) {
        _switchPreviewOffset = progress > 0 ? 1 : -1;
        _weatherViewKey.currentState?.setWeather(
          _getWeatherKind(),
          _isWeatherViewDaylight()
        );
        _appBarKey.currentState?.update(
          _getAppBarTitle(),
          _scrollOffset,
          _headerHeight ?? _getHeaderHeight(),
          _lightTheme,
        );
      }
    } else {
      if (progress.abs() <= 0.5) {
        _switchPreviewOffset = 0;
        _weatherViewKey.currentState?.setWeather(
            _getWeatherKind(),
            _isWeatherViewDaylight()
        );
        _appBarKey.currentState?.update(
          _getAppBarTitle(),
          _scrollOffset,
          _headerHeight ?? _getHeaderHeight(),
          _lightTheme,
        );
      }
    }
  }

  Future<void> _onSwitch(int positionChanging) async {
    _switchPreviewOffset = 0;
    _pageValue.value = (
        initHolder.viewModel.indicator.value.index + positionChanging
    ).toDouble();

    _resetUIUpdateFlag();

    // switch location.
    initHolder.viewModel.offsetLocation(positionChanging);

    // wait widget tree building.
    while (!_isValidUIUpdateFlag()) {
      await Future.delayed(Duration(milliseconds: 32));
    }
  }
}