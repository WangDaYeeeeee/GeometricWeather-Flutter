import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

class CardDisplay extends Pair {

  static const KEY_DAILY_OVERVIEW = 'daily_overview';
  static const KEY_HOURLY_OVERVIEW = 'hourly_overview';
  static const KEY_AIR_QUALITY = 'air_quality';
  static const KEY_ALLERGEN = 'allergen';
  static const KEY_SUNRISE_SUNSET = 'sunrise_sunset';
  static const KEY_LIFE_DETAILS = 'life_details';

  static Map<String, CardDisplay> all = {
    KEY_DAILY_OVERVIEW: CardDisplay._(
        KEY_DAILY_OVERVIEW, (context) => S.of(context).daily_overview),
    KEY_HOURLY_OVERVIEW: CardDisplay._(
        KEY_HOURLY_OVERVIEW, (context) => S.of(context).hourly_overview),
    KEY_AIR_QUALITY: CardDisplay._(
        KEY_AIR_QUALITY, (context) => S.of(context).air_quality),
    KEY_ALLERGEN: CardDisplay._(
        KEY_ALLERGEN, (context) => S.of(context).allergen),
    KEY_SUNRISE_SUNSET: CardDisplay._(
        KEY_SUNRISE_SUNSET, (context) => S.of(context).sunrise_sunset),
    KEY_LIFE_DETAILS: CardDisplay._(
        KEY_LIFE_DETAILS, (context) => S.of(context).life_details)
  };

  const CardDisplay._(String key, LocalizedStringGetter nameGetter): super(key, nameGetter);

  static CardDisplay toCardDisplay(String key) {
    return Pair.toPair(key, all);
  }

  static List<CardDisplay> toCardDisplayList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}

class DailyTrendDisplay extends Pair {

  static const KEY_TEMPERATURE = 'temperature';
  static const KEY_AIR_QUALITY = 'air_quality';
  static const KEY_WIND = 'wind';
  static const KEY_UV_INDEX = 'uv_index';
  static const KEY_PRECIPITATION = 'precipitation';

  static Map<String, DailyTrendDisplay> all = {
    KEY_TEMPERATURE: DailyTrendDisplay._(
        KEY_TEMPERATURE, (context) => S.of(context).temperature),
    KEY_AIR_QUALITY: DailyTrendDisplay._(
        KEY_AIR_QUALITY, (context) => S.of(context).air_quality),
    KEY_WIND: DailyTrendDisplay._(
        KEY_WIND, (context) => S.of(context).wind),
    KEY_UV_INDEX: DailyTrendDisplay._(
        KEY_UV_INDEX, (context) => S.of(context).uv_index),
    KEY_PRECIPITATION: DailyTrendDisplay._(
        KEY_PRECIPITATION, (context) => S.of(context).precipitation),
  };

  DailyTrendDisplay._(
      String key,
      LocalizedStringGetter nameGetter): super(key, nameGetter);

  static DailyTrendDisplay toDailyTrendDisplay(String key) {
    return Pair.toPair(key, all);
  }

  static List<DailyTrendDisplay> toDailyTrendDisplayList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}

class DarkMode extends Pair {

  static const KEY_AUTO = 'auto';
  static const KEY_SYSTEM = 'system';
  static const KEY_LIGHT = 'light';
  static const KEY_DARK = 'dark';

  static Map<String, DailyTrendDisplay> all = {
    KEY_AUTO: DailyTrendDisplay._(KEY_AUTO, (context) => S.of(context).dark_mode_auto),
    KEY_SYSTEM: DailyTrendDisplay._(KEY_SYSTEM, (context) => S.of(context).dark_mode_system),
    KEY_LIGHT: DailyTrendDisplay._(KEY_LIGHT, (context) => S.of(context).dark_mode_light),
    KEY_DARK: DailyTrendDisplay._(KEY_DARK, (context) => S.of(context).dark_mode_dark)
  };

  DarkMode._(String key, LocalizedStringGetter nameGetter): super(key, nameGetter);

  static DarkMode toDarkMode(BuildContext context, String key) {
    return Pair.toPair(key, all);
  }

  static List<DarkMode> toDarkModeList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}