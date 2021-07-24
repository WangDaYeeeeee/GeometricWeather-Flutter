import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/background/helper.dart';
import 'package:geometricweather_flutter/app/common/basic/events.dart';
import 'package:geometricweather_flutter/app/common/basic/options/appearance.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/bus/helper.dart';
import 'package:geometricweather_flutter/app/common/utils/platform.dart';
import 'package:geometricweather_flutter/app/settings/page_settings.dart';
import 'package:geometricweather_flutter/app/settings/widgets.dart';
import 'package:geometricweather_flutter/app/theme/providers/providers.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../main.dart';

class AppearanceSettingsPage extends GeoStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppearanceSettingsPageState();
  }
}

class _AppearanceSettingsPageState
    extends AbstractSettingsPageState<AppearanceSettingsPage> {

  @override
  Widget buildBody(BuildContext context) {
    final tiles = [
      getListTile(context,
          title: S.of(context).settings_title_dark_mode,
          subtitle: settingsManager.darkMode.nameGetter(context),
          itemKeys: DarkMode.all.keys.toList(),
          itemNames: DarkMode.all.values.map((e) => e.nameGetter(context)).toList(),
          onSelect: (String value) {
            setState(() {
              settingsManager.darkMode = DarkMode.all[value];
              themeManager.update(darkMode: settingsManager.darkMode);
            });
          }
      ),
      getSwitchTile(context,
        title: S.of(context).settings_title_exchange_day_night_temp_switch,
        subtitle: getOnOffSummary(context, settingsManager.exchangeDayNightTemperature),
        switchValue: settingsManager.exchangeDayNightTemperature,
        onToggle: (bool value) {
          setState(() {
            EventBus.send(UpdateUIEvent());

            settingsManager.exchangeDayNightTemperature = value;
            // we need update all remote views.
            resetPollingBackgroundTask(settingsManager, true);
          });
        },
      )
    ];
    if (GeoPlatform.isMaterialStyle) {
      tiles.add(
        getTile(context,
          title: S.of(context).settings_title_icon_provider,
          subtitle: ResourceProvider(context, settingsManager.resourceProviderId).providerName,
          onPressed: (BuildContext context) {
            // todo: icon provider.
          }
        )
      );
    }

    return SettingsList(
      sections: [
        getSection(context,
          title: S.of(context).settings_title_appearance,
          tiles: tiles,
        ),
      ],
    );
  }
}