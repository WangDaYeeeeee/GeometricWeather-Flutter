import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

typedef ValidChecker = bool Function(Weather weather);

class CardDisplay extends Pair {

  static const KEY_DAILY_OVERVIEW = 'daily_overview';
  static const KEY_HOURLY_OVERVIEW = 'hourly_overview';
  static const KEY_AIR_QUALITY = 'air_quality';
  static const KEY_ALLERGEN = 'allergen';
  static const KEY_SUNRISE_SUNSET = 'sunrise_sunset';
  static const KEY_LIFE_DETAILS = 'life_details';

  static Map<String, CardDisplay> all = {
    KEY_DAILY_OVERVIEW: CardDisplay._(
        KEY_DAILY_OVERVIEW,
          (context) => S.of(context).daily_overview,
          (weather) => weather.dailyForecast.length > 0,
    ),
    KEY_HOURLY_OVERVIEW: CardDisplay._(
        KEY_HOURLY_OVERVIEW,
          (context) => S.of(context).hourly_overview,
          (weather) => weather.hourlyForecast.length > 0,
    ),
    KEY_AIR_QUALITY: CardDisplay._(
        KEY_AIR_QUALITY,
          (context) => S.of(context).air_quality,
          (weather) => weather.current.airQuality.aqiText != null
              && weather.current.airQuality.aqiIndex != null
              && (
                  weather.current.airQuality.pm25 != null
                      || weather.current.airQuality.pm10 != null
                      || weather.current.airQuality.so2 != null
                      || weather.current.airQuality.no2 != null
                      || weather.current.airQuality.o3 != null
                      || weather.current.airQuality.co != null
              ),
    ),
    KEY_ALLERGEN: CardDisplay._(
        KEY_ALLERGEN,
          (context) => S.of(context).allergen,
          (weather) => weather.dailyForecast.length > 0
              && weather.dailyForecast[0].pollen.isValid(),
    ),
    KEY_SUNRISE_SUNSET: CardDisplay._(
        KEY_SUNRISE_SUNSET,
          (context) => S.of(context).sunrise_sunset,
          (weather) => weather.dailyForecast.length > 0
              && weather.dailyForecast[0].sun().isValid(),
    ),
    KEY_LIFE_DETAILS: CardDisplay._(
        KEY_LIFE_DETAILS,
          (context) => S.of(context).life_details,
          (weather) => weather.current != null,
    ),
  };

  const CardDisplay._(
      String key,
      LocalizedStringGetter nameGetter,
      this._validChecker): super(key, nameGetter);

  final ValidChecker _validChecker;

  bool isValid(Weather weather) => _validChecker(weather);

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

  static Map<String, DarkMode> all = {
    KEY_AUTO: DarkMode._(KEY_AUTO, (context) => S.of(context).dark_mode_auto),
    KEY_SYSTEM: DarkMode._(KEY_SYSTEM, (context) => S.of(context).dark_mode_system),
    KEY_LIGHT: DarkMode._(KEY_LIGHT, (context) => S.of(context).dark_mode_light),
    KEY_DARK: DarkMode._(KEY_DARK, (context) => S.of(context).dark_mode_dark)
  };

  DarkMode._(String key, LocalizedStringGetter nameGetter): super(key, nameGetter);

  static DarkMode toDarkMode(BuildContext context, String key) {
    return Pair.toPair(key, all);
  }

  static List<DarkMode> toDarkModeList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}