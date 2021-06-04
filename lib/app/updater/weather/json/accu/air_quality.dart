class AccuAirQualityResult {
  String date;
  int epochDate;
  int index;
  double particulateMatter25;
  double particulateMatter10;
  double ozone;
  double carbonMonoxide;
  double nitrogenMonoxide;
  double nitrogenDioxide;
  double sulfurDioxide;
  String source;

  AccuAirQualityResult(
      {this.date,
        this.epochDate,
        this.index,
        this.particulateMatter25,
        this.particulateMatter10,
        this.ozone,
        this.carbonMonoxide,
        this.nitrogenMonoxide,
        this.nitrogenDioxide,
        this.sulfurDioxide,
        this.source});

  AccuAirQualityResult.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    epochDate = json['EpochDate'];
    index = json['Index'];
    particulateMatter25 = json['ParticulateMatter2_5'];
    particulateMatter10 = json['ParticulateMatter10'];
    ozone = json['Ozone'];
    carbonMonoxide = json['CarbonMonoxide'];
    nitrogenMonoxide = json['NitrogenMonoxide'];
    nitrogenDioxide = json['NitrogenDioxide'];
    sulfurDioxide = json['SulfurDioxide'];
    source = json['Source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['EpochDate'] = this.epochDate;
    data['Index'] = this.index;
    data['ParticulateMatter2_5'] = this.particulateMatter25;
    data['ParticulateMatter10'] = this.particulateMatter10;
    data['Ozone'] = this.ozone;
    data['CarbonMonoxide'] = this.carbonMonoxide;
    data['NitrogenMonoxide'] = this.nitrogenMonoxide;
    data['NitrogenDioxide'] = this.nitrogenDioxide;
    data['SulfurDioxide'] = this.sulfurDioxide;
    data['Source'] = this.source;
    return data;
  }
}
