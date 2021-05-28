class AccuAlertResult {
  String countryCode;
  int alertID;
  Description description;
  String category;
  int priority;
  String type;
  String typeID;
  String level;
  Color color;
  String source;
  int sourceId;
  Null disclaimer;
  List<Area> area;
  bool haveReadyStatements;
  String mobileLink;
  String link;

  AccuAlertResult({this.countryCode, this.alertID, this.description, this.category, this.priority, this.type, this.typeID, this.level, this.color, this.source, this.sourceId, this.disclaimer, this.area, this.haveReadyStatements, this.mobileLink, this.link});

  AccuAlertResult.fromJson(Map<String, dynamic> json) {
    countryCode = json['CountryCode'];
    alertID = json['AlertID'];
    description = json['Description'] != null ? new Description.fromJson(json['Description']) : null;
    category = json['Category'];
    priority = json['Priority'];
    type = json['Type'];
    typeID = json['TypeID'];
    level = json['Level'];
    color = json['Color'] != null ? new Color.fromJson(json['Color']) : null;
    source = json['Source'];
    sourceId = json['SourceId'];
    disclaimer = json['Disclaimer'];
    if (json['Area'] != null) {
      area = new List<Area>();
      json['Area'].forEach((v) { area.add(new Area.fromJson(v)); });
    }
    haveReadyStatements = json['HaveReadyStatements'];
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CountryCode'] = this.countryCode;
    data['AlertID'] = this.alertID;
    if (this.description != null) {
      data['Description'] = this.description.toJson();
    }
    data['Category'] = this.category;
    data['Priority'] = this.priority;
    data['Type'] = this.type;
    data['TypeID'] = this.typeID;
    data['Level'] = this.level;
    if (this.color != null) {
      data['Color'] = this.color.toJson();
    }
    data['Source'] = this.source;
    data['SourceId'] = this.sourceId;
    data['Disclaimer'] = this.disclaimer;
    if (this.area != null) {
      data['Area'] = this.area.map((v) => v.toJson()).toList();
    }
    data['HaveReadyStatements'] = this.haveReadyStatements;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}

class Description {
  String localized;
  String english;

  Description({this.localized, this.english});

  Description.fromJson(Map<String, dynamic> json) {
    localized = json['Localized'];
    english = json['English'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Localized'] = this.localized;
    data['English'] = this.english;
    return data;
  }
}

class Color {
  String name;
  int red;
  int green;
  int blue;
  String hex;

  Color({this.name, this.red, this.green, this.blue, this.hex});

  Color.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    red = json['Red'];
    green = json['Green'];
    blue = json['Blue'];
    hex = json['Hex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Red'] = this.red;
    data['Green'] = this.green;
    data['Blue'] = this.blue;
    data['Hex'] = this.hex;
    return data;
  }
}

class Area {
  String name;
  String startTime;
  int epochStartTime;
  String endTime;
  int epochEndTime;
  Description lastAction;
  String text;
  String languageCode;
  String summary;

  Area({this.name, this.startTime, this.epochStartTime, this.endTime, this.epochEndTime, this.lastAction, this.text, this.languageCode, this.summary});

  Area.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    startTime = json['StartTime'];
    epochStartTime = json['EpochStartTime'];
    endTime = json['EndTime'];
    epochEndTime = json['EpochEndTime'];
    lastAction = json['LastAction'] != null ? new Description.fromJson(json['LastAction']) : null;
    text = json['Text'];
    languageCode = json['LanguageCode'];
    summary = json['Summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['StartTime'] = this.startTime;
    data['EpochStartTime'] = this.epochStartTime;
    data['EndTime'] = this.endTime;
    data['EpochEndTime'] = this.epochEndTime;
    if (this.lastAction != null) {
      data['LastAction'] = this.lastAction.toJson();
    }
    data['Text'] = this.text;
    data['LanguageCode'] = this.languageCode;
    data['Summary'] = this.summary;
    return data;
  }
}