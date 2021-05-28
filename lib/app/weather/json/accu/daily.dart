class AccuDailyResult {
  Headline headline;
  List<DailyForecasts> dailyForecasts;

  AccuDailyResult({this.headline, this.dailyForecasts});

  AccuDailyResult.fromJson(Map<String, dynamic> json) {
    headline = json['Headline'] != null
        ? new Headline.fromJson(json['Headline'])
        : null;
    if (json['DailyForecasts'] != null) {
      dailyForecasts = new List<DailyForecasts>();
      json['DailyForecasts'].forEach((v) {
        dailyForecasts.add(new DailyForecasts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.headline != null) {
      data['Headline'] = this.headline.toJson();
    }
    if (this.dailyForecasts != null) {
      data['DailyForecasts'] =
          this.dailyForecasts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Headline {
  String effectiveDate;
  int effectiveEpochDate;
  int severity;
  String text;
  String category;
  String endDate;
  int endEpochDate;
  String mobileLink;
  String link;

  Headline(
      {this.effectiveDate,
        this.effectiveEpochDate,
        this.severity,
        this.text,
        this.category,
        this.endDate,
        this.endEpochDate,
        this.mobileLink,
        this.link});

  Headline.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['EffectiveDate'];
    effectiveEpochDate = json['EffectiveEpochDate'];
    severity = json['Severity'];
    text = json['Text'];
    category = json['Category'];
    endDate = json['EndDate'];
    endEpochDate = json['EndEpochDate'];
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EffectiveDate'] = this.effectiveDate;
    data['EffectiveEpochDate'] = this.effectiveEpochDate;
    data['Severity'] = this.severity;
    data['Text'] = this.text;
    data['Category'] = this.category;
    data['EndDate'] = this.endDate;
    data['EndEpochDate'] = this.endEpochDate;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}

class DailyForecasts {
  String date;
  int epochDate;
  Sun sun;
  Moon moon;
  Temperature temperature;
  Temperature realFeelTemperature;
  Temperature realFeelTemperatureShade;
  double hoursOfSun;
  DegreeDaySummary degreeDaySummary;
  List<AirAndPollen> airAndPollen;
  Day day;
  Night night;
  List<String> sources;
  String mobileLink;
  String link;

  DailyForecasts(
      {this.date,
        this.epochDate,
        this.sun,
        this.moon,
        this.temperature,
        this.realFeelTemperature,
        this.realFeelTemperatureShade,
        this.hoursOfSun,
        this.degreeDaySummary,
        this.airAndPollen,
        this.day,
        this.night,
        this.sources,
        this.mobileLink,
        this.link});

  DailyForecasts.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    epochDate = json['EpochDate'];
    sun = json['Sun'] != null ? new Sun.fromJson(json['Sun']) : null;
    moon = json['Moon'] != null ? new Moon.fromJson(json['Moon']) : null;
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    realFeelTemperature = json['RealFeelTemperature'] != null
        ? new Temperature.fromJson(json['RealFeelTemperature'])
        : null;
    realFeelTemperatureShade = json['RealFeelTemperatureShade'] != null
        ? new Temperature.fromJson(json['RealFeelTemperatureShade'])
        : null;
    hoursOfSun = json['HoursOfSun'];
    degreeDaySummary = json['DegreeDaySummary'] != null
        ? new DegreeDaySummary.fromJson(json['DegreeDaySummary'])
        : null;
    if (json['AirAndPollen'] != null) {
      airAndPollen = new List<AirAndPollen>();
      json['AirAndPollen'].forEach((v) {
        airAndPollen.add(new AirAndPollen.fromJson(v));
      });
    }
    day = json['Day'] != null ? new Day.fromJson(json['Day']) : null;
    night = json['Night'] != null ? new Night.fromJson(json['Night']) : null;
    sources = json['Sources'].cast<String>();
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['EpochDate'] = this.epochDate;
    if (this.sun != null) {
      data['Sun'] = this.sun.toJson();
    }
    if (this.moon != null) {
      data['Moon'] = this.moon.toJson();
    }
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    if (this.realFeelTemperature != null) {
      data['RealFeelTemperature'] = this.realFeelTemperature.toJson();
    }
    if (this.realFeelTemperatureShade != null) {
      data['RealFeelTemperatureShade'] = this.realFeelTemperatureShade.toJson();
    }
    data['HoursOfSun'] = this.hoursOfSun;
    if (this.degreeDaySummary != null) {
      data['DegreeDaySummary'] = this.degreeDaySummary.toJson();
    }
    if (this.airAndPollen != null) {
      data['AirAndPollen'] = this.airAndPollen.map((v) => v.toJson()).toList();
    }
    if (this.day != null) {
      data['Day'] = this.day.toJson();
    }
    if (this.night != null) {
      data['Night'] = this.night.toJson();
    }
    data['Sources'] = this.sources;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}

class Sun {
  String rise;
  int epochRise;
  String set;
  int epochSet;

  Sun({this.rise, this.epochRise, this.set, this.epochSet});

  Sun.fromJson(Map<String, dynamic> json) {
    rise = json['Rise'];
    epochRise = json['EpochRise'];
    set = json['Set'];
    epochSet = json['EpochSet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Rise'] = this.rise;
    data['EpochRise'] = this.epochRise;
    data['Set'] = this.set;
    data['EpochSet'] = this.epochSet;
    return data;
  }
}

class Moon {
  String rise;
  int epochRise;
  String set;
  int epochSet;
  String phase;
  int age;

  Moon(
      {this.rise,
        this.epochRise,
        this.set,
        this.epochSet,
        this.phase,
        this.age});

  Moon.fromJson(Map<String, dynamic> json) {
    rise = json['Rise'];
    epochRise = json['EpochRise'];
    set = json['Set'];
    epochSet = json['EpochSet'];
    phase = json['Phase'];
    age = json['Age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Rise'] = this.rise;
    data['EpochRise'] = this.epochRise;
    data['Set'] = this.set;
    data['EpochSet'] = this.epochSet;
    data['Phase'] = this.phase;
    data['Age'] = this.age;
    return data;
  }
}

class Temperature {
  Minimum minimum;
  Minimum maximum;

  Temperature({this.minimum, this.maximum});

  Temperature.fromJson(Map<String, dynamic> json) {
    minimum =
    json['Minimum'] != null ? new Minimum.fromJson(json['Minimum']) : null;
    maximum =
    json['Maximum'] != null ? new Minimum.fromJson(json['Maximum']) : null;
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

class Minimum {
  int value;
  String unit;
  int unitType;

  Minimum({this.value, this.unit, this.unitType});

  Minimum.fromJson(Map<String, dynamic> json) {
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

class DegreeDaySummary {
  Minimum heating;
  Minimum cooling;

  DegreeDaySummary({this.heating, this.cooling});

  DegreeDaySummary.fromJson(Map<String, dynamic> json) {
    heating =
    json['Heating'] != null ? new Minimum.fromJson(json['Heating']) : null;
    cooling =
    json['Cooling'] != null ? new Minimum.fromJson(json['Cooling']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.heating != null) {
      data['Heating'] = this.heating.toJson();
    }
    if (this.cooling != null) {
      data['Cooling'] = this.cooling.toJson();
    }
    return data;
  }
}

class AirAndPollen {
  String name;
  int value;
  String category;
  int categoryValue;
  String type;

  AirAndPollen(
      {this.name, this.value, this.category, this.categoryValue, this.type});

  AirAndPollen.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    value = json['Value'];
    category = json['Category'];
    categoryValue = json['CategoryValue'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['Category'] = this.category;
    data['CategoryValue'] = this.categoryValue;
    data['Type'] = this.type;
    return data;
  }
}

class Day {
  int icon;
  String iconPhrase;
  bool hasPrecipitation;
  LocalSource localSource;
  String shortPhrase;
  String longPhrase;
  int precipitationProbability;
  int thunderstormProbability;
  int rainProbability;
  int snowProbability;
  int iceProbability;
  Wind wind;
  Wind windGust;
  Minimum totalLiquid;
  Minimum rain;
  Minimum snow;
  Minimum ice;
  double hoursOfPrecipitation;
  double hoursOfRain;
  int hoursOfSnow;
  int hoursOfIce;
  int cloudCover;
  String precipitationType;
  String precipitationIntensity;

  Day(
      {this.icon,
        this.iconPhrase,
        this.hasPrecipitation,
        this.localSource,
        this.shortPhrase,
        this.longPhrase,
        this.precipitationProbability,
        this.thunderstormProbability,
        this.rainProbability,
        this.snowProbability,
        this.iceProbability,
        this.wind,
        this.windGust,
        this.totalLiquid,
        this.rain,
        this.snow,
        this.ice,
        this.hoursOfPrecipitation,
        this.hoursOfRain,
        this.hoursOfSnow,
        this.hoursOfIce,
        this.cloudCover,
        this.precipitationType,
        this.precipitationIntensity});

  Day.fromJson(Map<String, dynamic> json) {
    icon = json['Icon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    localSource = json['LocalSource'] != null
        ? new LocalSource.fromJson(json['LocalSource'])
        : null;
    shortPhrase = json['ShortPhrase'];
    longPhrase = json['LongPhrase'];
    precipitationProbability = json['PrecipitationProbability'];
    thunderstormProbability = json['ThunderstormProbability'];
    rainProbability = json['RainProbability'];
    snowProbability = json['SnowProbability'];
    iceProbability = json['IceProbability'];
    wind = json['Wind'] != null ? new Wind.fromJson(json['Wind']) : null;
    windGust =
    json['WindGust'] != null ? new Wind.fromJson(json['WindGust']) : null;
    totalLiquid = json['TotalLiquid'] != null
        ? new Minimum.fromJson(json['TotalLiquid'])
        : null;
    rain = json['Rain'] != null ? new Minimum.fromJson(json['Rain']) : null;
    snow = json['Snow'] != null ? new Minimum.fromJson(json['Snow']) : null;
    ice = json['Ice'] != null ? new Minimum.fromJson(json['Ice']) : null;
    hoursOfPrecipitation = json['HoursOfPrecipitation'];
    hoursOfRain = json['HoursOfRain'];
    hoursOfSnow = json['HoursOfSnow'];
    hoursOfIce = json['HoursOfIce'];
    cloudCover = json['CloudCover'];
    precipitationType = json['PrecipitationType'];
    precipitationIntensity = json['PrecipitationIntensity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Icon'] = this.icon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    if (this.localSource != null) {
      data['LocalSource'] = this.localSource.toJson();
    }
    data['ShortPhrase'] = this.shortPhrase;
    data['LongPhrase'] = this.longPhrase;
    data['PrecipitationProbability'] = this.precipitationProbability;
    data['ThunderstormProbability'] = this.thunderstormProbability;
    data['RainProbability'] = this.rainProbability;
    data['SnowProbability'] = this.snowProbability;
    data['IceProbability'] = this.iceProbability;
    if (this.wind != null) {
      data['Wind'] = this.wind.toJson();
    }
    if (this.windGust != null) {
      data['WindGust'] = this.windGust.toJson();
    }
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
    data['HoursOfPrecipitation'] = this.hoursOfPrecipitation;
    data['HoursOfRain'] = this.hoursOfRain;
    data['HoursOfSnow'] = this.hoursOfSnow;
    data['HoursOfIce'] = this.hoursOfIce;
    data['CloudCover'] = this.cloudCover;
    data['PrecipitationType'] = this.precipitationType;
    data['PrecipitationIntensity'] = this.precipitationIntensity;
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

class Wind {
  Minimum speed;
  Direction direction;

  Wind({this.speed, this.direction});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['Speed'] != null ? new Minimum.fromJson(json['Speed']) : null;
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

class Night {
  int icon;
  String iconPhrase;
  bool hasPrecipitation;
  LocalSource localSource;
  String shortPhrase;
  String longPhrase;
  int precipitationProbability;
  int thunderstormProbability;
  int rainProbability;
  int snowProbability;
  int iceProbability;
  Wind wind;
  Wind windGust;
  Minimum totalLiquid;
  Minimum rain;
  Minimum snow;
  Minimum ice;
  int hoursOfPrecipitation;
  int hoursOfRain;
  int hoursOfSnow;
  int hoursOfIce;
  int cloudCover;
  String precipitationType;
  String precipitationIntensity;

  Night(
      {this.icon,
        this.iconPhrase,
        this.hasPrecipitation,
        this.localSource,
        this.shortPhrase,
        this.longPhrase,
        this.precipitationProbability,
        this.thunderstormProbability,
        this.rainProbability,
        this.snowProbability,
        this.iceProbability,
        this.wind,
        this.windGust,
        this.totalLiquid,
        this.rain,
        this.snow,
        this.ice,
        this.hoursOfPrecipitation,
        this.hoursOfRain,
        this.hoursOfSnow,
        this.hoursOfIce,
        this.cloudCover,
        this.precipitationType,
        this.precipitationIntensity});

  Night.fromJson(Map<String, dynamic> json) {
    icon = json['Icon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    localSource = json['LocalSource'] != null
        ? new LocalSource.fromJson(json['LocalSource'])
        : null;
    shortPhrase = json['ShortPhrase'];
    longPhrase = json['LongPhrase'];
    precipitationProbability = json['PrecipitationProbability'];
    thunderstormProbability = json['ThunderstormProbability'];
    rainProbability = json['RainProbability'];
    snowProbability = json['SnowProbability'];
    iceProbability = json['IceProbability'];
    wind = json['Wind'] != null ? new Wind.fromJson(json['Wind']) : null;
    windGust =
    json['WindGust'] != null ? new Wind.fromJson(json['WindGust']) : null;
    totalLiquid = json['TotalLiquid'] != null
        ? new Minimum.fromJson(json['TotalLiquid'])
        : null;
    rain = json['Rain'] != null ? new Minimum.fromJson(json['Rain']) : null;
    snow = json['Snow'] != null ? new Minimum.fromJson(json['Snow']) : null;
    ice = json['Ice'] != null ? new Minimum.fromJson(json['Ice']) : null;
    hoursOfPrecipitation = json['HoursOfPrecipitation'];
    hoursOfRain = json['HoursOfRain'];
    hoursOfSnow = json['HoursOfSnow'];
    hoursOfIce = json['HoursOfIce'];
    cloudCover = json['CloudCover'];
    precipitationType = json['PrecipitationType'];
    precipitationIntensity = json['PrecipitationIntensity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Icon'] = this.icon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    if (this.localSource != null) {
      data['LocalSource'] = this.localSource.toJson();
    }
    data['ShortPhrase'] = this.shortPhrase;
    data['LongPhrase'] = this.longPhrase;
    data['PrecipitationProbability'] = this.precipitationProbability;
    data['ThunderstormProbability'] = this.thunderstormProbability;
    data['RainProbability'] = this.rainProbability;
    data['SnowProbability'] = this.snowProbability;
    data['IceProbability'] = this.iceProbability;
    if (this.wind != null) {
      data['Wind'] = this.wind.toJson();
    }
    if (this.windGust != null) {
      data['WindGust'] = this.windGust.toJson();
    }
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
    data['HoursOfPrecipitation'] = this.hoursOfPrecipitation;
    data['HoursOfRain'] = this.hoursOfRain;
    data['HoursOfSnow'] = this.hoursOfSnow;
    data['HoursOfIce'] = this.hoursOfIce;
    data['CloudCover'] = this.cloudCover;
    data['PrecipitationType'] = this.precipitationType;
    data['PrecipitationIntensity'] = this.precipitationIntensity;
    return data;
  }
}
