class AccuHourlyResult {
  String dateTime;
  int epochDateTime;
  int weatherIcon;
  String iconPhrase;
  bool hasPrecipitation;
  bool isDaylight;
  Temperature temperature;
  Temperature realFeelTemperature;
  Temperature wetBulbTemperature;
  Temperature dewPoint;
  Wind wind;
  WindGust windGust;
  int relativeHumidity;
  int indoorRelativeHumidity;
  Temperature visibility;
  Ceiling ceiling;
  int uVIndex;
  String uVIndexText;
  int precipitationProbability;
  int rainProbability;
  int snowProbability;
  int iceProbability;
  Ceiling totalLiquid;
  Ceiling rain;
  Ceiling snow;
  Ceiling ice;
  int cloudCover;
  String mobileLink;
  String link;

  AccuHourlyResult(
      {this.dateTime,
        this.epochDateTime,
        this.weatherIcon,
        this.iconPhrase,
        this.hasPrecipitation,
        this.isDaylight,
        this.temperature,
        this.realFeelTemperature,
        this.wetBulbTemperature,
        this.dewPoint,
        this.wind,
        this.windGust,
        this.relativeHumidity,
        this.indoorRelativeHumidity,
        this.visibility,
        this.ceiling,
        this.uVIndex,
        this.uVIndexText,
        this.precipitationProbability,
        this.rainProbability,
        this.snowProbability,
        this.iceProbability,
        this.totalLiquid,
        this.rain,
        this.snow,
        this.ice,
        this.cloudCover,
        this.mobileLink,
        this.link});

  AccuHourlyResult.fromJson(Map<String, dynamic> json) {
    dateTime = json['DateTime'];
    epochDateTime = json['EpochDateTime'];
    weatherIcon = json['WeatherIcon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    isDaylight = json['IsDaylight'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    realFeelTemperature = json['RealFeelTemperature'] != null
        ? new Temperature.fromJson(json['RealFeelTemperature'])
        : null;
    wetBulbTemperature = json['WetBulbTemperature'] != null
        ? new Temperature.fromJson(json['WetBulbTemperature'])
        : null;
    dewPoint = json['DewPoint'] != null
        ? new Temperature.fromJson(json['DewPoint'])
        : null;
    wind = json['Wind'] != null ? new Wind.fromJson(json['Wind']) : null;
    windGust = json['WindGust'] != null
        ? new WindGust.fromJson(json['WindGust'])
        : null;
    relativeHumidity = json['RelativeHumidity'];
    indoorRelativeHumidity = json['IndoorRelativeHumidity'];
    visibility = json['Visibility'] != null
        ? new Temperature.fromJson(json['Visibility'])
        : null;
    ceiling =
    json['Ceiling'] != null ? new Ceiling.fromJson(json['Ceiling']) : null;
    uVIndex = json['UVIndex'];
    uVIndexText = json['UVIndexText'];
    precipitationProbability = json['PrecipitationProbability'];
    rainProbability = json['RainProbability'];
    snowProbability = json['SnowProbability'];
    iceProbability = json['IceProbability'];
    totalLiquid = json['TotalLiquid'] != null
        ? new Ceiling.fromJson(json['TotalLiquid'])
        : null;
    rain = json['Rain'] != null ? new Ceiling.fromJson(json['Rain']) : null;
    snow = json['Snow'] != null ? new Ceiling.fromJson(json['Snow']) : null;
    ice = json['Ice'] != null ? new Ceiling.fromJson(json['Ice']) : null;
    cloudCover = json['CloudCover'];
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DateTime'] = this.dateTime;
    data['EpochDateTime'] = this.epochDateTime;
    data['WeatherIcon'] = this.weatherIcon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['IsDaylight'] = this.isDaylight;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    if (this.realFeelTemperature != null) {
      data['RealFeelTemperature'] = this.realFeelTemperature.toJson();
    }
    if (this.wetBulbTemperature != null) {
      data['WetBulbTemperature'] = this.wetBulbTemperature.toJson();
    }
    if (this.dewPoint != null) {
      data['DewPoint'] = this.dewPoint.toJson();
    }
    if (this.wind != null) {
      data['Wind'] = this.wind.toJson();
    }
    if (this.windGust != null) {
      data['WindGust'] = this.windGust.toJson();
    }
    data['RelativeHumidity'] = this.relativeHumidity;
    data['IndoorRelativeHumidity'] = this.indoorRelativeHumidity;
    if (this.visibility != null) {
      data['Visibility'] = this.visibility.toJson();
    }
    if (this.ceiling != null) {
      data['Ceiling'] = this.ceiling.toJson();
    }
    data['UVIndex'] = this.uVIndex;
    data['UVIndexText'] = this.uVIndexText;
    data['PrecipitationProbability'] = this.precipitationProbability;
    data['RainProbability'] = this.rainProbability;
    data['SnowProbability'] = this.snowProbability;
    data['IceProbability'] = this.iceProbability;
    if (this.totalLiquid != null) {
      data['TotalLiquid'] = this.totalLiquid.toJson();
    }
    if (this.rain != null) {
      data['Rain'] = this.rain.toJson();
    }
    if (this.snow != null) {
      data['Snow'] = this.snow.toJson();
    }
    if (this.ice != null) {
      data['Ice'] = this.ice.toJson();
    }
    data['CloudCover'] = this.cloudCover;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}

class Temperature {
  double value;
  String unit;
  int unitType;

  Temperature({this.value, this.unit, this.unitType});

  Temperature.fromJson(Map<String, dynamic> json) {
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
  Temperature speed;
  Direction direction;

  Wind({this.speed, this.direction});

  Wind.fromJson(Map<String, dynamic> json) {
    speed =
    json['Speed'] != null ? new Temperature.fromJson(json['Speed']) : null;
    direction = json['Direction'] != null
        ? new Direction.fromJson(json['Direction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.speed != null) {
      data['Speed'] = this.speed.toJson();
    }
    if (this.direction != null) {
      data['Direction'] = this.direction.toJson();
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

class Ceiling {
  double value;
  String unit;
  int unitType;

  Ceiling({this.value, this.unit, this.unitType});

  Ceiling.fromJson(Map<String, dynamic> json) {
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
