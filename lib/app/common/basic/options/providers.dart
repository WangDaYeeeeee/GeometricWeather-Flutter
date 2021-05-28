import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/options/_base.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

class WeatherSource extends VoicePair {

  static const KEY_ACCU = 'accu';
  static const KEY_OWM = 'owm';
  static const KEY_MF = 'mf';
  static const KEY_CN = 'cn';
  static const KEY_CAIYUN = 'caiyun';

  static Map<String, WeatherSource> all = {
    KEY_ACCU: WeatherSource._(
        KEY_ACCU,
        (context) => S.of(context).weather_source_accu,
        (context) => S.of(context).weather_source_voice_accu,
        "accuweather.com",
        Color(0xFFef5823)
    ),
    KEY_OWM: WeatherSource._(
        KEY_OWM,
            (context) => S.of(context).weather_source_owm,
            (context) => S.of(context).weather_source_voice_owm,
        "openweathermap.org",
        Color(0xFFeb6e4b)
    ),
    KEY_MF: WeatherSource._(
        KEY_MF,
            (context) => S.of(context).weather_source_mf,
            (context) => S.of(context).weather_source_voice_mf,
        "meteofrance.com",
        Color(0xFF005892)
    ),
    KEY_CN: WeatherSource._(
        KEY_CN,
            (context) => S.of(context).weather_source_cn,
            (context) => S.of(context).weather_source_voice_cn,
        "weather.com.cn",
        Color(0xFF033566)
    ),
    KEY_CAIYUN: WeatherSource._(
        KEY_CAIYUN,
            (context) => S.of(context).weather_source_caiyun,
            (context) => S.of(context).weather_source_voice_caiyun,
        "caiyunapp.com",
        Color(0xFF5ebb8e)
    ),
  };

  WeatherSource._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      this.url,
      this.color
  ) : super(key, nameGetter, voiceGetter);

  final String url;
  final Color color;

  static WeatherSource toWeatherSource(String key) {
    return Pair.toPair(key, all);
  }

  static List<WeatherSource> toWeatherSourceList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}