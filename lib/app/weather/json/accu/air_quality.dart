class AccuAirQualityResult {
  String date;
  int epochDate;
  int index;
  int particulateMatter25;
  int particulateMatter10;
  int ozone;
  int carbonMonoxide;
  Null nitrogenMonoxide;
  int nitrogenDioxide;
  int sulfurDioxide;
  Null lead;
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
        this.lead,
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
    lead = json['Lead'];
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
    data['Lead'] = this.lead;
    data['Source'] = this.source;
    return data;
  }
}
