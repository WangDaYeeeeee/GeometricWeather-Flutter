import 'package:geometricweather_flutter/app/common/basic/options/appearance.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editor {

  Editor._(this._sp);

  final SharedPreferences _sp;

  Editor putString(String key, String value) {
    _sp.setString(key, value);
    return this;
  }

  Editor putStringList(String key, List<String> values) {
    _sp.setStringList(key, values);
    return this;
  }

  Editor putInt(String key, int value) {
    _sp.setInt(key, value);
    return this;
  }

  Editor putDouble(String key, double value) {
    _sp.setDouble(key, value);
    return this;
  }

  Editor putBool(String key, bool value) {
    _sp.setBool(key, value);
    return this;
  }

  Editor remove(String key) {
    _sp.remove(key);
    return this;
  }

  Editor clear() {
    _sp.clear();
    return this;
  }

  void apply() {
    // do nothing.
  }
}

class ConfigStore {

  static Future<ConfigStore> getInstance() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return ConfigStore._(sp);
  }

  ConfigStore._(this._sp);

  final SharedPreferences _sp;

  String getString(String key, String defaultValue) =>
      _sp.getString(key) ?? defaultValue;

  List<String> getStringSet(String key, List<String> defaultValue) =>
      _sp.getStringList(key) ?? defaultValue;

  int getInt(String key, int defaultValue) =>
      _sp.getInt(key) ?? defaultValue;

  double getDouble(String key, double defaultValue) =>
      _sp.getDouble(key) ?? defaultValue;

  bool getBool(String key, bool defaultValue) =>
      _sp.getBool(key) ?? defaultValue;

  bool contains(String key) => _sp.containsKey(key);

  Editor edit() => Editor._(_sp);
}

class SettingsManager {

  static SettingsManager _instance;
  static Future<SettingsManager> getInstance() async {
    if (_instance == null) {
      ConfigStore configStore = await ConfigStore.getInstance();
      if (_instance == null) {
        _instance = SettingsManager._(configStore);
      }
    }
    return _instance;
  }

  static bool get usable => _instance != null;

  SettingsManager._(this._configStore);

  final ConfigStore _configStore;

  DarkMode get darkMode => DarkMode.all[DarkMode.KEY_AUTO];

  List<CardDisplay> get cardDisplayList => [
    CardDisplay.all[CardDisplay.KEY_DAILY_OVERVIEW],
    CardDisplay.all[CardDisplay.KEY_HOURLY_OVERVIEW],
    CardDisplay.all[CardDisplay.KEY_AIR_QUALITY],
    CardDisplay.all[CardDisplay.KEY_ALLERGEN],
    CardDisplay.all[CardDisplay.KEY_SUNRISE_SUNSET],
    CardDisplay.all[CardDisplay.KEY_LIFE_DETAILS]
  ];

  WeatherSource get weatherSource => WeatherSource.all[WeatherSource.KEY_ACCU];

  TemperatureUnit get temperatureUnit => TemperatureUnit.all[TemperatureUnit.KEY_C];

  PrecipitationUnit get precipitationUnit => PrecipitationUnit.all[PrecipitationUnit.KEY_MM];

  String get resourceProviderId => DefaultResourceProvider.PROVIDER_ID;
}