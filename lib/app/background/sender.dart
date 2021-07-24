// @dart=2.12

import 'package:flutter/services.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/db/helper.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';

const _CHANNEL_NAME = 'com.wangdaye.geometricweather/sender';

const _METHOD_ON_UPDATE_COMPLETED = 'onUpdateCompleted';
const _METHOD_ON_POLLING_COMPLETED = 'onPollingCompleted';
const _METHOD_SEND_TODAY_FORECAST = 'sendTodayForecast';
const _METHOD_SEND_TOMORROW_FORECAST = 'sendTomorrowForecast';

const _PARAM_LOCATION = 'location';
const _PARAM_LOCATION_LIST = 'locationList';
const _PARAM_SUCCEED = 'succeed';
const _PARAM_INDEX = 'index';
const _PARAM_TOTAL = 'total';

// send to native.
// called in polling progress or update in main interface
void sendLocationChanged(Location location, bool succeed, int index, int total) {
  final senderChannel = MethodChannel(_CHANNEL_NAME);

  // on update completed.
  senderChannel.invokeMethod(_METHOD_ON_UPDATE_COMPLETED, {
    _PARAM_LOCATION: location.toJson(),
    _PARAM_SUCCEED: succeed,
    _PARAM_INDEX: index,
    _PARAM_TOTAL: total,
  });

  SettingsManager.getInstance().then((settings) {

    if (settings.todayForecastEnabled) {
      // today forecast.
      DatabaseHelper.getInstance().readTodayForecastRecord().then((value) {
        if (!_shouldSendForecast(value, settings.todayForecastTime)) {
          return;
        }

        DatabaseHelper.getInstance().writeTodayForecastRecord(DateTime.now());
        senderChannel.invokeMethod(_METHOD_SEND_TODAY_FORECAST, {
          _PARAM_LOCATION: location.toJson(),
        });
      });
    }

    if (settings.tomorrowForecastEnabled) {
      // tomorrow forecast.
      DatabaseHelper.getInstance().readTomorrowForecastRecord().then((value) {
        if (!_shouldSendForecast(value, settings.tomorrowForecastTime)) {
          return;
        }

        DatabaseHelper.getInstance().writeTomorrowForecastRecord(DateTime.now());
        senderChannel.invokeMethod(_METHOD_SEND_TOMORROW_FORECAST, {
          _PARAM_LOCATION: location.toJson(),
        });
      });
    }
  });
}

bool _shouldSendForecast(DateTime? record, String triggerTime) {
  final triggers = triggerTime.split(':');
  final trigger = int.parse(triggers[0]) * 60 + int.parse(triggers[1]);

  DateTime now = DateTime.now();
  final current = now.hour * 60 + now.minute;

  if (record == null) {
    return (current - trigger).abs() <= 1.5 * 60 || current > trigger;
  } else {
    return (current - trigger).abs() <= 1.5 * 60 || current > trigger && (
        now.year != record.year
            || now.month != record.month
            || now.day != record.day
    );
  }
}

// called when polling finish or location list changed in main interface.
void sendLocationListChanged(List<Location> locationList, bool succeed) {
  MethodChannel(_CHANNEL_NAME).invokeMethod(_METHOD_ON_POLLING_COMPLETED, {
    _PARAM_LOCATION_LIST: locationList.map((e) => e.toJson()).toList(),
    _PARAM_SUCCEED: succeed,
  });
}