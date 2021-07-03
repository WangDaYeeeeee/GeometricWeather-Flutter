import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

class NotificationStyle extends Pair {

  static const KEY_NATIVE = 'native';
  static const KEY_CITIES = 'cities';
  static const KEY_DAILY = 'daily';
  static const KEY_HOURLY = 'hourly';

  static Map<String, NotificationStyle> all = {
    KEY_NATIVE: NotificationStyle._(
        KEY_NATIVE, (context) => S.of(context).notification_style_native
    ),
    KEY_CITIES: NotificationStyle._(
        KEY_CITIES, (context) => S.of(context).notification_style_cities
    ),
    KEY_DAILY: NotificationStyle._(
        KEY_DAILY, (context) => S.of(context).notification_style_daily
    ),
    KEY_HOURLY: NotificationStyle._(
        KEY_HOURLY, (context) => S.of(context).notification_style_hourly
    )
  };

  NotificationStyle._(String key, LocalizedStringGetter nameGetter): super(key, nameGetter);
}