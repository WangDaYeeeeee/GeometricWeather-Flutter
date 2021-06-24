import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/flow_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

ItemGenerator header = (
    BuildContext context,
    int index,
    bool initVisible,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone) {

  TextTheme textTheme = Theme.of(context).textTheme;

  return ItemWrapper(
    SizedBox(
      width: double.infinity,
      height: themeManager.getHeaderHeight(context) ?? 0,
      child: Stack(
        children: [
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather.current.temperature.getShortTemperature(
                      context,
                      settingsManager.temperatureUnit
                  ),
                  style: textTheme.headline1.copyWith(
                      color: Colors.white
                  ),
                ),
                Text(
                  '${weather.current.weatherText}, ${S.of(context).feels_like} ${
                      weather.current.temperature.getShortRealFeeTemperature(
                          context,
                          settingsManager.temperatureUnit
                      )
                  }',
                  style: textTheme.headline6.copyWith(
                      color: Colors.white
                  ),
                ),
                Text(
                  weather.current.airQuality.isValid()
                      ? '${S.of(context).air_quality} - ${weather.current.airQuality.aqiText}'
                      : '${weather.current.wind.getShortWindDescription()}',
                  style: textTheme.subtitle2.copyWith(
                      color: Colors.white
                  ),
                )
              ],
            ),
            bottom: normalMargin,
            left: normalMargin,
          )
        ],
      ),
    ),
    null,
  );
};