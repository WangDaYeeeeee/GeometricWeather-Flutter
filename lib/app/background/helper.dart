import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/background/sender.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/db/helper.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/updater/helper.dart';
import 'package:geometricweather_flutter/app/updater/models.dart';

const _POLLING_TIMEOUT = 40;

const _CHANNEL_NAME = 'com.wangdaye.geometricweather/background';

const _METHOD_RESET_ALL_BACKGROUND_TASK = 'resetAllBackgroundTask';
const _METHOD_RESET_POLLING_BACKGROUND_TASK = 'resetPollingBackgroundTask';
const _METHOD_RESET_TODAY_FORECAST_BACKGROUND_TASK = 'resetTodayForecastBackgroundTask';
const _METHOD_RESET_TOMORROW_FORECAST_BACKGROUND_TASK = 'resetTomorrowForecastBackgroundTask';

const _PARAM_DART_POLLING_METHOD = 'dartPollingMethod';
const _PARAM_BACKGROUND_FREE = 'backgroundFree';
const _PARAM_FORCE_UPDATE = 'forceUpdate';
const _PARAM_POLLING_INTERVAL_IN_HOUR = 'pollingIntervalInHour';
const _PARAM_NEXT_DAY = 'nextDay';
const _PARAM_TODAY_FORECAST_ENABLED = 'todayForecastEnabled';
const _PARAM_TOMORROW_FORECAST_ENABLED = 'tomorrowForecastEnabled';
const _PARAM_TODAY_FORECAST_TIME = 'todayForecastTime';
const _PARAM_TOMORROW_FORECAST_TIME = 'tomorrowForecastTime';

final dartPollingMethod = PluginUtilities.getCallbackHandle(polling).toRawHandle();

// call from native.
void polling() {
  WidgetsFlutterBinding.ensureInitialized();
  testLog('polling begin on background.');

  StreamSubscription pollingSubscription;
  Timer timer;

  DatabaseHelper.getInstance().readLocationList().then((value) {
    int total = value.length;
    int progress = 0;
    bool succeed = true;

    final list = List<Location>.from(value);

    pollingSubscription = pollingUpdate(value).listen((event) {
      // send event.
      bool updateSucceed = event.status == UpdateStatus.REQUEST_SUCCEED;

      // save data.
      for (int i = 0; i < list.length; i ++) {
        if (list[i] == event.data) {
          list[i] = event.data;
          // send message.
          sendLocationChanged(
              event.data,
              updateSucceed,
              i,
              total
          );
          break;
        }
      }

      progress ++;
      succeed &= updateSucceed;
      testLog('polling progress = $progress/$total(${event.status}) on background.');

      if (progress >= total) {
        testLog('polling complete on background.');
        timer?.cancel();
        sendLocationListChanged(list, succeed);
      }
    });

    timer = Timer(Duration(seconds: _POLLING_TIMEOUT), () {
      testLog('polling timeout on background.');
      pollingSubscription?.cancel();
      sendLocationListChanged(list, false);
    });
  });
}

void resetAllBackgroundTask(
    SettingsManager settingsManager,
    bool forceUpdate) {

  MethodChannel(_CHANNEL_NAME).invokeMethod(_METHOD_RESET_ALL_BACKGROUND_TASK, {
    _PARAM_DART_POLLING_METHOD: dartPollingMethod,
    _PARAM_BACKGROUND_FREE: settingsManager.backgroundFree,
    _PARAM_FORCE_UPDATE: forceUpdate,
    _PARAM_POLLING_INTERVAL_IN_HOUR: settingsManager.updateInterval.hours,
    _PARAM_TODAY_FORECAST_ENABLED: settingsManager.todayForecastEnabled,
    _PARAM_TODAY_FORECAST_TIME: settingsManager.todayForecastTime,
    _PARAM_TOMORROW_FORECAST_ENABLED: settingsManager.tomorrowForecastEnabled,
    _PARAM_TOMORROW_FORECAST_TIME: settingsManager.tomorrowForecastTime,
  });
}

void resetPollingBackgroundTask(
    SettingsManager settingsManager,
    bool forceUpdate) {

  MethodChannel(_CHANNEL_NAME).invokeMethod(_METHOD_RESET_POLLING_BACKGROUND_TASK, {
    _PARAM_DART_POLLING_METHOD: dartPollingMethod,
    _PARAM_BACKGROUND_FREE: settingsManager.backgroundFree,
    _PARAM_FORCE_UPDATE: forceUpdate,
    _PARAM_POLLING_INTERVAL_IN_HOUR: settingsManager.updateInterval.hours,
  });
}

void resetTodayForecastBackgroundTask(
    SettingsManager settingsManager,
    bool forceUpdate,
    bool nextDay) {

  MethodChannel(_CHANNEL_NAME).invokeMethod(_METHOD_RESET_TODAY_FORECAST_BACKGROUND_TASK, {
    _PARAM_DART_POLLING_METHOD: dartPollingMethod,
    _PARAM_BACKGROUND_FREE: settingsManager.backgroundFree,
    _PARAM_FORCE_UPDATE: forceUpdate,
    _PARAM_NEXT_DAY: nextDay,
    _PARAM_TODAY_FORECAST_ENABLED: settingsManager.todayForecastEnabled,
    _PARAM_TODAY_FORECAST_TIME: settingsManager.todayForecastTime,
  });
}

void resetTomorrowForecastBackgroundTask(
    SettingsManager settingsManager,
    bool forceUpdate,
    bool nextDay) {

  MethodChannel(_CHANNEL_NAME).invokeMethod(_METHOD_RESET_TOMORROW_FORECAST_BACKGROUND_TASK, {
    _PARAM_DART_POLLING_METHOD: dartPollingMethod,
    _PARAM_BACKGROUND_FREE: settingsManager.backgroundFree,
    _PARAM_FORCE_UPDATE: forceUpdate,
    _PARAM_NEXT_DAY: nextDay,
    _PARAM_TOMORROW_FORECAST_ENABLED: settingsManager.tomorrowForecastEnabled,
    _PARAM_TOMORROW_FORECAST_TIME: settingsManager.tomorrowForecastTime,
  });
}