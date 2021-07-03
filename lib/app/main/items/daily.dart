// @dart=2.12

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/main_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/_base.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/background.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/charts.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/scrollbar.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '../view_models.dart';
import '_base.dart';

ItemGenerator daily = (
    BuildContext context,
    int index,
    bool initVisible,
    GlobalKey<WeatherViewState> weatherViewKey,
    MainViewModel viewModel,
    Weather weather,
    String timezone) {

  int? maxTemperature = weather.yesterday?.daytimeTemperature;
  int? minTemperature = weather.yesterday?.nighttimeTemperature;
  for (var forecast in weather.dailyForecast) {
    if (maxTemperature == null
        || forecast.day().temperature.temperature > maxTemperature) {
      maxTemperature = forecast.day().temperature.temperature;
    }
    if (minTemperature == null
        || forecast.night().temperature.temperature < minTemperature) {
      minTemperature = forecast.night().temperature.temperature;
    }
  }

  double itemWidth = getTrendItemWidth(context, littleMargin);

  ResourceProvider resProvider = ResourceProvider(
      context, viewModel.settingsManager.resourceProviderId);

  final theme = Theme.of(context);

  final colors = viewModel.themeManager.getWeatherThemeColors(
    context,
    weather.current.weatherCode,
    viewModel.themeManager.daytime,
    theme.brightness == Brightness.light,
  );

  final widgets = <Widget>[
    Padding(
      padding: EdgeInsets.only(
        left: normalMargin,
        top: normalMargin,
        right: normalMargin,
      ),
      child: Text(S.of(context).daily_overview,
        style: theme.textTheme.subtitle2?.copyWith(
          color: colors[0],
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.only(top: normalMargin),
      child: SizedBox(
        height: 324.0,
        child: Stack(children: [
          TrendScrollBar(
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemExtent: itemWidth,
              itemCount: weather.dailyForecast.length,
              itemBuilder: (context, index) {
                return _getDailyItem(
                    context,
                    index,
                    weather,
                    timezone,
                    theme,
                    colors,
                    itemWidth,
                    resProvider,
                    viewModel.settingsManager,
                    maxTemperature ?? 1,
                    minTemperature ?? 0
                );
              },
            ),
            littleMargin,
          ),
          IgnorePointer(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    ".",
                    style: theme.textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.transparent
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text('.',
                    style: theme.textTheme.caption?.copyWith(
                        color: Colors.transparent
                    ),
                  ),
                ),
                Expanded(
                  child: TrendBackgroundView(
                    paddingTop: 8.0 + 32.0 + DEFAULT_PADDING_TOP,
                    paddingBottom: 8.0 + 16.0 + 32.0 + DEFAULT_PADDING_BOTTOM,
                    highHorizontalValues: weather.yesterday == null ? null : [
                      weather.yesterday!.daytimeTemperature.toDouble(),
                    ],
                    lowHorizontalValues: weather.yesterday == null ? null : [
                      weather.yesterday!.nighttimeTemperature.toDouble(),
                    ],
                    highHorizontalStartDescriptions: weather.yesterday == null ? null : [
                      viewModel.settingsManager.temperatureUnit.getValueWithShortUnit(
                          context,
                          weather.yesterday!.daytimeTemperature
                      ),
                    ],
                    highHorizontalEndDescriptions: weather.yesterday == null ? null : [
                      S.of(context).yesterday,
                    ],
                    lowHorizontalStartDescriptions: weather.yesterday == null ? null : [
                      viewModel.settingsManager.temperatureUnit.getValueWithShortUnit(
                          context,
                          weather.yesterday!.nighttimeTemperature
                      ),
                    ],
                    lowHorizontalEndDescriptions: weather.yesterday == null ? null : [
                      S.of(context).yesterday,
                    ],
                    valueRange: ValueRange(
                      minTemperature?.toDouble() ?? 0.0,
                      maxTemperature?.toDouble() ?? 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ),
  ];

  if (!isEmptyString(weather.current.dailyForecast)) {
    widgets.insert(
      1,
      Padding(
        padding: EdgeInsets.only(
          left: normalMargin,
          right: normalMargin,
        ),
        child: Text(weather.current.dailyForecast!,
          style: theme.textTheme.caption,
        ),
      )
    );
  }

  return ItemWrapper(
    getCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ensureTimeBar(widgets, index, context, weather, timezone),
      ),
    ),
    null,
  );
};

Widget _getDailyItem(
    BuildContext context,
    int index,
    Weather weather,
    String timezone,
    ThemeData theme,
    List<Color> colors,
    double itemWidth,
    ResourceProvider resProvider,
    SettingsManager settingsManager,
    int maxTemperature,
    int minTemperature) => SizedBox(
  width: itemWidth,
  child: Flex(
    direction: Axis.vertical,
    children: [
      Padding(
        padding: EdgeInsets.all(2.0),
        child: Text(
          isToday(weather.dailyForecast[index].date, timezone)
              ? S.of(context).today
              : getWeekName(context, weather.dailyForecast[index].getWeek()),
          style: theme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(2.0),
        child: Text(weather.dailyForecast[index].getDate(S.of(context).date_format_short),
          style: theme.textTheme.caption,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 32.0,
          child: Image(
            image: resProvider.getWeatherIcon(
                weather.dailyForecast[index].day().weatherCode,
                true
            ),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
      Expanded(
        child: PolylineAndHistogramView(
          lightColor: colors[1],
          darkColor: colors[2],
          histogramColor: colors[2].withAlpha((
              255 * (theme.brightness == Brightness.light ? 0.2 : 0.5)
          ).toInt()),
          dividerColor: theme.dividerColor,
          highPolyLineValues: _getTemperatureList(weather, index, true),
          highPolyLineDescription: weather.dailyForecast[index]
              .day()
              .temperature
              .getShortTemperature(context, settingsManager.temperatureUnit),
          lowPolyLineValues: _getTemperatureList(weather, index, false),
          lowPolyLineDescription: weather.dailyForecast[index]
              .night()
              .temperature
              .getShortTemperature(context, settingsManager.temperatureUnit),
          histogramValue: _getMaxiPrecipitationProbability(weather, index) / 100.0,
          histogramDescription: settingsManager.probabilityUnit.getValueWithUnit(
              context,
              _getMaxiPrecipitationProbability(weather, index)
          ),
          polyLineRange: ValueRange(
              minTemperature.toDouble(),
              maxTemperature.toDouble(),
          ),
          histogramRange: ValueRange(0.0, 1.0),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 8.0 + 16.0),
        child: SizedBox(
          height: 32.0,
          child: Image(
            image: resProvider.getWeatherIcon(
                weather.dailyForecast[index].night().weatherCode,
                false
            ),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    ],
  ),
);

List<double?> _getTemperatureList(Weather weather, int index, bool daytime) {
  final temperatures = <double?>[null, _getTemperature(weather, index, daytime), null];

  if (index < weather.dailyForecast.length - 1) {
    temperatures[2] = (
        _getTemperature(weather, index, daytime) + _getTemperature(weather, index + 1, daytime)
    ) / 2.0;
  }

  if (index > 0) {
    temperatures[0] = (
        _getTemperature(weather, index, daytime) + _getTemperature(weather, index - 1, daytime)
    ) / 2.0;
  }

  return temperatures;
}

double _getTemperature(Weather weather, int index, bool daytime) {
  return (
      daytime
          ? weather.dailyForecast[index].day()
          : weather.dailyForecast[index].night()
  ).temperature.temperature.toDouble();
}

double _getMaxiPrecipitationProbability(Weather weather, int index) {
  return max(
      weather.dailyForecast[index].day().precipitationProbability.total ?? 0,
      weather.dailyForecast[index].night().precipitationProbability.total ?? 0
  );
}