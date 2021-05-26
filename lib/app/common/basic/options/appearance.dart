import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

class CardDisplay extends Pair<String, String> {

  static CardDisplay dailyOverview(BuildContext context) =>
      CardDisplay._("daily_overview", S.of(context).daily_overview);

  static CardDisplay hourlyOverview(BuildContext context) =>
      CardDisplay._("hourly_overview", S.of(context).hourly_overview);

  static CardDisplay airQuality(BuildContext context) =>
      CardDisplay._("air_quality", S.of(context).air_quality);

  static CardDisplay allergen(BuildContext context) =>
      CardDisplay._("allergen", S.of(context).allergen);

  static CardDisplay sunriseSunset(BuildContext context) =>
      CardDisplay._("sunrise_sunset", S.of(context).sunrise_sunset);

  static CardDisplay lifeDetails(BuildContext context) =>
      CardDisplay._("life_details", S.of(context).life_details);

  CardDisplay._(String key, String value): super(key, value);

  static List<Pair> toCardDisplayList(BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, {
      'daily_overview': dailyOverview(context),
      'hourly_overview': hourlyOverview(context),
      'air_quality': airQuality(context),
      'allergen': allergen(context),
      'sunrise_sunset': sunriseSunset(context),
      'life_details': lifeDetails(context)
    });
  }
}

class DailyTrendDisplay extends Pair<String, String> {

  static DailyTrendDisplay temperature(BuildContext context) =>
      DailyTrendDisplay._("temperature", S.of(context).temperature);

  static DailyTrendDisplay airQuality(BuildContext context) =>
      DailyTrendDisplay._("air_quality", S.of(context).air_quality);

  static DailyTrendDisplay wind(BuildContext context) =>
      DailyTrendDisplay._("wind", S.of(context).wind);

  static DailyTrendDisplay uvIndex(BuildContext context) =>
      DailyTrendDisplay._("uv_index", S.of(context).uv_index);

  static DailyTrendDisplay precipitation(BuildContext context) =>
      DailyTrendDisplay._("precipitation", S.of(context).precipitation);

  DailyTrendDisplay._(String key, String value): super(key, value);

  static List<DailyTrendDisplay> toDailyTrendDisplayList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, {
      'temperature': temperature(context),
      'air_quality': airQuality(context),
      'wind': wind(context),
      'uv_index': uvIndex(context),
      'precipitation': precipitation(context)
    });
  }
}

class UIStyle extends Pair<String, String> {

  static UIStyle circular(BuildContext context) =>
      UIStyle._("circular", S.of(context).circular);

  material("material");

  UIStyle._(String key, String value): super(key, value);



private final String styleId;

UIStyle(String styleId) {
  this.styleId = styleId;
}

@Nullable
public String getUIStyleName(Context context) {
  return Utils.getNameByValue(
      context.getResources(),
      styleId,
      R.array.ui_styles,
      R.array.ui_style_values
  );
}

public static UIStyle getInstance(String value) {
  switch (value) {
    case  "circular":
      return CIRCULAR;

    default:
      return MATERIAL;
  }
}
}