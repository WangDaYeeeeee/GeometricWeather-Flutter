import 'package:flutter/material.dart';
import 'package:geometricweather_flutter/app/common/basic/options/units.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/settings/page_settings.dart';
import 'package:geometricweather_flutter/app/settings/widgets.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

class UnitSettingsPage extends GeoStatefulWidget {
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
            // temperature.
            getListTile(context,
              title: S.of(context).settings_title_temperature_unit,
              subtitle: settingsManager.temperatureUnit.nameGetter(context),
              itemKeys: TemperatureUnit.all.keys.toList(),
              itemNames: TemperatureUnit.all.values.map((e) => e.nameGetter(context)).toList(),
              onSelect: (String value) {
                setState(() {
                  settingsManager.temperatureUnit = TemperatureUnit.all[value];
                });
              },
            ),
            // distance.
            getListTile(context,
              title: S.of(context).settings_title_distance_unit,
              subtitle: settingsManager.distanceUnit.nameGetter(context),
              itemKeys: DistanceUnit.all.keys.toList(),
              itemNames: DistanceUnit.all.values.map((e) => e.nameGetter(context)).toList(),
              onSelect: (String value) {
                setState(() {
                  settingsManager.distanceUnit = DistanceUnit.all[value];
                });
              },
            ),
            // precipitation.
            getListTile(context,
              title: S.of(context).settings_title_precipitation_unit,
              subtitle: settingsManager.precipitationUnit.nameGetter(context),
              itemKeys: PrecipitationUnit.all.keys.toList(),
              itemNames: PrecipitationUnit.all.values.map((e) => e.nameGetter(context)).toList(),
              onSelect: (String value) {
                setState(() {
                  settingsManager.precipitationUnit = PrecipitationUnit.all[value];
                });
              },
            ),
            // pressure.
            getListTile(context,
              title: S.of(context).settings_title_pressure_unit,
              subtitle: settingsManager.pressureUnit.nameGetter(context),
              itemKeys: PressureUnit.all.keys.toList(),
              itemNames: PressureUnit.all.values.map((e) => e.nameGetter(context)).toList(),
              onSelect: (String value) {
                setState(() {
                  settingsManager.pressureUnit = PressureUnit.all[value];
                });
              },
            ),
            // speed.
            getListTile(context,
              title: S.of(context).settings_title_speed_unit,
              subtitle: settingsManager.speedUnit.nameGetter(context),
              itemKeys: SpeedUnit.all.keys.toList(),
              itemNames: SpeedUnit.all.values.map((e) => e.nameGetter(context)).toList(),
              onSelect: (String value) {
                setState(() {
                  settingsManager.speedUnit = SpeedUnit.all[value];
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}