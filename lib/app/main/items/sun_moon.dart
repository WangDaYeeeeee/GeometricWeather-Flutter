// @dart=2.12

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/flow_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/sun_moon/moon_phase.dart';
import 'package:geometricweather_flutter/app/common/ui/sun_moon/sun_moon_path.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

ItemGenerator sunMoon = (
    BuildContext context,
    int index,
    bool initVisible,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone) {

  final theme = Theme.of(context);

  final lightTheme = theme.brightness == Brightness.light;

  final colors = themeManager.getWeatherThemeColors(
    context,
    weather.current.weatherCode,
    themeManager.daytime,
    theme.brightness == Brightness.light,
  );

  final resProvider = ResourceProvider(context, settingsManager.resourceProviderId);

  final sunMoonKey = GlobalKey<SunMoonPathViewState>();
  final moonPhaseKey = GlobalKey<MoonPhaseViewState>();

  double? sunProgress = weather.dailyForecast[0].sun().isValid() ? _getPathProgress(
      timezone,
      weather.dailyForecast[0].sun().riseDate!,
      weather.dailyForecast[0].sun().setDate!
  ) : null;
  double? moonProgress = weather.dailyForecast[0].moon().isValid() ? _getPathProgress(
      timezone,
      weather.dailyForecast[0].moon().riseDate!,
      weather.dailyForecast[0].moon().setDate!
  ) : null;

  final widget = getCard(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ensureTimeBar([
        Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(normalMargin),
                child: Text(S.of(context).sunrise_sunset,
                  style: theme.textTheme.subtitle2?.copyWith(
                    color: colors[0],
                  ),
                ),
              ),
            ),
            !weather.dailyForecast[0].moonPhase.isValid() ? Container() : Row(children: [
              Padding(
                padding: EdgeInsets.only(
                  top: normalMargin,
                  right: littleMargin,
                  bottom: normalMargin,
                ),
                child: Text(weather.dailyForecast[0].moonPhase.description ?? '',
                  style: theme.textTheme.caption,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: normalMargin,
                ),
                child: SizedBox(
                  width: 17.5,
                  height: 17.5,
                  child: MoonPhaseView(
                    key: moonPhaseKey,
                    initVisible: initVisible,
                    duration: _getPhaseAnimatorDuration(
                        weather.dailyForecast[0].moonPhase.angle ?? 0
                    ),
                    angle: weather.dailyForecast[0].moonPhase.angle?.toDouble() ?? 0.0,
                    lightColor: Color.alphaBlend(
                      lightTheme
                          ? ThemeColors.lightBackgroundColor
                          : (theme.textTheme.caption?.color ?? ThemeColors.lightBackgroundColor),
                      theme.backgroundColor,
                    ),
                    darkColor: Color.alphaBlend(
                      lightTheme
                          ? (theme.textTheme.caption?.color ?? ThemeColors.darkBackgroundColor)
                          : ThemeColors.darkBackgroundColor,
                      theme.backgroundColor,
                    ),
                    theme: theme,
                  ),
                ),
              ),
            ]),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: normalMargin,
            right: normalMargin
          ),
          child: AspectRatio(
            aspectRatio: 2.0,
            child: SunMoonPathView(
              key: sunMoonKey,
              initVisible: initVisible,
              width: getTabletAdaptiveWidth(context) - 2 * (littleMargin + normalMargin),
              sunDuration: _getPathAnimationDuration(sunProgress!),
              moonDuration: moonProgress != null
                  ? _getPathAnimationDuration(moonProgress)
                  : null,
              sunProgress: sunProgress,
              moonProgress: moonProgress,
              sunIcon: resProvider.getSunDrawable(),
              moonIcon: resProvider.getMoonDrawable(),
              sunPathColor: colors[1],
              moonPathColor: colors[2],
              theme: theme,
            ),
          ),
        ),
        _getBottomDescriptions(context, weather, theme),
      ], index, context, weather, timezone),
    ),
  );

  return ItemWrapper(widget, () {
    // sun moon path.
    sunMoonKey.currentState?.executeAnimations();
    // moon phase.
    moonPhaseKey.currentState?.executeAnimations();
  });
};

double _getPathProgress(String timezone, DateTime rise, DateTime set) {
  int riseTime = rise.hour * 60 + rise.minute;
  int setTime = set.hour * 60 + set.minute;
  int currentTime = getCurrentTimeInMinute(timezone);

  double progress = (currentTime - riseTime) / (setTime - riseTime);
  progress = max(0.0, progress);
  progress = min(1.0, progress);
  return progress;
}

int _getPathAnimationDuration(double progress) {
  int duration = max(
      2000 + 3000 * progress,
      0.0
  ).toInt();
  return min(duration, 5000);
}

int _getPhaseAnimatorDuration(int angle) {
  double duration = max(0, angle.abs() / 360.0 * 1000 + 2000);
  return min(duration, 3000).toInt();
}

Widget _getBottomDescriptions(BuildContext context, Weather weather, ThemeData theme) {

  String sunText = '${Base.getTime(
      weather.dailyForecast[0].sun().riseDate!,
      isTwelveHourFormat(context)
  )}↑\n${Base.getTime(
      weather.dailyForecast[0].sun().setDate!,
      isTwelveHourFormat(context)
  )}↓';

  String? moonText = weather.dailyForecast[0].moon().isValid() ? '${Base.getTime(
      weather.dailyForecast[0].moon().riseDate!,
      isTwelveHourFormat(context)
  )}↑\n${Base.getTime(
      weather.dailyForecast[0].moon().setDate!,
      isTwelveHourFormat(context)
  )}↓' : null;

  return Flex(
    mainAxisAlignment: MainAxisAlignment.center,
    direction: Axis.horizontal,
    children: [
      Flexible(
        child: Row(children: [
          PlatformIconButton(
            materialIcon: Icon(Icons.wb_sunny_outlined,
              color: theme.textTheme.caption?.color,
            ),
            cupertinoIcon: Icon(CupertinoIcons.sun_max,
              color: theme.textTheme.caption?.color,
            ),
            padding: EdgeInsets.only(
              left: normalMargin,
              top: normalMargin,
              bottom: normalMargin,
            ),
          ),
          Text(sunText,
            style: theme.textTheme.caption,
          ),
        ]),
      ),
      Padding(
        padding: EdgeInsets.only(right: normalMargin),
        child: moonText == null ? Container() : Row(children: [
          PlatformIconButton(
            materialIcon: Icon(Icons.nightlight_outlined,
              color: theme.textTheme.caption?.color,
            ),
            cupertinoIcon: Icon(CupertinoIcons.moon,
              color: theme.textTheme.caption?.color,
            ),
            padding: EdgeInsets.only(
              left: normalMargin,
              top: normalMargin,
              bottom: normalMargin,
            ),
          ),
          Text(moonText,
            style: theme.textTheme.caption,
          ),
        ]),
      ),
    ],
  );
}