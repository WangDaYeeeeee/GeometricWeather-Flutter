import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/swipe_switch_layout.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/material/mtrl_weather_view.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/main/items.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/app/main/ui.dart';
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

class MainPage extends GeoStatefulWidget {

  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

class _RootPageState extends GeoState<MainPage>
    with TickerProviderStateMixin {

  static GlobalKey<WeatherViewState> _weatherViewKey = GlobalKey();
  static GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  ScrollController _scrollController = new ScrollController();

  String _currentLocationFormattedId;
  WeatherSource _currentWeatherSource;
  bool _currentLightTheme;
  int _currentWeatherTimeStamp;

  bool _swipeRefreshing = false;

  int switchPreviewOffset = 0;

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _initHolder.checkToInitialize();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
      _weatherViewKey.currentState?.onScroll(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _initHolder.viewModel.dispose(context);
    _initHolder.viewModel.themeManager.unregisterWeatherView();

    super.dispose();
  }

  @override
  void onVisibilityChanged(bool visible) {
    if (visible) {
      _initHolder.viewModel.checkWhetherToChangeTheme(context);
    }
    _weatherViewKey.currentState?.drawable = visible;
  }

  @override
  Widget build(BuildContext context) {
    final bool lightTheme = Theme.of(context).brightness == Brightness.light;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _initHolder.viewModel.currentLocation),
        ChangeNotifierProvider.value(value: _initHolder.viewModel.indicator),
      ],
      child: PlatformScaffold(
        body: Consumer<LiveData<CurrentLocationResource>>(builder: (_, current, __) {

          _swipeRefreshing = current.value.status == ResourceStatus.LOADING;
          if (_swipeRefreshing) {
            _refreshIndicatorKey.currentState?.show();
          }

          double headerHeight = _weatherViewKey.currentState?.getHeaderHeight(context) ?? 0;

          return Stack(children: [
            MaterialWeatherView(
              key: _weatherViewKey,
              weatherKind: _getWeatherKind(),
              daylight: _initHolder.viewModel.themeManager.daytime,
              onStateCreated: () {
                // set state to refresh the color of refresh indicator.
                setState(() {});
              },
            ),
            SwipeSwitchLayout(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                child: getListView(current.value.data),
                edgeOffset: getAppBarHeight(context),
                onRefresh: _onRefresh,
                color: _getThemeColors(lightTheme)[0],
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
              ),
              swipeEnabled: (
                  _initHolder.viewModel.validLocationList?.length ?? 0
              ) > 1,
              onSwipe: _onSwiping,
              onSwitch: _onSwitch,
            ),
            getAppBar(
              context,
              switchPreviewOffset == 0 ? getLocationName(
                  context,
                  current.value.data
              ) : getLocationName(
                  context,
                  _initHolder.viewModel.getLocationFromList(switchPreviewOffset)
              ),
              _initHolder.viewModel.themeManager,
              _scrollOffset,
              headerHeight,
            )
          ]);
        })
      )
    );
  }

  Widget getListView(Location location) {
    bool executeAnimation = true;
    if (location.formattedId == _currentLocationFormattedId
        && location.weatherSource == _currentWeatherSource
        && location.weather != null
        && location.weather.base.timeStamp == _currentWeatherTimeStamp
        && _currentLightTheme != null
        && _currentLightTheme == _initHolder.viewModel.themeManager.isLightTheme(context)) {
      executeAnimation = false;
    } else if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    _currentLocationFormattedId = location.formattedId;
    _currentWeatherSource = location.weatherSource;
    _currentLightTheme = _initHolder.viewModel.themeManager.isLightTheme(context);
    _currentWeatherTimeStamp = location.weather?.base?.timeStamp ?? -1;

    return location.weather == null ? PlatformInkWell(
      onTap: _onRefresh,
    ) : getList(
      context,
      _scrollController,
      _weatherViewKey,
      _initHolder.viewModel.settingsManager,
      _initHolder.viewModel.themeManager,
      location.weather,
      executeAnimation,
    );
  }

  WeatherKind _getWeatherKind() => weatherCodeToWeatherKind(
      switchPreviewOffset == 0
          ? _initHolder.viewModel.currentLocation.value.data.currentWeatherCode
          : _initHolder.viewModel.getLocationFromList(switchPreviewOffset).currentWeatherCode
  );

  List<Color> _getThemeColors(bool lightTheme) {
    if (_weatherViewKey.currentState == null) {
      return [
        ThemeColors.primaryColor,
        ThemeColors.primaryDarkColor,
        ThemeColors.primaryAccentColor
      ];
    }
    return _weatherViewKey.currentState.getThemeColors(lightTheme);
  }

  void resetUIUpdateFlag() {
    _currentLocationFormattedId = null;
    _currentWeatherSource = null;
    _currentWeatherTimeStamp = -1;
  }

  bool isValidUIUpdateFlag() {
    return _currentLocationFormattedId != null
        && _currentWeatherSource != null
        && _currentWeatherTimeStamp != -1;
  }

  Future<void> _onRefresh() async {
    _swipeRefreshing = true;

    if (_initHolder.viewModel.currentLocation.value.initStage
        == InitializationStage.INITIALIZATION_DONE) {
      _initHolder.viewModel.updateWeather(context);
    }

    while (_swipeRefreshing) {
      await Future.delayed(Duration(milliseconds: 32));
    }
  }

  void _onSwiping(double progress) {
    if (switchPreviewOffset == 0) {
      if (progress.abs() >= 1) {
        setState(() {
          switchPreviewOffset = progress > 0 ? 1 : -1;
        });
      }
    } else {
      if (progress.abs() <= 0.5) {
        setState(() {
          switchPreviewOffset = 0;
        });
      }
    }
  }

  Future<void> _onSwitch(int positionChanging) async {
    resetUIUpdateFlag();
    _initHolder.viewModel.offsetLocation(positionChanging);

    while (!isValidUIUpdateFlag()) {
      await Future.delayed(Duration(milliseconds: 32));
    }
  }
}