import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart' as location;
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart' as weather;
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/settings/manager.dart';
import 'package:geometricweather_flutter/app/weather/converters/common_converter.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/air_quality.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/alert.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/current.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/daily.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/hourly.dart';
import 'package:geometricweather_flutter/app/weather/json/accu/location.dart';

location.Location toLocation(AccuLocationResult result, [String zipCode]) {
  return location.Location(
      result.key,
      result.geoPosition.latitude,
      result.geoPosition.longitude,
      result.timeZone.code,
      result.country.localizedName,
      result.administrativeArea == null ? "" : result.administrativeArea.localizedName,
      result.localizedName + (zipCode == null ? "" : (" (" + zipCode + ")")),
      "",
      WeatherSource.all[WeatherSource.KEY_ACCU],
      false,
      false,
      !isEmpty(result.country.iD)
          && (result.country.iD == "CN"
          || result.country.iD == "cn"
          || result.country.iD == "HK"
          || result.country.iD == "hk"
          || result.country.iD == "TW"
          || result.country.iD == "tw")
  );
}

weather.WeatherCode getWeatherCode(int icon) {
  if (icon == 1 || icon == 2 || icon == 30
      || icon == 33 || icon == 34) {
    return weather.WeatherCode.CLEAR;
  } else if (icon == 3 || icon == 4 || icon == 6 || icon == 7
      || icon == 35 || icon == 36 || icon == 38) {
    return weather.WeatherCode.PARTLY_CLOUDY;
  } else if (icon == 5 || icon == 37) {
    return weather.WeatherCode.HAZE;
  } else if (icon == 8) {
    return weather.WeatherCode.CLOUDY;
  } else if (icon == 11) {
    return weather.WeatherCode.FOG;
  } else if (icon == 12 || icon == 13 || icon == 14 || icon == 39 || icon == 40) {
    return weather.WeatherCode.RAIN_S;
  } else if (icon == 18) {
    return weather.WeatherCode.RAIN_M;
  } else if (icon == 15 || icon == 16 || icon == 17 || icon == 41 || icon == 42) {
    return weather.WeatherCode.THUNDERSTORM;
  } else if (icon == 19 || icon == 20 || icon == 21 || icon == 23
      || icon == 31 || icon == 43 || icon == 44) {
    return weather.WeatherCode.SNOW_S;
  } else if (icon == 22 || icon == 24) {
    return weather.WeatherCode.SNOW_L;
  } else if (icon == 25) {
    return weather.WeatherCode.HAIL;
  } else if (icon == 26 || icon == 29) {
    return weather.WeatherCode.SLEET;
  } else if (icon == 32) {
    return weather.WeatherCode.WIND;
  } else {
    return weather.WeatherCode.CLOUDY;
  }
}

int toInt(double value) {
  return (value + 0.5).toInt();
}

String convertUnit(BuildContext context, String str) {
  if (isEmpty(str)) {
    return str;
  }

  // precipitation.
  PrecipitationUnit precipitationUnit = SettingsManager.getInstance().precipitationUnit;

  // cm.
  str = convertStrUnit(context, str, PrecipitationUnit.all[PrecipitationUnit.KEY_CM], precipitationUnit);

  // mm.
  str = convertStrUnit(context, str, PrecipitationUnit.all[PrecipitationUnit.KEY_MM], precipitationUnit);

  return str;
}

String convertStrUnit(BuildContext context,
    String str,
    PrecipitationUnit targetUnit,
    PrecipitationUnit resultUnit) {
  try {
    String numberPattern = "\\d+-\\d+(\\s+)?";
    var allMatches = RegExp('$numberPattern${targetUnit.key}').allMatches(str);

    List<String> targetList = [];
    List<String> resultList = [];

    for (RegExpMatch match in allMatches) {
      String target = str.substring(match.start, match.end);
      targetList.add(target);

      List<String> targetSplitResults = target.replaceAll(" ", "").split(
          targetUnit.nameGetter(context));
      List<String> numberTexts = targetSplitResults[0].split("-");

      for (int i = 0; i < numberTexts.length; i ++) {
        double number = double.parse(numberTexts[i]);
        number = targetUnit.getMilliMeters(number);
        numberTexts[i] = resultUnit.formatValue(number);
      }

      resultList.add('${arrayToString(numberTexts)} ${resultUnit.nameGetter(context)}');
    }

    for (int i = 0; i < targetList.length; i ++) {
      str = str.replaceAll(targetList[i], resultList[i]);
    }

    return str;
  } catch (e) {
  return str;
  }
}

String arrayToString(List<String> array) {
  StringBuffer b = StringBuffer();
  for (int i = 0; i < array.length; i++) {
    b.write(array[i]);
    if (i < array.length - 1) {
      b.write("-");
    }
  }
  return b.toString();
}

weather.Weather toWeather(
    BuildContext context,
    location.Location location,
    AccuCurrentResult currentResult,
    AccuDailyResult dailyResult,
    List<AccuHourlyResult> hourlyResultList,
    List<AccuAlertResult> alertResultList,
    [AccuAirQualityResult aqiResult]) {
  try {
    return weather.Weather(
        weather.Base(
            location.cityId,
            DateTime.now().millisecondsSinceEpoch,
            DateTime.fromMillisecondsSinceEpoch(currentResult.epochTime * 1000),
            currentResult.epochTime * 1000,
            DateTime.now(),
            DateTime.now().millisecondsSinceEpoch
        ),
        weather.Current(
            currentResult.weatherText,
            getWeatherCode(currentResult.weatherIcon),
            weather.Temperature(
                currentResult.temperature.metric.value,
                currentResult.realFeelTemperature.metric.value,
                currentResult.realFeelTemperatureShade.metric.value,
                currentResult.apparentTemperature.metric.value,
                currentResult.windChillTemperature.metric.value,
                currentResult.wetBulbTemperature.metric.value,
            ),
            weather.Precipitation(
                currentResult.precip1hr.metric.value.toDouble()
            ),
            weather.PrecipitationProbability(),
            weather.Wind(
                currentResult.wind.direction.localized,
                weather.WindDegree(currentResult.wind.direction.degrees.toDouble()),
                getWindLevel(context, currentResult.windGust.speed.metric.value.toDouble()),
                currentResult.windGust.speed.metric.value.toDouble(),
            ),
            weather.UV(currentResult.uVIndex, currentResult.uVIndexText),
            aqiResult == null
                ? weather.AirQuality()
                : weather.AirQuality(
                    getAqiQuality(context, aqiResult.index),
                    aqiResult.index,
                    aqiResult.particulateMatter25.toDouble(),
                    aqiResult.particulateMatter10.toDouble(),
                    aqiResult.sulfurDioxide.toDouble(),
                    aqiResult.nitrogenDioxide.toDouble(),
                    aqiResult.ozone.toDouble(),
                    aqiResult.carbonMonoxide.toDouble()
                ),
            currentResult.relativeHumidity.toDouble(),
            currentResult.pressure.metric.value.toDouble(),
            currentResult.visibility.metric.value.toDouble(),
            currentResult.dewPoint.metric.value,
            currentResult.cloudCover,
            (currentResult.ceiling.metric.value / 1000.0).toDouble(),
            convertUnit(context, dailyResult.headline.text),
        ),
        getDailyList(context, dailyResult),
        getHourlyList(hourlyResultList),
        getAlertList(alertResultList),
        weather.History(
            DateTime.fromMillisecondsSinceEpoch((currentResult.epochTime - 24 * 60 * 60) * 1000),
            (currentResult.epochTime - 24 * 60 * 60) * 1000,
            currentResult.temperatureSummary.past24HourRange.maximum.metric.value,
            currentResult.temperatureSummary.past24HourRange.minimum.metric.value
        ),
    );
  } catch (e) {
    return null;
  }
}