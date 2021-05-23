import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

class CardDisplay {

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

  final String value;
  final String name;

  CardDisplay._(this.value, this.name);

  static List<CardDisplay> toCardDisplayList(BuildContext context, List<String> cards) {
    try {
      List<CardDisplay> list = [];
      for (String card in cards) {
        switch (card) {
          case "daily_overview":
            list.add(dailyOverview(context));
            break;

          case "hourly_overview":
            list.add(hourlyOverview(context));
            break;

          case "air_quality":
            list.add(airQuality(context));
            break;

          case "allergen":
            list.add(allergen(context));
            break;

          case "life_details":
            list.add(lifeDetails(context));
            break;

          case "sunrise_sunset":
            list.add(sunriseSunset(context));
            break;
        }
      }
      return list;
    } catch (e) {
    return [];
    }
  }

  static List<String> toValue(List<CardDisplay> list) {
    List<String> values = [];
    for (CardDisplay v in list) {
      values.add(v.value);
    }
    return values;
  }

  static String getSummary(List<CardDisplay> list) {
    StringBuffer b = new StringBuffer();
    for (CardDisplay item in list) {
      b.write(",");
      b.write(item.name);
    }

    if (b.isEmpty) {
      return "";
    }

    String summary = b.toString();
    if (summary[0] == ',') {
      return summary.substring(1);
    }
    return summary;
  }
}