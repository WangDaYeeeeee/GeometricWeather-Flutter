import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/app_bar.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/settings/widgets.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:geometricweather_flutter/main.dart' as main;
import 'package:settings_ui/settings_ui.dart';

abstract class AbstractSettingsPageState<T extends StatefulWidget>
    extends State<T> {

  final GlobalKey<SnackBarContainerState> snackBarContainerKey = GlobalKey();
  final SettingsManager settingsManager = main.settingsManager;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: GeoPlatformAppBar(context,
        leading: GeoPlatformAppBarBackLeading(context,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: GeoPlatformAppBarTitle(context, S.of(context).action_settings),
        trailingActions: [
          PlatformAppBarIconButton(context,
            materialIconData: Icons.info_outline,
            cupertinoIconData: CupertinoIcons.info_circle,
            onPressed: () {
              Navigator.pushNamed(context, Routers.ROUTER_ID_ABOUT);
            },
          ),
        ],
      ),
      body: SnackBarContainer(
        child: Theme(
          data: Theme.of(context).copyWith(
            accentColor: Platform.isIOS
                ? CupertinoColors.activeGreen
                : ThemeColors.colorAlert
          ),
          child: buildBody(context),
        ),
      )
    );
  }

  String getOnOffSummary(BuildContext context, bool on) {
    return on ? S.of(context).on : S.of(context).off;
  }

  Widget buildBody(BuildContext context);
}

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends AbstractSettingsPageState<SettingsPage> {

  @override
  Widget buildBody(BuildContext context) {
    final baseTiles = <SettingsTile>[];
    if (Platform.isAndroid) {
      baseTiles.add(
          getSwitchTile(context,
            title: S.of(context).settings_title_background_free,
            subtitle: settingsManager.backgroundFree
                ? S.of(context).settings_summary_background_free_on
                : S.of(context).settings_summary_background_free_off,
            switchValue: settingsManager.backgroundFree,
            onToggle: (bool value) {
              setState(() {
                settingsManager.backgroundFree = value;
              });
              // todo: background free.
            },
          )
      );
    }
    baseTiles.addAll([
      getSwitchTile(context,
        title: S.of(context).settings_title_alert_notification_switch,
        subtitle: getOnOffSummary(context, settingsManager.alertEnabled),
        switchValue: settingsManager.alertEnabled,
        onToggle: (bool value) {
          setState(() {
            settingsManager.alertEnabled = value;
          });
          // todo: alert.
        },
      ),
      getTile(context,
        title: S.of(context).settings_title_dark_mode,
        subtitle: settingsManager.darkMode.nameGetter(context),
        onPressed: (BuildContext context) {
          // todo: dark mode.
        },
      ),
      getTile(context,
        title: S.of(context).settings_title_unit,
        onPressed: (BuildContext context) {
          Navigator.pushNamed(context, Routers.ROUTER_ID_UNIT_SETTINGS);
        },
      ),
    ]);

    return SettingsList(
      sections: [
        getSection(context,
          title: S.of(context).settings_category_basic,
          tiles: baseTiles,
        ),
        getSection(context,
          title: S.of(context).settings_category_forecast,
          tiles: [
            getSwitchTile(context,
              title: S.of(context).settings_title_forecast_today,
              subtitle: getOnOffSummary(
                  context,
                  settingsManager.todayForecastEnabled
              ),
              switchValue: settingsManager.todayForecastEnabled,
              onToggle: (bool value) {
                setState(() {
                  settingsManager.todayForecastEnabled = value;
                });
                // todo: today forecast.
              },
            ),
            getTile(context,
              title: S.of(context).settings_title_forecast_today_time,
              subtitle: settingsManager.todayForecastTime,
              onPressed: (BuildContext context) {
                // todo: today forecast time.
              },
            ),
            getSwitchTile(context,
              title: S.of(context).settings_title_forecast_tomorrow,
              subtitle: getOnOffSummary(
                  context,
                  settingsManager.tomorrowForecastEnabled
              ),
              switchValue: settingsManager.tomorrowForecastEnabled,
              onToggle: (bool value) {
                setState(() {
                  settingsManager.tomorrowForecastEnabled = value;
                });
                // todo: tomorrow forecast.
              },
            ),
            getTile(context,
              title: S.of(context).settings_title_forecast_tomorrow_time,
              subtitle: settingsManager.tomorrowForecastTime,
              onPressed: (BuildContext context) {
                // todo: tomorrow forecast time.
              },
            ),
          ],
        ),
        getSection(context,
          title: S.of(context).settings_category_notification,
          tiles: [
            getSwitchTile(context,
              title: S.of(context).settings_title_notification,
              subtitle: getOnOffSummary(
                  context,
                  settingsManager.notificationEnabled
              ),
              switchValue: settingsManager.notificationEnabled,
              onToggle: (bool value) {
                setState(() {
                  settingsManager.notificationEnabled = value;
                });
                // todo: notification.
              },
            ),
          ],
        ),
      ],
    );
  }
}