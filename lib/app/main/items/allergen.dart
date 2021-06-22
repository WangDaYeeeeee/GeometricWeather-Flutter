// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/flow_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

ItemGenerator allergen = (
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
          child: Text(S.of(context).allergen,
            style: theme.textTheme.subtitle2?.copyWith(
              color: colors[0],
            ),
          ),
        ),
        SizedBox(
          height: 216.0,
          child: PageView.builder(
            itemCount: weather.dailyForecast.length,
            itemBuilder: (BuildContext context, int index) {
              return _getPage(
                context,
                theme,
                weather.dailyForecast[index].getDate(
                    S.of(context).date_format_widget_long
                ),
                '${
                    weather.dailyForecast[index].day().weatherPhase
                } / ${
                    weather.dailyForecast[index].night().weatherPhase
                }',
                weather.dailyForecast[index].pollen,
                '${index + 1}/${weather.dailyForecast.length}',
              );
            },
          ),
        )
      ], index, context, weather, timezone),
    ),
  );

  return ItemWrapper(widget, null);
};

Widget _getPage(
    BuildContext context,
    ThemeData theme,
    String title,
    String subtitle,
    Pollen pollen,
    String indicator) {
  return Flex(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: normalMargin,
                left: normalMargin,
                right: normalMargin,
              ),
              child: Text(title,
                style: theme.textTheme.bodyText2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(normalMargin),
            child: Text(indicator,
              style: theme.textTheme.overline,
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(
          left: normalMargin,
          right: normalMargin,
        ),
        child: Text(subtitle,
          softWrap: false,
          style: theme.textTheme.caption,
        ),
      ),
      Expanded(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: _getAllergenItem(
                    theme,
                    pollen.getPollenColor(pollen.grassLevel),
                    S.of(context).grass,
                    '${
                        PollenUnit.all[PollenUnit.KEY_PPCM]?.getValueWithUnit(
                            context,
                            pollen.grassIndex?.toDouble() ?? 0.0
                        )
                    } - ${pollen.grassDescription}',
                  ),
                ),
                Flexible(
                  child: _getAllergenItem(
                    theme,
                    pollen.getPollenColor(pollen.moldLevel),
                    S.of(context).mold,
                    '${
                        PollenUnit.all[PollenUnit.KEY_PPCM]?.getValueWithUnit(
                            context,
                            pollen.moldIndex?.toDouble() ?? 0.0
                        )
                    } - ${pollen.moldDescription}',
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: _getAllergenItem(
                    theme,
                    pollen.getPollenColor(pollen.ragweedLevel),
                    S.of(context).ragweed,
                    '${
                        PollenUnit.all[PollenUnit.KEY_PPCM]?.getValueWithUnit(
                            context,
                            pollen.ragweedIndex?.toDouble() ?? 0.0
                        )
                    } - ${pollen.ragweedDescription}',
                  ),
                ),
                Flexible(
                  child: _getAllergenItem(
                    theme,
                    pollen.getPollenColor(pollen.treeLevel),
                    S.of(context).tree,
                    '${
                        PollenUnit.all[PollenUnit.KEY_PPCM]?.getValueWithUnit(
                            context,
                            pollen.treeIndex?.toDouble() ?? 0.0
                        )
                    } - ${pollen.treeDescription}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _getAllergenItem(
    ThemeData theme,
    Color color, String title, String subtitle) {
  return Flex(
    direction: Axis.horizontal,
    children: [
      Padding(
        padding: EdgeInsets.all(normalMargin),
        child: Text('●',
          style: theme.textTheme.subtitle2?.copyWith(
            color: color,
          ),
        ),
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
                style: theme.textTheme.caption,
              ),
              Text(subtitle,
                softWrap: false,
                style: theme.textTheme.overline?.copyWith(
                  wordSpacing: theme.textTheme.caption?.wordSpacing,
                  letterSpacing: theme.textTheme.caption?.letterSpacing,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}