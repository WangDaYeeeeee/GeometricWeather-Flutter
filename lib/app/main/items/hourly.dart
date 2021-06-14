// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/_base.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/background.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/charts.dart';
import 'package:geometricweather_flutter/app/common/ui/trend/scrollbar.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

ItemGenerator hourly = (
    BuildContext context,
    int index,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone) {

  int? maxTemperature = weather.yesterday?.daytimeTemperature;
  int? minTemperature = weather.yesterday?.nighttimeTemperature;
  for (var forecast in weather.hourlyForecast) {
    if (maxTemperature == null
        || forecast.temperature.temperature > maxTemperature) {
      maxTemperature = forecast.temperature.temperature;
    }
    if (minTemperature == null
        || forecast.temperature.temperature < minTemperature) {
      minTemperature = forecast.temperature.temperature;
    }
  }

  double itemWidth = getTrendItemWidth(context, littleMargin);

  ResourceProvider resProvider = ResourceProvider(
      context, settingsManager.resourceProviderId);

  final theme = Theme.of(context);

  final colors = themeManager.getWeatherThemeColors(
    context,
    weather.current.weatherCode,
    themeManager.daytime,
    theme.brightness == Brightness.light,
  );

  final widgets = <Widget>[
    Padding(
      padding: EdgeInsets.only(
        left: normalMargin,
        top: normalMargin,
        right: normalMargin,
      ),
      child: Text(S.of(context).hourly_overview,
        style: theme.textTheme.subtitle2?.copyWith(
          color: themeManager.getWeatherThemeColors(
            context,
            weather.current.weatherCode,
            themeManager.daytime,
            theme.brightness == Brightness.light,
          )[0],
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.only(top: normalMargin),
      child: SizedBox(
        height: 268.0,
        child: Stack(children: [
          TrendScrollBar(
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weather.hourlyForecast.length,
              itemBuilder: (context, index) {
                return _getHourlyItem(
                    context,
                    index,
                    weather,
                    timezone,
                    theme,
                    colors,
                    itemWidth,
                    resProvider,
                    settingsManager,
                    maxTemperature ?? 1,
                    minTemperature ?? 0
                );
              },
            ),
            littleMargin,
          ),
          IgnorePointer(
            child:
            Flex(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    ".",
                    style: theme.textTheme.subtitle2?.copyWith(
                        color: Colors.transparent
                    ),
                  ),
                ),
                Expanded(
                  child: TrendBackgroundView(
                    paddingTop: 8.0 + 32.0 + DEFAULT_PADDING_TOP,
                    highHorizontalValues: weather.yesterday == null ? null : [
                      weather.yesterday!.daytimeTemperature.toDouble(),
                    ],
                    lowHorizontalValues: weather.yesterday == null ? null : [
                      weather.yesterday!.nighttimeTemperature.toDouble(),
                    ],
                    highHorizontalStartDescriptions: weather.yesterday == null ? null : [
                      settingsManager.temperatureUnit.getValueWithShortUnit(
                          context,
                          weather.yesterday!.daytimeTemperature
                      ),
                    ],
                    highHorizontalEndDescriptions: weather.yesterday == null ? null : [
                      S.of(context).yesterday,
                    ],
                    lowHorizontalStartDescriptions: weather.yesterday == null ? null : [
                      settingsManager.temperatureUnit.getValueWithShortUnit(
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

  if (!isEmptyString(weather.current.hourlyForecast)) {
    widgets.insert(
        1,
        Padding(
          padding: EdgeInsets.only(
            left: normalMargin,
            right: normalMargin,
          ),
          child: Text(weather.current.hourlyForecast!,
            style: theme.textTheme.caption,
          ),
        )
    );
  }

  return getAnimatedContainer(
    getCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ensureTimeBar(widgets, index, context, weather),
      ),
    ),
    index,
  );
};

Widget _getHourlyItem(
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
          weather.hourlyForecast[index].getHour(
            isTwelveHourFormat(context),
            S.of(context).of_clock
          ),
          style: theme.textTheme.subtitle2,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 32.0,
          child: Image(
            image: resProvider.getWeatherIcon(
                weather.hourlyForecast[index].weatherCode,
                weather.hourlyForecast[index].daylight
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
          highPolyLineValues: _getTemperatureList(weather, index),
          highPolyLineDescription: weather.hourlyForecast[index]
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
    ],
  ),
);

List<double?> _getTemperatureList(Weather weather, int index) {
  final temperatures = <double?>[null, _getTemperature(weather, index), null];

  if (index < weather.hourlyForecast.length - 1) {
    temperatures[2] = (
        _getTemperature(weather, index) + _getTemperature(weather, index + 1)
    ) / 2.0;
  }

  if (index > 0) {
    temperatures[0] = (
        _getTemperature(weather, index) + _getTemperature(weather, index - 1)
    ) / 2.0;
  }

  return temperatures;
}

double _getTemperature(Weather weather, int index) {
  return weather.hourlyForecast[index].temperature.temperature.toDouble();
}

double _getMaxiPrecipitationProbability(Weather weather, int index) {
  return weather.hourlyForecast[index].precipitationProbability.total ?? 0;
}