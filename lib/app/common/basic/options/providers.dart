import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/options/_base.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

class WeatherSource extends VoicePair<String, String, String> {

  static Map<String, WeatherSource> getAll(BuildContext context) => {
    'accu': WeatherSource._(
        "accu",
        S.of(context).weather_source_accu,
        S.of(context).weather_source_voice_accu,
        "accuweather.com",
        Color(0xFFef5823)
    ),
    'owm': WeatherSource._(
        "owm",
        S.of(context).weather_source_owm,
        S.of(context).weather_source_voice_owm,
        "openweathermap.org",
        Color(0xFFeb6e4b)
    ),
    'mf': WeatherSource._(
        "mf",
        S.of(context).weather_source_mf,
        S.of(context).weather_source_voice_mf,
        "meteofrance.com",
        Color(0xFF005892)
    ),
    'cn': WeatherSource._(
        "cn",
        S.of(context).weather_source_cn,
        S.of(context).weather_source_voice_cn,
        "weather.com.cn",
        Color(0xFF033566)
    ),
    'caiyun': WeatherSource._(
        "caiyun",
        S.of(context).weather_source_caiyun,
        S.of(context).weather_source_voice_caiyun,
        "caiyunapp.com",
        Color(0xFF5ebb8e)
    ),
  };

  WeatherSource._(
      String key,
      String name,
      String voice,
      this.url,
      this.color
  ) : super(key, name, voice);

  final String url;
  final Color color;

  static WeatherSource toWeatherSource(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<WeatherSource> toWeatherSourceList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}