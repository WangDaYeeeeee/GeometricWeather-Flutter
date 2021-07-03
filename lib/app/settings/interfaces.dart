import 'package:geometricweather_flutter/app/common/basic/options/appearance.dart';
import 'package:geometricweather_flutter/app/common/basic/options/notification.dart';
import 'package:geometricweather_flutter/app/common/basic/options/polling.dart';
import 'package:geometricweather_flutter/app/common/basic/options/providers.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/basic/options/widget.dart';
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

  List<CardDisplay> get cardDisplayList => [
    CardDisplay.all[CardDisplay.KEY_DAILY_OVERVIEW],
    CardDisplay.all[CardDisplay.KEY_HOURLY_OVERVIEW],
    CardDisplay.all[CardDisplay.KEY_AIR_QUALITY],
    CardDisplay.all[CardDisplay.KEY_ALLERGEN],
    CardDisplay.all[CardDisplay.KEY_SUNRISE_SUNSET],
    CardDisplay.all[CardDisplay.KEY_LIFE_DETAILS]
  ];

  bool get backgroundFree => _configStore.getBool(
      'background_free',
      true
  );

  set backgroundFree(bool value) {
    _configStore.edit()
        .putBool('background_free', value)
        .apply();
  }

  bool get alertEnabled => _configStore.getBool(
      'alert_enabled',
      true
  );

  set alertEnabled(bool value) {
    _configStore.edit()
        .putBool('alert_enabled', value)
        .apply();
  }

  bool get precipitationAlertEnabled => _configStore.getBool(
      'precipitation_alert_enabled',
      false
  );

  set precipitationAlertEnabled(bool value) {
    _configStore.edit()
        .putBool('precipitation_alert_enabled', value)
        .apply();
  }

  UpdateInterval get updateInterval => UpdateInterval.all[
    _configStore.getString('update_interval', UpdateInterval.KEY_130)
  ];

  set updateInterval(UpdateInterval value) {
    _configStore.edit()
        .putString('update_interval', value.key)
        .apply();
  }

  DarkMode get darkMode => DarkMode.all[
    _configStore.getString('dark_mode', DarkMode.KEY_SYSTEM)
  ];

  set darkMode(DarkMode value) {
    _configStore.edit()
        .putString('dark_mode', value.key)
        .apply();
  }

  bool get exchangeDayNightTemperature => _configStore.getBool(
      'exchange_day_night_temperature',
      false
  );

  set exchangeDayNightTemperature(bool value) {
    _configStore.edit()
        .putBool('exchange_day_night_temperature', value)
        .apply();
  }

  WeatherSource get weatherSource => WeatherSource.all[
    _configStore.getString('weather_source', WeatherSource.KEY_ACCU)
  ];

  set weatherSource(WeatherSource value) {
    _configStore.edit()
        .putString('weather_source', value.key)
        .apply();
  }

  TemperatureUnit get temperatureUnit => TemperatureUnit.all[
    _configStore.getString('temperature_unit', TemperatureUnit.KEY_C)
  ];

  set temperatureUnit(TemperatureUnit value) {
    _configStore.edit()
        .putString('temperature_unit', value.key)
        .apply();
  }

  PrecipitationUnit get precipitationUnit => PrecipitationUnit.all[
    _configStore.getString('precipitation_unit', PrecipitationUnit.KEY_MM)
  ];

  set precipitationUnit(PrecipitationUnit value) {
    _configStore.edit()
        .putString('precipitation_unit', value.key)
        .apply();
  }

  ProbabilityUnit get probabilityUnit => ProbabilityUnit.all[
    _configStore.getString('probability_unit', ProbabilityUnit.KEY_PERCENT)
  ];

  set probabilityUnit(ProbabilityUnit value) {
    _configStore.edit()
        .putString('probability_unit', value.key)
        .apply();
  }

  SpeedUnit get speedUnit => SpeedUnit.all[
    _configStore.getString('speed_unit', SpeedUnit.KEY_KPH)
  ];

  set speedUnit(SpeedUnit value) {
    _configStore.edit()
        .putString('speed_unit', value.key)
        .apply();
  }

  PressureUnit get pressureUnit => PressureUnit.all[
    _configStore.getString('pressure_unit', PressureUnit.KEY_MB)
  ];

  set pressureUnit(PressureUnit value) {
    _configStore.edit()
        .putString('pressure_unit', value.key)
        .apply();
  }

  DistanceUnit get distanceUnit => DistanceUnit.all[
    _configStore.getString('distance_unit', DistanceUnit.KEY_KM)
  ];

  set distanceUnit(DistanceUnit value) {
    _configStore.edit()
        .putString('distance_unit', value.key)
        .apply();
  }

  String get resourceProviderId => _configStore.getString(
      'resource_provider_id',
      DefaultResourceProvider.PROVIDER_ID
  );

  set resourceProviderId(String value) {
    _configStore.edit()
        .putString('resource_provider_id', value)
        .apply();
  }

  bool get todayForecastEnabled => _configStore.getBool(
      'today_forecast_enabled',
      true
  );

  set todayForecastEnabled(bool value) {
    _configStore.edit()
        .putBool('today_forecast_enabled', value)
        .apply();
  }

  String get todayForecastTime => _configStore.getString(
      'today_forecast_time',
      '08:00'
  );

  set todayForecastTime(String value) {
    _configStore.edit()
        .putString('today_forecast_time', value)
        .apply();
  }

  bool get tomorrowForecastEnabled => _configStore.getBool(
      'tomorrow_forecast_enabled',
      true
  );

  set tomorrowForecastEnabled(bool value) {
    _configStore.edit()
        .putBool('tomorrow_forecast_enabled', value)
        .apply();
  }

  String get tomorrowForecastTime => _configStore.getString(
      'tomorrow_forecast_time',
      '22:00'
  );

  set tomorrowForecastTime(String value) {
    _configStore.edit()
        .putString('tomorrow_forecast_time', value)
        .apply();
  }

  WidgetWeekIconMode get widgetWeekIconMode => WidgetWeekIconMode.all[
    _configStore.getString('widget_week_icon_mode', WidgetWeekIconMode.KEY_AUTO)
  ];

  set widgetWeekIconMode(WidgetWeekIconMode value) {
    _configStore.edit()
        .putString('widget_week_icon_mode', value.key)
        .apply();
  }

  bool get notificationEnabled => _configStore.getBool(
      'notification_enabled',
      false,
  );

  set notificationEnabled(bool value) {
    _configStore.edit()
        .putBool('notification_enabled', value)
        .apply();
  }

  NotificationStyle get notificationStyle => NotificationStyle.all[
  _configStore.getString('notification_style', NotificationStyle.KEY_DAILY)
  ];

  set notificationStyle(NotificationStyle value) {
    _configStore.edit()
        .putString('notification_style', value.key)
        .apply();
  }

  bool get temperatureNotificationIcon => _configStore.getBool(
    'temperature_notification_icon',
    false,
  );

  set temperatureNotificationIcon(bool value) {
    _configStore.edit()
        .putBool('temperature_notification_icon', value)
        .apply();
  }

  bool get notificationCanBeCleared => _configStore.getBool(
    'notification_can_be_cleared',
    false,
  );

  set notificationCanBeCleared(bool value) {
    _configStore.edit()
        .putBool('notification_can_be_cleared', value)
        .apply();
  }

  bool get notificationHideBigView => _configStore.getBool(
    'notification_hide_big_view',
    false,
  );

  set notificationHideBigView(bool value) {
    _configStore.edit()
        .putBool('notification_hide_big_view', value)
        .apply();
  }
}