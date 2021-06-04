import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

abstract class ResourceProvider {
  
  factory ResourceProvider(BuildContext context, String id) {
    if (id == DefaultResourceProvider.PROVIDER_ID) {
      return DefaultResourceProvider(context);
    }
    throw Exception('Invalid provider id.');
  }

  String get providerId;

  String get providerName;

  ImageProvider get providerIcon;

  @override
  bool operator ==(Object other) {
    if (other is ResourceProvider) {
      return providerId == other.providerId;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  // weather icon.

  ImageProvider getWeatherIcon(WeatherCode code, bool dayTime);

  // sun and moon.

  ImageProvider getSunDrawable();

  ImageProvider getMoonDrawable();
}

class DefaultResourceProvider implements ResourceProvider {

  String _name;
  static const PROVIDER_ID = 'com.wangdaye.geometricweather:default_provider';

  DefaultResourceProvider(BuildContext context) {
    _name = S.of(context).geometric_weather;
  }

  @override
  ImageProvider getMoonDrawable() {
    return AssetImage(getAssetName(WeatherCode.CLEAR, false
    ));
  }

  @override
  ImageProvider getSunDrawable() {
    return AssetImage(getAssetName(WeatherCode.CLEAR, true));
  }

  @override
  ImageProvider getWeatherIcon(WeatherCode code, bool daytime) {
    return AssetImage(getAssetName(code, daytime));
  }

  static String getAssetName(WeatherCode code, bool daytime) {
    switch (code) {
      case WeatherCode.CLEAR:
        return 'images/weather_clear_${daytimeToName(daytime)}.png';

      case WeatherCode.PARTLY_CLOUDY:
        return 'images/weather_partly_cloudy_${daytimeToName(daytime)}.png';

      case WeatherCode.CLOUDY:
        return 'images/weather_cloudy.png';

      case WeatherCode.RAIN_S:
        return 'images/weather_rain.png';

      case WeatherCode.RAIN_M:
        return 'images/weather_rain.png';

      case WeatherCode.RAIN_L:
        return 'images/weather_rain.png';

      case WeatherCode.SNOW_S:
        return 'images/weather_snow.png';

      case WeatherCode.SNOW_M:
        return 'images/weather_snow.png';

      case WeatherCode.SNOW_L:
        return 'images/weather_snow.png';

      case WeatherCode.WIND:
        return 'images/weather_wind.png';

      case WeatherCode.FOG:
        return 'images/weather_fog.png';

      case WeatherCode.HAZE:
        return 'images/weather_haze.png';

      case WeatherCode.SLEET:
        return 'images/weather_sleet.png';

      case WeatherCode.HAIL:
        return 'images/weather_hail.png';

      case WeatherCode.THUNDER:
        return 'images/weather_thunder.png';

      case WeatherCode.THUNDERSTORM:
        return 'images/weather_thunderstorm.png';
    }
    throw Exception('Unknown weather code.');
  }

  static String daytimeToName(bool daytime) {
    return daytime ? 'day' : 'night';
  }

  @override
  String get providerId => PROVIDER_ID;

  @override
  ImageProvider get providerIcon => AssetImage('images/ic_launcher.png');

  @override
  String get providerName => _name;
}