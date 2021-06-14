import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/appearance.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/main/items/hourly.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:intl/intl.dart';

import 'daily.dart';
import 'header.dart';

const BASIC_ANIMATION_DURATION = 450;

typedef ItemGenerator = Widget Function(
    BuildContext context,
    int index,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone);

final _generatorMap = <String, ItemGenerator> {
  CardDisplay.KEY_DAILY_OVERVIEW : daily,
  CardDisplay.KEY_HOURLY_OVERVIEW : hourly,
  CardDisplay.KEY_AIR_QUALITY : __card,
  CardDisplay.KEY_ALLERGEN : __card,
  CardDisplay.KEY_SUNRISE_SUNSET : __card,
  CardDisplay.KEY_LIFE_DETAILS : __card,
};

Widget getAnimatedContainer(Widget child, int index) {
  return AnimationConfiguration.staggeredList(
    position: index,
    duration: const Duration(milliseconds: BASIC_ANIMATION_DURATION),
    child: SlideAnimation(
      verticalOffset: 50.0,
      curve: Curves.easeOutBack,
      child: ScaleAnimation(
        scale: 1.1,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    ),
  );
}

List<Widget> ensureTimeBar(
    List<Widget> columnItems,
    int index,
    BuildContext context,
    Weather weather) {

  if (index != 1) {
    return columnItems;
  }

  StringBuffer b = StringBuffer();
  for (int i = 0; i < weather.alertList.length; i ++) {
    b..write(weather.alertList[i].description)
      ..write(', ')
      ..write(DateFormat.yMMMMEEEEd().format(weather.alertList[i].date));
    if (i < weather.alertList.length - 1) {
      b.write('\n');
    }
  }

  columnItems.insert(
      0,
      weather.alertList.length == 0 ? _getBaseTimeBar(context, weather) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getBaseTimeBar(context, weather),
          Padding(
            padding: EdgeInsets.fromLTRB(normalMargin, 0.0, normalMargin, normalMargin),
            child: Text(b.toString(),
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      )
  );
  return columnItems;
}

Widget _getBaseTimeBar(BuildContext context, Weather weather) {
  TextStyle style = Theme.of(context).textTheme.subtitle2;

  return PlatformInkWell(
    child: Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        weather.alertList.length == 0 ? PlatformIconButton(
          materialIcon: Icon(Icons.access_time,
            color: style.color,
          ),
          cupertinoIcon: Icon(CupertinoIcons.time,
            color: style.color,
          ),
          padding: EdgeInsets.all(normalMargin),
        ) : PlatformIconButton(
          materialIcon: Icon(Icons.error_outline,
            color: style.color,
          ),
          cupertinoIcon: Icon(CupertinoIcons.exclamationmark_circle,
            color: style.color,
          ),
          padding: EdgeInsets.all(normalMargin),
          onPressed: () {
            // todo: show alerts page.
          },
        ),
        Expanded(
          child: Text(
            '${S.of(context).refresh_at} ${
                Base.getTime(weather.base.updateDate, isTwelveHourFormat(context))
            }',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ],
    ),
    onTap: () {
      // todo: management.
    },
  );
}

Widget getCard(Widget child) {
  return Card(
    child: child,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(cardRadius)
        )
    ),
    margin: EdgeInsets.fromLTRB(littleMargin, 0.0, littleMargin, littleMargin),
  );
}

ItemGenerator __card = (
    BuildContext context,
    int index,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone) {
  return getAnimatedContainer(
    getCard(
      SizedBox(
        width: double.infinity,
        height: 200.0,
      ),
    ),
    index,
  );
};

Key listKey;

Widget getList(
    BuildContext context,
    ScrollController scrollController,
    GlobalKey<WeatherViewState> weatherViewKey,
    SettingsManager settingsManager,
    ThemeManager themeManager,
    Weather weather,
    String timezone,
    bool executeAnimation) {

  if (executeAnimation) {
    listKey = UniqueKey();
  }

  final cardDisplayList = List<CardDisplay>.from(settingsManager.cardDisplayList);
  // at least show header.
  int itemCount = 1;
  for (int i = cardDisplayList.length - 1; i >= 0; i --) {
    if (!cardDisplayList[i].isValid(weather)) {
      cardDisplayList.removeAt(i);
    } else {
      itemCount ++;
    }
  }

  return getTabletAdaptiveWidthBox(
    context,
    AnimationLimiter(
      key: listKey,
      child: ListView.builder(
          controller: scrollController,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index != 0) {
              return _generatorMap[cardDisplayList[index - 1].key](
                  context,
                  index,
                  weatherViewKey,
                  settingsManager,
                  themeManager,
                  weather,
                  timezone
              );
            }
            return header(
                context,
                0,
                weatherViewKey,
                settingsManager,
                themeManager,
                weather,
                timezone
            );
          }
      ),
    )
  );
}