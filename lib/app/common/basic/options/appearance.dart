import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

class CardDisplay extends Pair<String, String> {

  static Map<String, CardDisplay> getAll(BuildContext context) => {
    'daily_overview': CardDisplay._("daily_overview", S.of(context).daily_overview),
    'hourly_overview': CardDisplay._("hourly_overview", S.of(context).hourly_overview),
    'air_quality': CardDisplay._("air_quality", S.of(context).air_quality),
    'allergen': CardDisplay._("allergen", S.of(context).allergen),
    'sunrise_sunset': CardDisplay._("sunrise_sunset", S.of(context).sunrise_sunset),
    'life_details': CardDisplay._("life_details", S.of(context).life_details)
  };

  CardDisplay._(String key, String value): super(key, value);

  static CardDisplay toCardDisplay(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<CardDisplay> toCardDisplayList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class DailyTrendDisplay extends Pair<String, String> {

  static Map<String, DailyTrendDisplay> getAll(BuildContext context) => {
    'temperature': DailyTrendDisplay._("temperature", S.of(context).temperature),
    'air_quality': DailyTrendDisplay._("air_quality", S.of(context).air_quality),
    'wind': DailyTrendDisplay._("wind", S.of(context).wind),
    'uv_index': DailyTrendDisplay._("uv_index", S.of(context).uv_index),
    'precipitation': DailyTrendDisplay._("precipitation", S.of(context).precipitation),
  };

  DailyTrendDisplay._(String key, String value): super(key, value);

  static DailyTrendDisplay toDailyTrendDisplay(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<DailyTrendDisplay> toDailyTrendDisplayList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class DarkMode extends Pair<String, String> {

  static Map<String, DailyTrendDisplay> getAll(BuildContext context) => {
    'auto': DailyTrendDisplay._("auto", S.of(context).dark_mode_auto),
    'system': DailyTrendDisplay._("system", S.of(context).dark_mode_system),
    'light': DailyTrendDisplay._("light", S.of(context).dark_mode_light),
    'dark': DailyTrendDisplay._("dark", S.of(context).dark_mode_dark)
  };

  DarkMode._(String key, String value): super(key, value);

  static DarkMode toDarkMode(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<DarkMode> toDarkModeList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}