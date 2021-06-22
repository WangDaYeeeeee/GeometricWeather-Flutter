import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/flow_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

ItemGenerator details = (
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

  final widget = getCard(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ensureTimeBar([
        Padding(
          padding: EdgeInsets.all(normalMargin),
          child: Text(S.of(context).life_details,
            style: theme.textTheme.subtitle2?.copyWith(
              color: colors[0],
            ),
          ),
        ),
        _getDetailList(context, theme, weather, settingsManager),
      ], index, context, weather, timezone),
    ),
  );

  return ItemWrapper(widget, null);
};

Widget _getDetailList(
    BuildContext context,
    ThemeData theme,
    Weather weather,
    SettingsManager settingsManager) {

  List<Widget> widgets = [];

  // wind.
  widgets.add(
      _getDetailItem(
        theme,
        Icons.air_outlined,
        CupertinoIcons.wind,
        '${S.of(context).live}: ${
            weather.current.wind.getWindDescription(
                context,
                settingsManager.speedUnit
            )
        }',
        '${S.of(context).daytime}: ${
            weather.dailyForecast[0].day().wind.getWindDescription(
                context,
                settingsManager.speedUnit
            )
        }\n${S.of(context).nighttime}: ${
            weather.dailyForecast[0].night().wind.getWindDescription(
                context,
                settingsManager.speedUnit
            )
        }',
      )
  );

  // humidity.
  if (weather.current.relativeHumidity != null) {
    widgets.add(
        _getDetailItem(
          theme,
          Icons.water_outlined,
          CupertinoIcons.drop,
          S.of(context).humidity,
          RelativeHumidityUnit.all[RelativeHumidityUnit.KEY_PERCENT].getValueWithUnit(
              context,
              weather.current.relativeHumidity
          ),
        )
    );
  }

  // uv.
  if (weather.current.uv.isValid()) {
    widgets.add(
        _getDetailItem(
          theme,
          Icons.wb_sunny_outlined,
          CupertinoIcons.sun_max,
          S.of(context).uv_index,
          weather.current.uv.getUVDescription(),
        )
    );
  }

  // pressure.
  if (weather.current.pressure != null) {
    widgets.add(
        _getDetailItem(
          theme,
          Icons.thermostat_outlined,
          CupertinoIcons.thermometer,
          S.of(context).pressure,
          settingsManager.pressureUnit.getValueWithUnit(
              context,
              weather.current.pressure
          ),
        )
    );
  }

  // visibility.
  if (weather.current.visibility != null) {
    widgets.add(
        _getDetailItem(
          theme,
          Icons.visibility_outlined,
          CupertinoIcons.eye,
          S.of(context).visibility,
          settingsManager.distanceUnit.getValueWithUnit(
              context,
              weather.current.visibility
          ),
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

Widget _getDetailItem(
    ThemeData theme,
    IconData materialIcon, IconData cupertinoIcon,
    String title, String content) {

  return Flex(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PlatformIconButton(
        materialIcon: Icon(materialIcon,
          color: theme.textTheme.bodyText2?.color,
        ),
        cupertinoIcon: Icon(cupertinoIcon,
          color: theme.textTheme.bodyText2?.color,
        ),
        padding: EdgeInsets.all(normalMargin),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            top: normalMargin,
            right: normalMargin,
            bottom: normalMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: theme.textTheme.bodyText2,
              ),
              Text(content,
                style: theme.textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}