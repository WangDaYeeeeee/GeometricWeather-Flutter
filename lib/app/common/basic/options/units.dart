import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/options/_base.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

class TemperatureUnit extends Unit<int> {
  
  static const KEY_C = "c";
  static const KEY_F = "f";
  static const KEY_K = "k";

  static Map<String, TemperatureUnit> all = {
    KEY_C: TemperatureUnit._(
        KEY_C,
        (context) => S.of(context).temperature_unit_c,
        (context) => S.of(context).temperature_unit_short_c,
        (context) => S.of(context).temperature_unit_c,
        (int valueInDefaultUnit) => valueInDefaultUnit
    ),
    KEY_F: TemperatureUnit._(
        KEY_F,
        (context) => S.of(context).temperature_unit_f,
        (context) => S.of(context).temperature_unit_short_f,
        (context) => S.of(context).temperature_unit_f,
        (int valueInDefaultUnit) => (32 + 1.8 * valueInDefaultUnit).toInt()
    ),
    KEY_K: TemperatureUnit._(
        KEY_K,
        (context) => S.of(context).temperature_unit_k,
        (context) => S.of(context).temperature_unit_short_k,
        (context) => S.of(context).temperature_unit_k,
        (int valueInDefaultUnit) => (273.15 + valueInDefaultUnit).toInt()
    )
  };

  TemperatureUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      this.shortNameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<int> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  final LocalizedStringGetter shortNameGetter;

  String getValueWithShortUnit(BuildContext context, int valueInDefaultUnit) {
    return '${formatValue(getValue(valueInDefaultUnit))}${shortNameGetter(context)}';
  }

  static TemperatureUnit toTemperatureUnit(String key) {
    return Pair.toPair(key, all);
  }

  static List<TemperatureUnit> toTemperatureUnitList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}

class SpeedUnit extends Unit<double> {

  static const KEY_KPH = "kph";
  static const KEY_MPS = "mps";
  static const KEY_KN = "kn";
  static const KEY_MPH = "mph";
  static const KEY_FTPS = "ftps";

  static Map<String, SpeedUnit> all = {
    KEY_KPH: SpeedUnit._(
        KEY_KPH,
        (context) => S.of(context).speed_unit_kph,
        (context) => S.of(context).speed_unit_voice_kph,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    KEY_MPS: SpeedUnit._(
        KEY_MPS,
        (context) => S.of(context).speed_unit_mps,
        (context) => S.of(context).speed_unit_voice_mps,
        (valueInDefaultUnit) => valueInDefaultUnit / 3.6
    ),
    KEY_KN: SpeedUnit._(
        KEY_KN,
        (context) => S.of(context).speed_unit_kn,
        (context) => S.of(context).speed_unit_voice_kn,
        (valueInDefaultUnit) => valueInDefaultUnit / 1.852
    ),
    KEY_MPH: SpeedUnit._(
        KEY_MPH,
        (context) => S.of(context).speed_unit_mph,
        (context) => S.of(context).speed_unit_voice_mph,
        (valueInDefaultUnit) => valueInDefaultUnit / 1.609
    ),
    KEY_FTPS: SpeedUnit._(
        KEY_FTPS,
        (context) => S.of(context).speed_unit_ftps,
        (context) => S.of(context).speed_unit_voice_ftps,
        (valueInDefaultUnit) => valueInDefaultUnit * 0.9113
    )
  };

  SpeedUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }

  static SpeedUnit toSpeedUnit(String key) {
    return Pair.toPair(key, all);
  }

  static List<SpeedUnit> toSpeedUnitList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}

class RelativeHumidityUnit extends Unit<double> {

  static const KEY_PERCENT = 'percent';

  static Map<String, RelativeHumidityUnit> all = {
    KEY_PERCENT: RelativeHumidityUnit._(
        KEY_PERCENT,
        (_) => '%',
        (_) => '%',
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  RelativeHumidityUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class ProbabilityUnit extends Unit<double> {

  static const KEY_PERCENT = 'percent';

  static Map<String, ProbabilityUnit> all = {
    KEY_PERCENT: ProbabilityUnit._(
        KEY_PERCENT,
        (_) => '%',
        (_) => '%',
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  ProbabilityUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(0);
  }
}

class PressureUnit extends Unit<double> {

  static const KEY_MB = "mb";
  static const KEY_KPA = "kpa";
  static const KEY_HPA = "hpa";
  static const KEY_ATM = "atm";
  static const KEY_MMHG = "mmhg";
  static const KEY_INHG = "inhg";
  static const KEY_KGFPSQCM = "kgfpsqcm";

  static Map<String, PressureUnit> all = {
    KEY_MB: PressureUnit._(
        KEY_MB,
        (context) => S.of(context).pressure_unit_mb,
        (context) => S.of(context).pressure_unit_voice_mb,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    KEY_KPA: PressureUnit._(
        KEY_KPA,
        (context) => S.of(context).pressure_unit_kpa,
        (context) => S.of(context).pressure_unit_voice_kpa,
        (valueInDefaultUnit) => 0.1 * valueInDefaultUnit
    ),
    KEY_HPA: PressureUnit._(
        KEY_HPA,
        (context) => S.of(context).pressure_unit_hpa,
        (context) => S.of(context).pressure_unit_voice_hpa,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    KEY_ATM: PressureUnit._(
        KEY_ATM,
        (context) => S.of(context).pressure_unit_atm,
        (context) => S.of(context).pressure_unit_voice_atm,
        (valueInDefaultUnit) => 0.0009869 * valueInDefaultUnit
    ),
    KEY_MMHG: PressureUnit._(
        KEY_MMHG,
        (context) => S.of(context).pressure_unit_mmhg,
        (context) => S.of(context).pressure_unit_voice_mmhg,
        (valueInDefaultUnit) => 0.75006 * valueInDefaultUnit
    ),
    KEY_INHG: PressureUnit._(
        KEY_INHG,
        (context) => S.of(context).pressure_unit_inhg,
        (context) => S.of(context).pressure_unit_voice_inhg,
        (valueInDefaultUnit) => 0.02953 * valueInDefaultUnit
    ),
    KEY_KGFPSQCM: PressureUnit._(
        KEY_KGFPSQCM,
        (context) => S.of(context).pressure_unit_kgfpsqcm,
        (context) => S.of(context).pressure_unit_voice_kgfpsqcm,
        (valueInDefaultUnit) => 0.00102 * valueInDefaultUnit
    )
  };

  PressureUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(2);
  }

  static PressureUnit toPressureUnit(String key) {
    return Pair.toPair(key, all);
  }

  static List<PressureUnit> toPressureUnitList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}

class PrecipitationUnit extends Unit<double> {

  static const KEY_MM = "mm";
  static const KEY_CM = "cm";
  static const KEY_IN = "in";
  static const KEY_LPSQM = "lpsqm";

  static Map<String, PrecipitationUnit> all = {
    KEY_MM: PrecipitationUnit._(
        KEY_MM,
        (context) => S.of(context).precipitation_unit_mm,
        (context) => S.of(context).precipitation_unit_voice_mm,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    KEY_CM: PrecipitationUnit._(
        KEY_CM,
        (context) => S.of(context).precipitation_unit_cm,
        (context) => S.of(context).precipitation_unit_voice_cm,
        (valueInDefaultUnit) => 0.1 * valueInDefaultUnit
    ),
    KEY_IN: PrecipitationUnit._(
        KEY_IN,
        (context) => S.of(context).precipitation_unit_in,
        (context) => S.of(context).precipitation_unit_voice_in,
        (valueInDefaultUnit) => 0.0394 * valueInDefaultUnit
    ),
    KEY_LPSQM: PrecipitationUnit._(
        KEY_LPSQM,
        (context) => S.of(context).precipitation_unit_lpsqm,
        (context) => S.of(context).precipitation_unit_voice_lpsqm,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  PrecipitationUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }

  static PrecipitationUnit toPrecipitationUnit(String key) {
    return Pair.toPair(key, all);
  }

  static List<PrecipitationUnit> toPrecipitationUnitList(List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }

  double getMilliMeters(double value) {
    return value / converter(1);
  }
}

class PollenUnit extends Unit<double> {

  static const KEY_PPCM = "ppcm";

  static Map<String, PollenUnit> all = {
    KEY_PPCM: PollenUnit._(
        KEY_PPCM,
        (context) => S.of(context).pollen_unit_ppcm,
        (context) => S.of(context).pollen_unit_voice_ppcm,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  PollenUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
      ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class DurationUnit extends Unit<double> {

  static const KEY_H = "h";

  static Map<String, PollenUnit> all = {
    KEY_H: PollenUnit._(
        KEY_H,
        (context) => S.of(context).duration_unit_h,
        (context) => S.of(context).duration_unit_voice_h,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  DurationUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
      ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class DistanceUnit extends Unit<double> {

  static const KEY_KM = "km";
  static const KEY_M = "m";
  static const KEY_MI = "mi";
  static const KEY_NMI = "nmi";
  static const KEY_FT = "ft";

  static Map<String, DistanceUnit> all = {
    KEY_KM: DistanceUnit._(
        KEY_KM,
        (context) => S.of(context).distance_unit_km,
        (context) => S.of(context).distance_unit_voice_km,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    KEY_M: DistanceUnit._(
        KEY_M,
        (context) => S.of(context).distance_unit_m,
        (context) => S.of(context).distance_unit_voice_m,
        (valueInDefaultUnit) => 1000 * valueInDefaultUnit
    ),
    KEY_MI: DistanceUnit._(
        KEY_MI,
        (context) => S.of(context).distance_unit_mi,
        (context) => S.of(context).distance_unit_voice_mi,
        (valueInDefaultUnit) => 0.6213 * valueInDefaultUnit
    ),
    KEY_NMI: DistanceUnit._(
        KEY_NMI,
        (context) => S.of(context).distance_unit_nmi,
        (context) => S.of(context).distance_unit_voice_nmi,
        (valueInDefaultUnit) => 0.5399 * valueInDefaultUnit
    ),
    KEY_FT: DistanceUnit._(
        KEY_FT,
        (context) => S.of(context).distance_unit_ft,
        (context) => S.of(context).distance_unit_voice_ft,
        (valueInDefaultUnit) => 3280.8398 * valueInDefaultUnit
    )
  };

  DistanceUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(2);
  }

  static DistanceUnit toDistanceUnit(String key) {
    return Pair.toPair(key, all);
  }

  static List<DistanceUnit> toDistanceUnitList(
      List<String> keyList) {
    return Pair.toPairList(keyList, all);
  }
}

class CloudCoverUnit extends Unit<double> {

  static const KEY_PERCENT = 'percent';

  static Map<String, CloudCoverUnit> all = {
    KEY_PERCENT: CloudCoverUnit._(
        KEY_PERCENT,
        (_) => '%',
        (_) => '%',
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  CloudCoverUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
  ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class AirQualityUnit extends Unit<double> {

  static const KEY_MUGPCUM = 'mugpcum';

  static Map<String, AirQualityUnit> all = {
    KEY_MUGPCUM: AirQualityUnit._(
        KEY_MUGPCUM,
        (context) => S.of(context).air_quality_unit_mugpcum,
        (context) => S.of(context).air_quality_unit_voice_mugpcum,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  AirQualityUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
      ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class AirQualityCOUnit extends Unit<double> {

  static const KEY_MGPCUM = 'mgpcum';

  static Map<String, AirQualityCOUnit> all = {
    KEY_MGPCUM: AirQualityCOUnit._(
        KEY_MGPCUM,
        (context) => S.of(context).air_quality_co_unit_mgpcum,
        (context) => S.of(context).air_quality_co_unit_voice_mgpcum,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  AirQualityCOUnit._(
      String key,
      LocalizedStringGetter nameGetter,
      LocalizedStringGetter voiceGetter,
      ValueConverter<double> converter
      ) : super(key, nameGetter, voiceGetter, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}