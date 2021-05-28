class AccuCurrentResult {
  String localObservationDateTime;
  int epochTime;
  String weatherText;
  int weatherIcon;
  bool hasPrecipitation;
  Null precipitationType;
  LocalSource localSource;
  bool isDayTime;
  Temperature temperature;
  Temperature realFeelTemperature;
  Temperature realFeelTemperatureShade;
  int relativeHumidity;
  int indoorRelativeHumidity;
  Temperature dewPoint;
  Wind wind;
  WindGust windGust;
  int uVIndex;
  String uVIndexText;
  Temperature visibility;
  String obstructionsToVisibility;
  int cloudCover;
  Temperature ceiling;
  Temperature pressure;
  PressureTendency pressureTendency;
  Temperature past24HourTemperatureDeparture;
  Temperature apparentTemperature;
  Temperature windChillTemperature;
  Temperature wetBulbTemperature;
  Temperature precip1hr;
  PrecipitationSummary precipitationSummary;
  TemperatureSummary temperatureSummary;
  String mobileLink;
  String link;

  AccuCurrentResult(
      {this.localObservationDateTime,
        this.epochTime,
        this.weatherText,
        this.weatherIcon,
        this.hasPrecipitation,
        this.precipitationType,
        this.localSource,
        this.isDayTime,
        this.temperature,
        this.realFeelTemperature,
        this.realFeelTemperatureShade,
        this.relativeHumidity,
        this.indoorRelativeHumidity,
        this.dewPoint,
        this.wind,
        this.windGust,
        this.uVIndex,
        this.uVIndexText,
        this.visibility,
        this.obstructionsToVisibility,
        this.cloudCover,
        this.ceiling,
        this.pressure,
        this.pressureTendency,
        this.past24HourTemperatureDeparture,
        this.apparentTemperature,
        this.windChillTemperature,
        this.wetBulbTemperature,
        this.precip1hr,
        this.precipitationSummary,
        this.temperatureSummary,
        this.mobileLink,
        this.link});

  AccuCurrentResult.fromJson(Map<String, dynamic> json) {
    localObservationDateTime = json['LocalObservationDateTime'];
    epochTime = json['EpochTime'];
    weatherText = json['WeatherText'];
    weatherIcon = json['WeatherIcon'];
    hasPrecipitation = json['HasPrecipitation'];
    precipitationType = json['PrecipitationType'];
    localSource = json['LocalSource'] != null
        ? new LocalSource.fromJson(json['LocalSource'])
        : null;
    isDayTime = json['IsDayTime'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    realFeelTemperature = json['RealFeelTemperature'] != null
        ? new Temperature.fromJson(json['RealFeelTemperature'])
        : null;
    realFeelTemperatureShade = json['RealFeelTemperatureShade'] != null
        ? new Temperature.fromJson(json['RealFeelTemperatureShade'])
        : null;
    relativeHumidity = json['RelativeHumidity'];
    indoorRelativeHumidity = json['IndoorRelativeHumidity'];
    dewPoint = json['DewPoint'] != null
        ? new Temperature.fromJson(json['DewPoint'])
        : null;
    wind = json['Wind'] != null ? new Wind.fromJson(json['Wind']) : null;
    windGust = json['WindGust'] != null
        ? new WindGust.fromJson(json['WindGust'])
        : null;
    uVIndex = json['UVIndex'];
    uVIndexText = json['UVIndexText'];
    visibility = json['Visibility'] != null
        ? new Temperature.fromJson(json['Visibility'])
        : null;
    obstructionsToVisibility = json['ObstructionsToVisibility'];
    cloudCover = json['CloudCover'];
    ceiling = json['Ceiling'] != null
        ? new Temperature.fromJson(json['Ceiling'])
        : null;
    pressure = json['Pressure'] != null
        ? new Temperature.fromJson(json['Pressure'])
        : null;
    pressureTendency = json['PressureTendency'] != null
        ? new PressureTendency.fromJson(json['PressureTendency'])
        : null;
    past24HourTemperatureDeparture =
    json['Past24HourTemperatureDeparture'] != null
        ? new Temperature.fromJson(json['Past24HourTemperatureDeparture'])
        : null;
    apparentTemperature = json['ApparentTemperature'] != null
        ? new Temperature.fromJson(json['ApparentTemperature'])
        : null;
    windChillTemperature = json['WindChillTemperature'] != null
        ? new Temperature.fromJson(json['WindChillTemperature'])
        : null;
    wetBulbTemperature = json['WetBulbTemperature'] != null
        ? new Temperature.fromJson(json['WetBulbTemperature'])
        : null;
    precip1hr = json['Precip1hr'] != null
        ? new Temperature.fromJson(json['Precip1hr'])
        : null;
    precipitationSummary = json['PrecipitationSummary'] != null
        ? new PrecipitationSummary.fromJson(json['PrecipitationSummary'])
        : null;
    temperatureSummary = json['TemperatureSummary'] != null
        ? new TemperatureSummary.fromJson(json['TemperatureSummary'])
        : null;
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalObservationDateTime'] = this.localObservationDateTime;
    data['EpochTime'] = this.epochTime;
    data['WeatherText'] = this.weatherText;
    data['WeatherIcon'] = this.weatherIcon;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['PrecipitationType'] = this.precipitationType;
    if (this.localSource != null) {
      data['LocalSource'] = this.localSource.toJson();
    }
    data['IsDayTime'] = this.isDayTime;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    if (this.realFeelTemperature != null) {
      data['RealFeelTemperature'] = this.realFeelTemperature.toJson();
    }
    if (this.realFeelTemperatureShade != null) {
      data['RealFeelTemperatureShade'] = this.realFeelTemperatureShade.toJson();
    }
    data['RelativeHumidity'] = this.relativeHumidity;
    data['IndoorRelativeHumidity'] = this.indoorRelativeHumidity;
    if (this.dewPoint != null) {
      data['DewPoint'] = this.dewPoint.toJson();
    }
    if (this.wind != null) {
      data['Wind'] = this.wind.toJson();
    }
    if (this.windGust != null) {
      data['WindGust'] = this.windGust.toJson();
    }
    data['UVIndex'] = this.uVIndex;
    data['UVIndexText'] = this.uVIndexText;
    if (this.visibility != null) {
      data['Visibility'] = this.visibility.toJson();
    }
    data['ObstructionsToVisibility'] = this.obstructionsToVisibility;
    data['CloudCover'] = this.cloudCover;
    if (this.ceiling != null) {
      data['Ceiling'] = this.ceiling.toJson();
    }
    if (this.pressure != null) {
      data['Pressure'] = this.pressure.toJson();
    }
    if (this.pressureTendency != null) {
      data['PressureTendency'] = this.pressureTendency.toJson();
    }
    if (this.past24HourTemperatureDeparture != null) {
      data['Past24HourTemperatureDeparture'] =
          this.past24HourTemperatureDeparture.toJson();
    }
    if (this.apparentTemperature != null) {
      data['ApparentTemperature'] = this.apparentTemperature.toJson();
    }
    if (this.windChillTemperature != null) {
      data['WindChillTemperature'] = this.windChillTemperature.toJson();
    }
    if (this.wetBulbTemperature != null) {
      data['WetBulbTemperature'] = this.wetBulbTemperature.toJson();
    }
    if (this.precip1hr != null) {
      data['Precip1hr'] = this.precip1hr.toJson();
    }
    if (this.precipitationSummary != null) {
      data['PrecipitationSummary'] = this.precipitationSummary.toJson();
    }
    if (this.temperatureSummary != null) {
      data['TemperatureSummary'] = this.temperatureSummary.toJson();
    }
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}

class LocalSource {
  int id;
  String name;
  String weatherCode;

  LocalSource({this.id, this.name, this.weatherCode});

  LocalSource.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    weatherCode = json['WeatherCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['WeatherCode'] = this.weatherCode;
    return data;
  }
}

class Temperature {
  Imperial metric;
  Imperial imperial;

  Temperature({this.metric, this.imperial});

  Temperature.fromJson(Map<String, dynamic> json) {
    metric =
    json['Metric'] != null ? new Imperial.fromJson(json['Metric']) : null;
    imperial = json['Imperial'] != null
        ? new Imperial.fromJson(json['Imperial'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metric != null) {
      data['Metric'] = this.metric.toJson();
    }
    if (this.imperial != null) {
      data['Imperial'] = this.imperial.toJson();
    }
    return data;
  }
}

class Metric {
  double value;
  String unit;
  int unitType;

  Metric({this.value, this.unit, this.unitType});

  Metric.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    unit = json['Unit'];
    unitType = json['UnitType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Unit'] = this.unit;
    data['UnitType'] = this.unitType;
    return data;
  }
}

class Imperial {
  int value;
  String unit;
  int unitType;

  Imperial({this.value, this.unit, this.unitType});

  Imperial.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    unit = json['Unit'];
    unitType = json['UnitType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Unit'] = this.unit;
    data['UnitType'] = this.unitType;
    return data;
  }
}

class Wind {
  Direction direction;
  Temperature speed;

  Wind({this.direction, this.speed});

  Wind.fromJson(Map<String, dynamic> json) {
    direction = json['Direction'] != null
        ? new Direction.fromJson(json['Direction'])
        : null;
    speed =
    json['Speed'] != null ? new Temperature.fromJson(json['Speed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.direction != null) {
      data['Direction'] = this.direction.toJson();
    }
    if (this.speed != null) {
      data['Speed'] = this.speed.toJson();
    }
    return data;
  }
}

class Direction {
  int degrees;
  String localized;
  String english;

  Direction({this.degrees, this.localized, this.english});

  Direction.fromJson(Map<String, dynamic> json) {
    degrees = json['Degrees'];
    localized = json['Localized'];
    english = json['English'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Degrees'] = this.degrees;
    data['Localized'] = this.localized;
    data['English'] = this.english;
    return data;
  }
}

class WindGust {
  Temperature speed;

  WindGust({this.speed});

  WindGust.fromJson(Map<String, dynamic> json) {
    speed =
    json['Speed'] != null ? new Temperature.fromJson(json['Speed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.speed != null) {
      data['Speed'] = this.speed.toJson();
    }
    return data;
  }
}

class PressureTendency {
  String localizedText;
  String code;

  PressureTendency({this.localizedText, this.code});

  PressureTendency.fromJson(Map<String, dynamic> json) {
    localizedText = json['LocalizedText'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalizedText'] = this.localizedText;
    data['Code'] = this.code;
    return data;
  }
}

class PrecipitationSummary {
  Temperature precipitation;
  Temperature pastHour;
  Temperature past3Hours;
  Temperature past6Hours;
  Temperature past9Hours;
  Temperature past12Hours;
  Temperature past18Hours;
  Temperature past24Hours;

  PrecipitationSummary(
      {this.precipitation,
        this.pastHour,
        this.past3Hours,
        this.past6Hours,
        this.past9Hours,
        this.past12Hours,
        this.past18Hours,
        this.past24Hours});

  PrecipitationSummary.fromJson(Map<String, dynamic> json) {
    precipitation = json['Precipitation'] != null
        ? new Temperature.fromJson(json['Precipitation'])
        : null;
    pastHour = json['PastHour'] != null
        ? new Temperature.fromJson(json['PastHour'])
        : null;
    past3Hours = json['Past3Hours'] != null
        ? new Temperature.fromJson(json['Past3Hours'])
        : null;
    past6Hours = json['Past6Hours'] != null
        ? new Temperature.fromJson(json['Past6Hours'])
        : null;
    past9Hours = json['Past9Hours'] != null
        ? new Temperature.fromJson(json['Past9Hours'])
        : null;
    past12Hours = json['Past12Hours'] != null
        ? new Temperature.fromJson(json['Past12Hours'])
        : null;
    past18Hours = json['Past18Hours'] != null
        ? new Temperature.fromJson(json['Past18Hours'])
        : null;
    past24Hours = json['Past24Hours'] != null
        ? new Temperature.fromJson(json['Past24Hours'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.precipitation != null) {
      data['Precipitation'] = this.precipitation.toJson();
    }
    if (this.pastHour != null) {
      data['PastHour'] = this.pastHour.toJson();
    }
    if (this.past3Hours != null) {
      data['Past3Hours'] = this.past3Hours.toJson();
    }
    if (this.past6Hours != null) {
      data['Past6Hours'] = this.past6Hours.toJson();
    }
    if (this.past9Hours != null) {
      data['Past9Hours'] = this.past9Hours.toJson();
    }
    if (this.past12Hours != null) {
      data['Past12Hours'] = this.past12Hours.toJson();
    }
    if (this.past18Hours != null) {
      data['Past18Hours'] = this.past18Hours.toJson();
    }
    if (this.past24Hours != null) {
      data['Past24Hours'] = this.past24Hours.toJson();
    }
    return data;
  }
}

class TemperatureSummary {
  Past6HourRange past6HourRange;
  Past6HourRange past12HourRange;
  Past6HourRange past24HourRange;

  TemperatureSummary(
      {this.past6HourRange, this.past12HourRange, this.past24HourRange});

  TemperatureSummary.fromJson(Map<String, dynamic> json) {
    past6HourRange = json['Past6HourRange'] != null
        ? new Past6HourRange.fromJson(json['Past6HourRange'])
        : null;
    past12HourRange = json['Past12HourRange'] != null
        ? new Past6HourRange.fromJson(json['Past12HourRange'])
        : null;
    past24HourRange = json['Past24HourRange'] != null
        ? new Past6HourRange.fromJson(json['Past24HourRange'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.past6HourRange != null) {
      data['Past6HourRange'] = this.past6HourRange.toJson();
    }
    if (this.past12HourRange != null) {
      data['Past12HourRange'] = this.past12HourRange.toJson();
    }
    if (this.past24HourRange != null) {
      data['Past24HourRange'] = this.past24HourRange.toJson();
    }
    return data;
  }
}

class Past6HourRange {
  Temperature minimum;
  Temperature maximum;

  Past6HourRange({this.minimum, this.maximum});

  Past6HourRange.fromJson(Map<String, dynamic> json) {
    minimum = json['Minimum'] != null
        ? new Temperature.fromJson(json['Minimum'])
        : null;
    maximum = json['Maximum'] != null
        ? new Temperature.fromJson(json['Maximum'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.minimum != null) {
      data['Minimum'] = this.minimum.toJson();
    }
    if (this.maximum != null) {
      data['Maximum'] = this.maximum.toJson();
    }
    return data;
  }
}
