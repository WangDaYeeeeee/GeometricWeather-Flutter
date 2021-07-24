import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart' as location;
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart' as weather;
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/updater/weather/converters/_common_converter.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/air_quality.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/alert.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/current.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/daily.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/hourly.dart';
import 'package:geometricweather_flutter/app/updater/weather/json/accu/location.dart';

location.Location toLocation(AccuLocationResult result, [
  location.Location src,
  String zipCode
]) {
  return location.Location(
      result.key,
      result.geoPosition.latitude,
      result.geoPosition.longitude,
      result.timeZone.name,
      result.country.localizedName,
      result.administrativeArea == null ? "" : result.administrativeArea.localizedName,
      result.localizedName + (zipCode == null ? "" : (" (" + zipCode + ")")),
      "",
      WeatherSource.all[WeatherSource.KEY_ACCU],
      src != null ? src.currentPosition : false,
      src != null ? src.residentPosition : false,
      !isEmptyString(result.country.iD)
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

Future<String> convertUnit(BuildContext context, String str) async {
  if (isEmptyString(str)) {
    return str;
  }

  // precipitation.
  PrecipitationUnit precipitationUnit = (await SettingsManager.getInstance()).precipitationUnit;

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

AirAndPollen getAirAndPollen(
    List<AirAndPollen> list, String name) {
  for (AirAndPollen item in list) {
    if (item.name == name) {
      return item;
    }
  }
  return null;
}


Future<weather.Weather> toWeather(
    location.Location location,
    AccuCurrentResult currentResult,
    AccuDailyResult dailyResult,
    List<AccuHourlyResult> hourlyResultList,
    List<AccuAlertResult> alertResultList,
    [AccuAirQualityResult aqiResult]) async {
  try {
    return weather.Weather(
        weather.Base(
            location.cityId,
            DateTime.now().millisecondsSinceEpoch,
            parseNullableDateString(removeTimezoneOfDateString(
                currentResult.localObservationDateTime
            )),
            parseNullableDateString(removeTimezoneOfDateString(
                currentResult.localObservationDateTime
            )).millisecondsSinceEpoch,
            DateTime.now(),
            DateTime.now().millisecondsSinceEpoch
        ),
        weather.Current(
            currentResult.weatherText,
            getWeatherCode(currentResult.weatherIcon),
            weather.Temperature(
                currentResult.temperature.metric.value.toInt(),
                currentResult.realFeelTemperature.metric.value.toInt(),
                currentResult.realFeelTemperatureShade.metric.value.toInt(),
                currentResult.apparentTemperature.metric.value.toInt(),
                currentResult.windChillTemperature.metric.value.toInt(),
                currentResult.wetBulbTemperature.metric.value.toInt(),
            ),
            weather.Precipitation(
                currentResult.precip1hr.metric.value.toDouble()
            ),
            weather.PrecipitationProbability(),
            weather.Wind(
                currentResult.wind.direction.localized,
                weather.WindDegree(currentResult.wind.direction.degrees.toDouble()),
                getWindLevelInt(currentResult.windGust.speed.metric.value.toDouble()),
                currentResult.windGust.speed.metric.value.toDouble(),
            ),
            weather.UV(currentResult.uVIndex, currentResult.uVIndexText),
            aqiResult == null
                ? weather.AirQuality()
                : weather.AirQuality(
                    getAqiQualityInt(aqiResult.index),
                    aqiResult.index,
                    aqiResult.particulateMatter25?.toDouble(),
                    aqiResult.particulateMatter10?.toDouble(),
                    aqiResult.sulfurDioxide?.toDouble(),
                    aqiResult.nitrogenDioxide?.toDouble(),
                    aqiResult.ozone?.toDouble(),
                    aqiResult.carbonMonoxide?.toDouble()
                ),
            currentResult.relativeHumidity.toDouble(),
            currentResult.pressure.metric.value.toDouble(),
            currentResult.visibility.metric.value.toDouble(),
            currentResult.dewPoint.metric.value.toInt(),
            currentResult.cloudCover,
            (currentResult.ceiling.metric.value / 1000.0).toDouble(),
            dailyResult.headline.text,
        ),
        await getDailyList(dailyResult),
        getHourlyList(hourlyResultList),
        getAlertList(alertResultList),
        weather.History(
            DateTime.fromMillisecondsSinceEpoch(
                parseNullableDateString(removeTimezoneOfDateString(
                    currentResult.localObservationDateTime
                )).millisecondsSinceEpoch - 24 * 60 * 60 * 1000
            ),
            DateTime.fromMillisecondsSinceEpoch(
                parseNullableDateString(removeTimezoneOfDateString(
                    currentResult.localObservationDateTime
                )).millisecondsSinceEpoch - 24 * 60 * 60 * 1000
            ).millisecondsSinceEpoch,
            currentResult.temperatureSummary.past24HourRange.maximum.metric.value.toInt(),
            currentResult.temperatureSummary.past24HourRange.minimum.metric.value.toInt()
        ),
    );
  } on Exception catch (e, stacktrace) {
    testLog(e.toString());
    testLog(stacktrace.toString());
    return null;
  }
}

weather.AirQuality getDailyAirQuality(List<AirAndPollen> list) {
  AirAndPollen aqi = getAirAndPollen(list, "AirQuality");
  int index = aqi == null ? null : aqi.value;
  if (index != null && index == 0) {
    index = null;
  }
  return weather.AirQuality(
      getAqiQualityInt(index),
      index,
      null,
      null,
      null,
      null,
      null,
      null
  );
}

weather.Pollen getDailyPollen(List<AirAndPollen> list) {
  AirAndPollen grass = getAirAndPollen(list, "Grass");
  AirAndPollen mold = getAirAndPollen(list, "Mold");
  AirAndPollen ragweed = getAirAndPollen(list, "Ragweed");
  AirAndPollen tree = getAirAndPollen(list, "Tree");
  return weather.Pollen(
      grass == null ? null : grass.value,
      grass == null ? null : grass.categoryValue,
      grass == null ? null : grass.category,
      mold == null ? null : mold.value,
      mold == null ? null : mold.categoryValue,
      mold == null ? null : mold.category,
      ragweed == null ? null : ragweed.value,
      ragweed == null ? null : ragweed.categoryValue,
      ragweed == null ? null : ragweed.category,
      tree == null ? null : tree.value,
      tree == null ? null : tree.categoryValue,
      tree == null ? null : tree.category
  );
}

weather.UV getDailyUV(List<AirAndPollen> list) {
  AirAndPollen uv = getAirAndPollen(list, "UVIndex");
  return weather.UV(
      uv == null ? null : uv.value,
      uv == null ? null : uv.category,
      null
  );
}

Future<List<weather.Daily>> getDailyList(AccuDailyResult dailyResult) async {
  List<weather.Daily> dailyList = [];

  for (DailyForecasts forecasts in dailyResult.dailyForecasts) {
    dailyList.add(
        weather.Daily(
            parseNullableDateString(
                removeTimezoneOfDateString(forecasts.date)
            ),
            parseNullableDateString(
                removeTimezoneOfDateString(forecasts.date)
            ).millisecondsSinceEpoch,
            [weather.HalfDay(
                forecasts.day.longPhrase,
                forecasts.day.shortPhrase,
                getWeatherCode(forecasts.day.icon),
                weather.Temperature(
                    forecasts.temperature.maximum.value.toInt(),
                    forecasts.realFeelTemperature.maximum.value.toInt(),
                    forecasts.realFeelTemperatureShade.maximum.value.toInt(),
                    null,
                    null,
                    null,
                    forecasts.degreeDaySummary.heating.value.toInt()
                ),
                weather.Precipitation(
                    forecasts.day.totalLiquid.value.toDouble(),
                    null,
                    forecasts.day.rain.value.toDouble(),
                    (forecasts.day.snow.value * 10).toDouble(),
                    forecasts.day.ice.value.toDouble()
                ),
                weather.PrecipitationProbability(
                    forecasts.day.precipitationProbability.toDouble(),
                    forecasts.day.thunderstormProbability.toDouble(),
                    forecasts.day.rainProbability.toDouble(),
                    forecasts.day.snowProbability.toDouble(),
                    forecasts.day.iceProbability.toDouble()
                ),
                weather.PrecipitationDuration(
                    forecasts.day.hoursOfPrecipitation.toDouble(),
                    null,
                    forecasts.day.hoursOfRain.toDouble(),
                    forecasts.day.hoursOfSnow.toDouble(),
                    forecasts.day.hoursOfIce.toDouble()
                ),
                weather.Wind(
                    forecasts.day.wind.direction.localized,
                    weather.WindDegree(forecasts.day.wind.direction.degrees.toDouble()), 
                    getWindLevelInt(forecasts.day.windGust.speed.value.toDouble()),
                    forecasts.day.windGust.speed.value.toDouble()
                ),
                forecasts.day.cloudCover
            ),
            weather.HalfDay(
                forecasts.night.longPhrase,
                forecasts.night.shortPhrase,
                getWeatherCode(forecasts.night.icon),
                weather.Temperature(
                    forecasts.temperature.minimum.value.toInt(),
                    forecasts.realFeelTemperature.minimum.value.toInt(),
                    forecasts.realFeelTemperatureShade.minimum.value.toInt(),
                    null,
                    null,
                    null,
                    forecasts.degreeDaySummary.cooling.value.toInt()
                ),
                weather.Precipitation(
                    forecasts.night.totalLiquid.value.toDouble(),
                    null,
                    forecasts.night.rain.value.toDouble(),
                    (forecasts.day.snow.value * 10).toDouble(),
                    forecasts.night.ice.value.toDouble()
                ),
                weather.PrecipitationProbability(
                    forecasts.night.precipitationProbability.toDouble(),
                    forecasts.night.thunderstormProbability.toDouble(),
                    forecasts.night.rainProbability.toDouble(),
                    forecasts.night.snowProbability.toDouble(),
                    forecasts.night.iceProbability.toDouble()
                ),
                weather.PrecipitationDuration(
                    forecasts.night.hoursOfPrecipitation.toDouble(),
                    null,
                    forecasts.night.hoursOfRain.toDouble(),
                    forecasts.night.hoursOfSnow.toDouble(),
                    forecasts.night.hoursOfIce.toDouble()
                ),
                weather.Wind(
                    forecasts.night.wind.direction.localized,
                    weather.WindDegree(forecasts.night.wind.direction.degrees.toDouble()),
                    getWindLevelInt(forecasts.night.windGust.speed.value.toDouble()),
                    forecasts.night.windGust.speed.value.toDouble()
                ),
                forecasts.night.cloudCover
            )],
            [
              weather.Astro(
                  parseNullableDateString(removeTimezoneOfDateString(forecasts.sun.rise)),
                  parseNullableDateString(removeTimezoneOfDateString(forecasts.sun.set))
              ),
              weather.Astro(
                  parseNullableDateString(removeTimezoneOfDateString(forecasts.moon.rise)),
                  parseNullableDateString(removeTimezoneOfDateString(forecasts.moon.set))
              )
            ],
            weather.MoonPhase(
                getMoonPhaseAngle(forecasts.moon.phase),
                forecasts.moon.phase
            ),
            getDailyAirQuality(forecasts.airAndPollen),
            getDailyPollen(forecasts.airAndPollen),
            getDailyUV(forecasts.airAndPollen),
            forecasts.hoursOfSun
        )
    );
  }
  return dailyList;
}

List<weather.Hourly> getHourlyList(List<AccuHourlyResult> resultList) {
  List<weather.Hourly> hourlyList = [];
  for (AccuHourlyResult result in resultList) {
    hourlyList.add(
        weather.Hourly(
            parseNullableDateString(
                removeTimezoneOfDateString(result.dateTime)
            ),
            parseNullableDateString(
                removeTimezoneOfDateString(result.dateTime)
            ).millisecondsSinceEpoch,
            result.isDaylight,
            result.iconPhrase,
            getWeatherCode(result.weatherIcon),
            weather.Temperature(
                toInt(result.temperature.value)
            ),
            weather.Precipitation(),
            weather.PrecipitationProbability(
                result.precipitationProbability.toDouble()
            )
        )
    );
  }
  return hourlyList;
}

List<weather.Alert> getAlertList(List<AccuAlertResult> resultList) {
  List<weather.Alert> alertList = [];
  for (AccuAlertResult result in resultList) {
    alertList.add(
        weather.Alert(
            result.alertID,
            parseNullableDateString(removeTimezoneOfDateString(result.area[0].startTime)),
            parseNullableDateString(
                removeTimezoneOfDateString(result.area[0].startTime)
            ).millisecondsSinceEpoch,
            result.description.localized,
            result.area[0].text,
            result.typeID,
            result.priority,
            ui.Color.fromARGB(255, result.color.red, result.color.green, result.color.blue).value
        )
    );
  }
  weather.Alert.deduplication(alertList);
  weather.Alert.descByTime(alertList);
  return alertList;
}