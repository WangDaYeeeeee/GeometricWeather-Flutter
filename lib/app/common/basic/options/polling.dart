import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

class UpdateInterval extends Pair {

  static const KEY_100 = '1:00'; // 1 hour.
  static const KEY_130 = '1:30'; // 1.5 hours.
  static const KEY_200 = '2:00'; // 2 hours.
  static const KEY_230 = '2:30';
  static const KEY_300 = '3:00';
  static const KEY_330 = '3:30';
  static const KEY_400 = '4:00';
  static const KEY_430 = '4:30';
  static const KEY_500 = '5:00';
  static const KEY_530 = '5:30';
  static const KEY_600 = '6:00';

  static Map<String, UpdateInterval> all = {
    KEY_100: UpdateInterval._(
        KEY_100, (context) => S.of(context).update_interval_100, 1.0
    ),
    KEY_130: UpdateInterval._(
        KEY_130, (context) => S.of(context).update_interval_130, 1.5
    ),
    KEY_200: UpdateInterval._(
        KEY_200, (context) => S.of(context).update_interval_200, 2.0
    ),
    KEY_230: UpdateInterval._(
        KEY_230, (context) => S.of(context).update_interval_230, 2.5
    ),
    KEY_300: UpdateInterval._(
        KEY_300, (context) => S.of(context).update_interval_300, 3.0
    ),
    KEY_330: UpdateInterval._(
        KEY_330, (context) => S.of(context).update_interval_330, 3.5
    ),
    KEY_400: UpdateInterval._(
        KEY_400, (context) => S.of(context).update_interval_400, 4.0
    ),
    KEY_430: UpdateInterval._(
        KEY_430, (context) => S.of(context).update_interval_430, 4.5
    ),
    KEY_500: UpdateInterval._(
        KEY_500, (context) => S.of(context).update_interval_500, 5.0
    ),
    KEY_530: UpdateInterval._(
        KEY_530, (context) => S.of(context).update_interval_530, 5.5
    ),
    KEY_600: UpdateInterval._(
        KEY_600, (context) => S.of(context).update_interval_600, 6.0
    ),
  };

  final double hours;

  UpdateInterval._(
      String key,
      LocalizedStringGetter nameGetter,
      this.hours): super(key, nameGetter);
}