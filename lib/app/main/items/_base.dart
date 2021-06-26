import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/appearance.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/main_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/weather_view/weather_view.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/main/items/_time_bar.dart';
import 'package:geometricweather_flutter/app/main/items/air.dart';
import 'package:geometricweather_flutter/app/main/items/allergen.dart';
import 'package:geometricweather_flutter/app/main/items/details.dart';
import 'package:geometricweather_flutter/app/main/items/hourly.dart';
import 'package:geometricweather_flutter/app/main/items/sun_moon.dart';
import 'package:geometricweather_flutter/app/main/page_main.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:intl/intl.dart';

import 'daily.dart';
import 'header.dart';

typedef ItemGenerator = ItemWrapper Function(
    BuildContext context,
    int index,
    bool initVisible,
    GlobalKey<WeatherViewState> weatherViewKey,
    MainViewModel viewModel,
    Weather weather,
    String timezone);

final _generatorMap = <String, ItemGenerator> {
  CardDisplay.KEY_DAILY_OVERVIEW : daily,
  CardDisplay.KEY_HOURLY_OVERVIEW : hourly,
  CardDisplay.KEY_AIR_QUALITY : airQuality,
  CardDisplay.KEY_ALLERGEN : allergen,
  CardDisplay.KEY_SUNRISE_SUNSET : sunMoon,
  CardDisplay.KEY_LIFE_DETAILS : details,
};

List<Widget> ensureTimeBar(
    List<Widget> columnItems,
    int index,
    BuildContext context,
    Weather weather,
    String timezone) {

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
      weather.alertList.length == 0 ? TimeBar(
          initHolder.viewModel,
          weather,
          timezone
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimeBar(initHolder.viewModel, weather, timezone),
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

Key listKey;
bool landscape;

Widget getList(
    BuildContext context,
    ScrollController scrollController,
    GlobalKey<WeatherViewState> weatherViewKey,
    MainViewModel viewModel,
    Weather weather,
    String timezone,
    bool executeAnimation) {

  if (executeAnimation) {
    listKey = UniqueKey();
  }

  final cardDisplayList = List<CardDisplay>.from(
      viewModel.settingsManager.cardDisplayList
  );
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
    MainAnimatedListView(
      key: listKey,
      builder: (BuildContext context, int index, bool initVisible) {
        if (index != 0) {
          return _generatorMap[cardDisplayList[index - 1].key](
              context,
              index,
              initVisible,
              weatherViewKey,
              viewModel,
              weather,
              timezone
          );
        }
        return header(
            context,
            0,
            initVisible,
            weatherViewKey,
            viewModel,
            weather,
            timezone
        );
      },
      itemCount: itemCount,
      scrollController: scrollController,
      baseItemAnimationDuration: 500,
      initItemOffsetY: 40.0,
      initItemScale: 1.05,
    )
  );
}
