class AccuLocationResult {
  int version;
  String key;
  String type;
  int rank;
  String localizedName;
  String englishName;
  String primaryPostalCode;
  Region region;
  Region country;
  AdministrativeArea administrativeArea;
  TimeZone timeZone;
  GeoPosition geoPosition;
  bool isAlias;
  List<String> dataSets;

  AccuLocationResult(
      {this.version,
        this.key,
        this.type,
        this.rank,
        this.localizedName,
        this.englishName,
        this.primaryPostalCode,
        this.region,
        this.country,
        this.administrativeArea,
        this.timeZone,
        this.geoPosition,
        this.isAlias,
        this.dataSets});

  AccuLocationResult.fromJson(Map<String, dynamic> json) {
    version = json['Version'];
    key = json['Key'];
    type = json['Type'];
    rank = json['Rank'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
    primaryPostalCode = json['PrimaryPostalCode'];
    region =
    json['Region'] != null ? new Region.fromJson(json['Region']) : null;
    country =
    json['Country'] != null ? new Region.fromJson(json['Country']) : null;
    administrativeArea = json['AdministrativeArea'] != null
        ? new AdministrativeArea.fromJson(json['AdministrativeArea'])
        : null;
    timeZone = json['TimeZone'] != null
        ? new TimeZone.fromJson(json['TimeZone'])
        : null;
    geoPosition = json['GeoPosition'] != null
        ? new GeoPosition.fromJson(json['GeoPosition'])
        : null;
    isAlias = json['IsAlias'];
    dataSets = json['DataSets'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Version'] = this.version;
    data['Key'] = this.key;
    data['Type'] = this.type;
    data['Rank'] = this.rank;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    data['PrimaryPostalCode'] = this.primaryPostalCode;
    if (this.region != null) {
      data['Region'] = this.region.toJson();
    }
    if (this.country != null) {
      data['Country'] = this.country.toJson();
    }
    if (this.administrativeArea != null) {
      data['AdministrativeArea'] = this.administrativeArea.toJson();
    }
    if (this.timeZone != null) {
      data['TimeZone'] = this.timeZone.toJson();
    }
    if (this.geoPosition != null) {
      data['GeoPosition'] = this.geoPosition.toJson();
    }
    data['IsAlias'] = this.isAlias;
    data['DataSets'] = this.dataSets;
    return data;
  }
}

class Region {
  String iD;
  String localizedName;
  String englishName;

  Region({this.iD, this.localizedName, this.englishName});

  Region.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    return data;
  }
}

class AdministrativeArea {
  String iD;
  String localizedName;
  String englishName;
  int level;
  String localizedType;
  String englishType;
  String countryID;

  AdministrativeArea(
      {this.iD,
        this.localizedName,
        this.englishName,
        this.level,
        this.localizedType,
        this.englishType,
        this.countryID});

  AdministrativeArea.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
    level = json['Level'];
    localizedType = json['LocalizedType'];
    englishType = json['EnglishType'];
    countryID = json['CountryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    data['Level'] = this.level;
    data['LocalizedType'] = this.localizedType;
    data['EnglishType'] = this.englishType;
    data['CountryID'] = this.countryID;
    return data;
  }
}

class TimeZone {
  String code;
  String name;
  int gmtOffset;
  bool isDaylightSaving;
  Null nextOffsetChange;

  TimeZone(
      {this.code,
        this.name,
        this.gmtOffset,
        this.isDaylightSaving,
        this.nextOffsetChange});

  TimeZone.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    gmtOffset = json['GmtOffset'];
    isDaylightSaving = json['IsDaylightSaving'];
    nextOffsetChange = json['NextOffsetChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['GmtOffset'] = this.gmtOffset;
    data['IsDaylightSaving'] = this.isDaylightSaving;
    data['NextOffsetChange'] = this.nextOffsetChange;
    return data;
  }
}

class GeoPosition {
  double latitude;
  double longitude;
  Elevation elevation;

  GeoPosition({this.latitude, this.longitude, this.elevation});

  GeoPosition.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    elevation = json['Elevation'] != null
        ? new Elevation.fromJson(json['Elevation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    if (this.elevation != null) {
      data['Elevation'] = this.elevation.toJson();
    }
    return data;
  }
}

class Elevation {
  Metric metric;
  Metric imperial;

  Elevation({this.metric, this.imperial});

  Elevation.fromJson(Map<String, dynamic> json) {
    metric =
    json['Metric'] != null ? new Metric.fromJson(json['Metric']) : null;
    imperial =
    json['Imperial'] != null ? new Metric.fromJson(json['Imperial']) : null;
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
  int value;
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
