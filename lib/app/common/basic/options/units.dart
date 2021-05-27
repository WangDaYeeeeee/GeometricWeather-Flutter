import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/options/_base.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

class TemperatureUnit extends Unit<int> {

  static Map<String, TemperatureUnit> getAll(BuildContext context) => {
    'c': TemperatureUnit._(
        "c",
        S.of(context).temperature_unit_c,
        S.of(context).temperature_unit_short_c,
        S.of(context).temperature_unit_c,
        (int valueInDefaultUnit) => valueInDefaultUnit
    ),
    "f": TemperatureUnit._(
        "f",
        S.of(context).temperature_unit_f,
        S.of(context).temperature_unit_short_f,
        S.of(context).temperature_unit_f,
        (int valueInDefaultUnit) => (32 + 1.8 * valueInDefaultUnit).toInt()
    ),
    "k": TemperatureUnit._(
        "k",
        S.of(context).temperature_unit_k,
        S.of(context).temperature_unit_short_k,
        S.of(context).temperature_unit_k,
        (int valueInDefaultUnit) => (273.15 + valueInDefaultUnit).toInt()
    )
  };

  TemperatureUnit._(
      String key,
      String name,
      this.shortName,
      String voice,
      ValueConverter<int> converter
  ) : super(key, name, voice, converter);

  final String shortName;

  String getValueWithShortUnit(int valueInDefaultUnit) {
    return '${formatValue(getValue(valueInDefaultUnit))}$shortName';
  }

  static TemperatureUnit toTemperatureUnit(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<TemperatureUnit> toTemperatureUnitList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class SpeedUnit extends Unit<double> {

  static Map<String, SpeedUnit> getAll(BuildContext context) => {
    'kph': SpeedUnit._(
        'kph',
        S.of(context).speed_unit_kph,
        S.of(context).speed_unit_voice_kph,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    'mps': SpeedUnit._(
        'mps',
        S.of(context).speed_unit_mps,
        S.of(context).speed_unit_voice_mps,
        (valueInDefaultUnit) => valueInDefaultUnit / 3.6
    ),
    'kn': SpeedUnit._(
        'kn',
        S.of(context).speed_unit_kn,
        S.of(context).speed_unit_voice_kn,
        (valueInDefaultUnit) => valueInDefaultUnit / 1.852
    ),
    'mph': SpeedUnit._(
        'mph',
        S.of(context).speed_unit_mph,
        S.of(context).speed_unit_voice_mph,
        (valueInDefaultUnit) => valueInDefaultUnit / 1.609
    ),
    'ftps': SpeedUnit._(
        'ftps',
        S.of(context).speed_unit_ftps,
        S.of(context).speed_unit_voice_ftps,
        (valueInDefaultUnit) => valueInDefaultUnit * 0.9113
    )
  };

  SpeedUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }

  static SpeedUnit toSpeedUnit(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<SpeedUnit> toSpeedUnitList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class RelativeHumidityUnit extends Unit<double> {

  static Map<String, RelativeHumidityUnit> getAll(BuildContext context) => {
    'percent': RelativeHumidityUnit._(
        'percent',
        '%',
        '%',
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  RelativeHumidityUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class ProbabilityUnit extends Unit<double> {

  static Map<String, ProbabilityUnit> getAll(BuildContext context) => {
    'percent': ProbabilityUnit._(
        'percent',
        '%',
        '%',
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  ProbabilityUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class PressureUnit extends Unit<double> {

  static Map<String, PressureUnit> getAll(BuildContext context) => {
    'mb': PressureUnit._(
        'mb',
        S.of(context).pressure_unit_mb,
        S.of(context).pressure_unit_voice_mb,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    'kpa': PressureUnit._(
        'kpa',
        S.of(context).pressure_unit_kpa,
        S.of(context).pressure_unit_voice_kpa,
        (valueInDefaultUnit) => 0.1 * valueInDefaultUnit
    ),
    'hpa': PressureUnit._(
        'hpa',
        S.of(context).pressure_unit_hpa,
        S.of(context).pressure_unit_voice_hpa,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    'atm': PressureUnit._(
        'atm',
        S.of(context).pressure_unit_atm,
        S.of(context).pressure_unit_voice_atm,
        (valueInDefaultUnit) => 0.0009869 * valueInDefaultUnit
    ),
    'mmhg': PressureUnit._(
        'mmhg',
        S.of(context).pressure_unit_mmhg,
        S.of(context).pressure_unit_voice_mmhg,
        (valueInDefaultUnit) => 0.75006 * valueInDefaultUnit
    ),
    'inhg': PressureUnit._(
        'inhg',
        S.of(context).pressure_unit_inhg,
        S.of(context).pressure_unit_voice_inhg,
        (valueInDefaultUnit) => 0.02953 * valueInDefaultUnit
    ),
    'kgfpsqcm': PressureUnit._(
        'kgfpsqcm',
        S.of(context).pressure_unit_kgfpsqcm,
        S.of(context).pressure_unit_voice_kgfpsqcm,
        (valueInDefaultUnit) => 0.00102 * valueInDefaultUnit
    )
  };

  PressureUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(2);
  }

  static PressureUnit toPressureUnit(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<PressureUnit> toPressureUnitList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class PrecipitationUnit extends Unit<double> {

  static Map<String, PrecipitationUnit> getAll(BuildContext context) => {
    'mm': PrecipitationUnit._(
        'mm',
        S.of(context).precipitation_unit_mm,
        S.of(context).precipitation_unit_voice_mm,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    'cm': PrecipitationUnit._(
        'cm',
        S.of(context).precipitation_unit_cm,
        S.of(context).precipitation_unit_voice_cm,
        (valueInDefaultUnit) => 0.1 * valueInDefaultUnit
    ),
    'in': PrecipitationUnit._(
        'in',
        S.of(context).precipitation_unit_in,
        S.of(context).precipitation_unit_voice_in,
        (valueInDefaultUnit) => 0.0394 * valueInDefaultUnit
    ),
    'lpsqm': PrecipitationUnit._(
        'lpsqm',
        S.of(context).precipitation_unit_lpsqm,
        S.of(context).precipitation_unit_voice_lpsqm,
            (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  PrecipitationUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }

  static PrecipitationUnit toPrecipitationUnit(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<PrecipitationUnit> toPrecipitationUnitList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class PollenUnit extends Unit<double> {

  static Map<String, PollenUnit> getAll(BuildContext context) => {
    'ppcm': PollenUnit._(
        'ppcm',
        S.of(context).pollen_unit_ppcm,
        S.of(context).pollen_unit_voice_ppcm,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  PollenUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
      ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class DurationUnit extends Unit<double> {

  static Map<String, PollenUnit> getAll(BuildContext context) => {
    'h': PollenUnit._(
        'h',
        S.of(context).duration_unit_h,
        S.of(context).duration_unit_voice_h,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  DurationUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
      ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class DistanceUnit extends Unit<double> {

  static Map<String, DistanceUnit> getAll(BuildContext context) => {
    'km': DistanceUnit._(
        'km',
        S.of(context).distance_unit_km,
        S.of(context).distance_unit_voice_km,
        (valueInDefaultUnit) => valueInDefaultUnit
    ),
    'm': DistanceUnit._(
        'm',
        S.of(context).distance_unit_m,
        S.of(context).distance_unit_voice_m,
        (valueInDefaultUnit) => 1000 * valueInDefaultUnit
    ),
    'mi': DistanceUnit._(
        'mi',
        S.of(context).distance_unit_mi,
        S.of(context).distance_unit_voice_mi,
        (valueInDefaultUnit) => 0.6213 * valueInDefaultUnit
    ),
    'nmi': DistanceUnit._(
        'nmi',
        S.of(context).distance_unit_nmi,
        S.of(context).distance_unit_voice_nmi,
        (valueInDefaultUnit) => 0.5399 * valueInDefaultUnit
    ),
    'ft': DistanceUnit._(
        'ft',
        S.of(context).distance_unit_ft,
        S.of(context).distance_unit_voice_ft,
        (valueInDefaultUnit) => 3280.8398 * valueInDefaultUnit
    )
  };

  DistanceUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(2);
  }

  static DistanceUnit toDistanceUnit(BuildContext context, String key) {
    return Pair.toPair(key, getAll(context));
  }

  static List<DistanceUnit> toDistanceUnitList(
      BuildContext context, List<String> keyList) {
    return Pair.toPairList(keyList, getAll(context));
  }
}

class CloudCoverUnit extends Unit<double> {

  static Map<String, CloudCoverUnit> getAll(BuildContext context) => {
    '%': CloudCoverUnit._(
        '%',
        '%',
        '%',
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  CloudCoverUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
  ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class AirQualityUnit extends Unit<double> {

  static Map<String, AirQualityUnit> getAll(BuildContext context) => {
    'mugpcum': AirQualityUnit._(
        'mugpcum',
        S.of(context).air_quality_unit_mugpcum,
        S.of(context).air_quality_unit_voice_mugpcum,
        (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  AirQualityUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
      ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}

class AirQualityCOUnit extends Unit<double> {

  static Map<String, AirQualityCOUnit> getAll(BuildContext context) => {
    'mgpcum': AirQualityCOUnit._(
        'mgpcum',
        S.of(context).air_quality_co_unit_mgpcum,
        S.of(context).air_quality_co_unit_voice_mgpcum,
            (valueInDefaultUnit) => valueInDefaultUnit
    )
  };

  AirQualityCOUnit._(
      String key,
      String name,
      String voice,
      ValueConverter<double> converter
      ) : super(key, name, voice, converter);

  @override
  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }
}