import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/settings/page_settings.dart';
import 'package:geometricweather_flutter/app/settings/widgets.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

class UnitSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UnitSettingsPageState();
  }
}

class _UnitSettingsPageState extends AbstractSettingsPageState<UnitSettingsPage> {

  @override
  Widget buildBody(BuildContext context) {
    return SettingsList(
      sections: [
        getSection(context,
          title: S.of(context).settings_title_unit,
          tiles: [
            getTile(context,
              title: S.of(context).settings_title_temperature_unit,
              subtitle: settingsManager.temperatureUnit.nameGetter(context),
              onPressed: (BuildContext context) {
                // todo: temperature unit.
              },
            ),
          ],
        ),
      ],
    );
  }
}