import 'package:geometricweather_flutter/generated/l10n.dart';

import '_base.dart';

class WidgetWeekIconMode extends Pair {

  static const KEY_AUTO = 'auto';
  static const KEY_DAYTIME = 'daytime';
  static const KEY_NIGHTTIME = 'nighttime';

  static Map<String, WidgetWeekIconMode> all = {
    KEY_AUTO: WidgetWeekIconMode._(
        KEY_AUTO, (context) => S.of(context).widget_week_icon_mode_auto
    ),
    KEY_DAYTIME: WidgetWeekIconMode._(
        KEY_DAYTIME, (context) => S.of(context).widget_week_icon_mode_daytime
    ),
    KEY_NIGHTTIME: WidgetWeekIconMode._(
        KEY_NIGHTTIME, (context) => S.of(context).widget_week_icon_mode_nighttime
    ),
  };

  WidgetWeekIconMode._(String key, LocalizedStringGetter nameGetter): super(key, nameGetter);
}