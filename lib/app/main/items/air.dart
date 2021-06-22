// @dart=2.12

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/flow_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/progress/arc_progress.dart';
import 'package:geometricweather_flutter/app/common/ui/progress/linear_progress.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

ItemGenerator airQuality = (
    BuildContext context,
    int index,
    bool initVisible,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone) {

  final theme = Theme.of(context);

  final colors = themeManager.getWeatherThemeColors(
    context,
    weather.current.weatherCode,
    themeManager.daytime,
    theme.brightness == Brightness.light,
  );

  final arcProgressKey = GlobalKey<ArcProgressViewState>();
  final keySet = Set<GlobalKey<LinearProgressViewState>>();

  double arcProgress = (weather.current.airQuality.aqiIndex ?? 0.0) / 300.0;
  arcProgress = max(0.0, arcProgress);
  arcProgress = min(1.0, arcProgress);

  final widget = getCard(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ensureTimeBar([
        Padding(
          padding: EdgeInsets.only(
            left: normalMargin,
            top: normalMargin,
            right: normalMargin,
          ),
          child: Text(S.of(context).air_quality,
            style: theme.textTheme.subtitle2?.copyWith(
              color: colors[0],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: normalMargin),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(normalMargin),
                  child: SizedBox(
                    height: 128.0,
                    child: ArcProgressView(
                      key: arcProgressKey,
                      initVisible: initVisible,
                      progress: arcProgress,
                      number: weather.current.airQuality.aqiIndex ?? 0,
                      description: weather.current.airQuality.aqiText ?? '',
                      duration: 2000 + (arcProgress * 2000).toInt(),
                      strokeWidth: 10.0,
                      beginColor: ThemeColors.colorLevel1,
                      endColor: weather.current.airQuality.getAqiColor(),
                      theme: theme,
                    ),
                  ),
                )
              ),
              Flexible(
                child: _getAirList(
                    context,
                    keySet,
                    initVisible,
                    theme,
                    weather,
                    AirQualityUnit.all[AirQualityUnit.KEY_MUGPCUM]!,
                    AirQualityCOUnit.all[AirQualityCOUnit.KEY_MGPCUM]!
                )
              ),
            ],
          ),
        ),
      ], index, context, weather, timezone),
    ),
  );

  return ItemWrapper(widget, () {
    // arc.
    arcProgressKey.currentState?.executeAnimations();
    // linear.
    for (var key in keySet) {
      key.currentState?.executeAnimations();
    }
  });
};

Widget _getAirList(
    BuildContext context,
    Set<GlobalKey<LinearProgressViewState>> keySet,
    bool initVisible,
    ThemeData theme,
    Weather weather,
    AirQualityUnit airQualityUnit,
    AirQualityCOUnit coUnit) {

  List<Widget> widgets = [];

  // pm2.5
  if (weather.current.airQuality.pm25 != null) {
    final key = GlobalKey<LinearProgressViewState>();
    keySet.add(key);

    widgets.addAll(
        _getAirItem(
          key,
          initVisible,
          theme,
          'PM2.5',
          airQualityUnit.getValueWithUnit(context, weather.current.airQuality.pm25!),
          weather.current.airQuality.pm25! / 250.0,
          weather.current.airQuality.getPm25Color(),
        )
    );
  }

  // pm10
  if (weather.current.airQuality.pm10 != null) {
    final key = GlobalKey<LinearProgressViewState>();
    keySet.add(key);

    widgets.addAll(
        _getAirItem(
          key,
          initVisible,
          theme,
          'PM10',
          airQualityUnit.getValueWithUnit(context, weather.current.airQuality.pm10!),
          weather.current.airQuality.pm10! / 420.0,
          weather.current.airQuality.getPm10Color(),
        )
    );
  }

  // so2
  if (weather.current.airQuality.so2 != null) {
    final key = GlobalKey<LinearProgressViewState>();
    keySet.add(key);

    widgets.addAll(
        _getAirItem(
          key,
          initVisible,
          theme,
          'SO₂',
          airQualityUnit.getValueWithUnit(context, weather.current.airQuality.so2!),
          weather.current.airQuality.so2! / 1600.0,
          weather.current.airQuality.getSo2Color(),
        )
    );
  }

  // no2
  if (weather.current.airQuality.no2 != null) {
    final key = GlobalKey<LinearProgressViewState>();
    keySet.add(key);

    widgets.addAll(
        _getAirItem(
          key,
          initVisible,
          theme,
          'NO₂',
          airQualityUnit.getValueWithUnit(context, weather.current.airQuality.no2!),
          weather.current.airQuality.no2! / 565.0,
          weather.current.airQuality.getNo2Color(),
        )
    );
  }

  // o3
  if (weather.current.airQuality.o3 != null) {
    final key = GlobalKey<LinearProgressViewState>();
    keySet.add(key);

    widgets.addAll(
        _getAirItem(
          key,
          initVisible,
          theme,
          'O₃',
          airQualityUnit.getValueWithUnit(context, weather.current.airQuality.o3!),
          weather.current.airQuality.o3! / 800.0,
          weather.current.airQuality.getO3Color(),
        )
    );
  }

  // co
  if (weather.current.airQuality.co != null) {
    final key = GlobalKey<LinearProgressViewState>();
    keySet.add(key);

    widgets.addAll(
        _getAirItem(
          key,
          initVisible,
          theme,
          'CO',
          coUnit.getValueWithUnit(context, weather.current.airQuality.co!),
          weather.current.airQuality.co! / 90.0,
          weather.current.airQuality.getCOColor(),
        )
    );
  }

  return Padding(
    padding: EdgeInsets.only(
      right: normalMargin,
      bottom: normalMargin,
    ),
    child: IgnorePointer(
      child: ListView(
        shrinkWrap: true,
        children: widgets,
      ),
    ),
  );
}

List<Widget> _getAirItem(
    GlobalKey<LinearProgressViewState> key,
    bool initVisible,
    ThemeData theme,
    String title, String subtitle,
    double progress, Color endColor) {
  progress = max(0.0, progress);
  progress = min(1.0, progress);

  return <Widget>[
    Padding(
      padding: EdgeInsets.only(top: 2.0),
      child: Text(title,
        style: theme.textTheme.caption?.copyWith(
          color: theme.textTheme.bodyText2?.color,
        ),
      ),
    ),
    SizedBox(
      height: 8.0,
      child: LinearProgressView(
        key: key,
        initVisible: initVisible,
        duration: (2000 + progress * 2000).toInt(),
        progress: progress,
        beginColor: ThemeColors.colorLevel1,
        endColor: endColor,
      ),
    ),
    Text(subtitle,
        textAlign: TextAlign.end,
        style: theme.textTheme.overline?.copyWith(
          color: theme.textTheme.caption?.color,
        )
    ),
  ];
}