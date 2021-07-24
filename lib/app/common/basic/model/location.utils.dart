import 'dart:convert';

import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';


class WeatherSourceConverter {

  static WeatherSource fromJson(String json) => WeatherSource.all[json];

  static String toJson(WeatherSource object) => object.key;
}

class WeatherConverter {

  static Weather fromJson(String jsonStr) => isEmptyString(jsonStr)
      ? null
      : Weather.fromJson(json.decode(jsonStr));

  static String toJson(Weather object) => object == null
      ? null
      : json.encode(object.toJson());
}