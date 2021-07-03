import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/options/notification.dart';
import 'package:geometricweather_flutter/app/common/basic/options/polling.dart';
import 'package:geometricweather_flutter/app/common/basic/options/widget.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/app_bar.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/scaffold.dart';
import 'package:geometricweather_flutter/app/common/ui/snackbar/container.dart';
import 'package:geometricweather_flutter/app/common/utils/router.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/settings/widgets.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:geometricweather_flutter/main.dart' as main;
import 'package:settings_ui/settings_ui.dart';

abstract class AbstractSettingsPageState<T extends GeoStatefulWidget>
    extends GeoState<T> {

  final GlobalKey<SnackBarContainerState> snackBarContainerKey = GlobalKey();
  final SettingsManager settingsManager = main.settingsManager;
  final ThemeManager themeManager = main.themeManager;

  @override
  Widget build(BuildContext context) {
    return GeoPlatformScaffold(
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
        child: buildBody(context),
      )
    );
  }

  String getOnOffSummary(BuildContext context, bool on) {
    return on ? S.of(context).on : S.of(context).off;
  }

  Widget buildBody(BuildContext context);
}

class SettingsPage extends GeoStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends AbstractSettingsPageState<SettingsPage> {

  @override
  Widget buildBody(BuildContext context) {
    final baseTiles = <SettingsTile>[
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
      /*
      getSwitchTile(context,
        title: S.of(context).settings_title_precipitation_notification_switch,
        subtitle: getOnOffSummary(context, settingsManager.precipitationAlertEnabled),
        switchValue: settingsManager.precipitationAlertEnabled,
        onToggle: (bool value) {
          setState(() {
            settingsManager.precipitationAlertEnabled = value;
          });
          // todo: precipitation alert.
        },
      ), */
      getListTile(context,
          title: S.of(context).settings_title_refresh_rate,
          subtitle: settingsManager.updateInterval.nameGetter(context),
          itemKeys: UpdateInterval.all.keys.toList(),
          itemNames: UpdateInterval.all.values.map((e) => e.nameGetter(context)).toList(),
          onSelect: (String value) {
            setState(() {
              settingsManager.updateInterval = UpdateInterval.all[value];
            });
            // todo: update interval.
          }
      ),
      getTile(context,
        title: S.of(context).settings_title_unit,
        onPressed: (BuildContext context) {
          Navigator.pushNamed(context, Routers.ROUTER_ID_UNIT_SETTINGS);
        },
      ),
      getTile(context,
        title: S.of(context).settings_title_appearance,
        onPressed: (BuildContext context) {
          Navigator.pushNamed(context, Routers.ROUTER_ID_APPEARANCE_SETTINGS);
        },
      ),
    ];
    if (Platform.isAndroid) {
      baseTiles.addAll([
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
        ),
        getTile(context,
          title: S.of(context).settings_title_live_wallpaper,
          subtitle: S.of(context).settings_summary_live_wallpaper,
          onPressed: (BuildContext context) {
            // todo: live wallpaper.
          },
        ),
      ]);
    }

    final notificationTiles = <SettingsTile>[
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
    ];
    if (Platform.isAndroid) {
      notificationTiles.addAll([
        getListTile(context,
          title: S.of(context).settings_title_notification_style,
          subtitle: settingsManager.notificationStyle.nameGetter(context),
          itemKeys: NotificationStyle.all.keys.toList(),
          itemNames: NotificationStyle.all.values.map((e) => e.nameGetter(context)).toList(),
          onSelect: (String value) {
            setState(() {
              settingsManager.notificationStyle = NotificationStyle.all[value];
            });
            // todo: notification style.
          }
        ),
        getSwitchTile(context,
          title: S.of(context).settings_title_notification_temp_icon,
          subtitle: getOnOffSummary(context, settingsManager.temperatureNotificationIcon),
          switchValue: settingsManager.temperatureNotificationIcon,
          onToggle: (bool value) {
            setState(() {
              settingsManager.temperatureNotificationIcon = value;
            });
            // todo: temperature notification icon.
          }
        ),
        getSwitchTile(context,
            title: S.of(context).settings_title_notification_can_be_cleared,
            subtitle: getOnOffSummary(context, settingsManager.notificationCanBeCleared),
            switchValue: settingsManager.notificationCanBeCleared,
            onToggle: (bool value) {
              setState(() {
                settingsManager.notificationCanBeCleared = value;
              });
              // todo: notification can be cleared.
            }
        ),
        getSwitchTile(context,
            title: S.of(context).settings_title_notification_hide_big_view,
            subtitle: getOnOffSummary(context, settingsManager.notificationHideBigView),
            switchValue: settingsManager.notificationHideBigView,
            onToggle: (bool value) {
              setState(() {
                settingsManager.notificationHideBigView = value;
              });
              // todo: notification hide big view.
            }
        ),
      ]);
    }

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
            getTimePickerTile(context,
              title: S.of(context).settings_title_forecast_today_time,
              currentTime: settingsManager.todayForecastTime,
              onPick: (String value) {
                setState(() {
                  settingsManager.todayForecastTime = value;
                });
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
            getTimePickerTile(context,
              title: S.of(context).settings_title_forecast_tomorrow_time,
              currentTime: settingsManager.tomorrowForecastTime,
              onPick: (String value) {
                setState(() {
                  settingsManager.tomorrowForecastTime = value;
                });
                // todo: tomorrow forecast time.
              },
            ),
          ],
        ),
        getSection(context,
          title: S.of(context).settings_category_widget,
          tiles: [
            getListTile(context,
                title: S.of(context).settings_title_week_icon_mode,
                subtitle: settingsManager.widgetWeekIconMode.nameGetter(context),
                itemKeys: WidgetWeekIconMode.all.keys.toList(),
                itemNames: WidgetWeekIconMode.all.values.map((e) => e.nameGetter(context)).toList(),
                onSelect: (String value) {
                  setState(() {
                    settingsManager.widgetWeekIconMode = WidgetWeekIconMode.all[value];
                  });
                  // todo: week icon mode of widget.
                }
            ),
          ],
        ),
        getSection(context,
          title: S.of(context).settings_category_notification,
          tiles: notificationTiles,
        ),
      ],
    );
  }
}