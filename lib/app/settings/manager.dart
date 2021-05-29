import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';

class SettingsManager {

  static SettingsManager _instance;

  factory SettingsManager.getInstance() => _getInstance();
  static _getInstance() {
    if (_instance == null) {
      _instance = SettingsManager._();
    }
    return _instance;
  }

  SettingsManager._();

  get weatherSource => WeatherSource.all[WeatherSource.KEY_ACCU];

  get precipitationUnit => PrecipitationUnit.all[PrecipitationUnit.KEY_MM];
}