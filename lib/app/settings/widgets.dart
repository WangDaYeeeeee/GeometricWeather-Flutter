import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/settings/time_picker.dart' as tp;
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

SettingsSection getSection(BuildContext context, {
  @required String title,
  @required List<SettingsTile> tiles,
}) {
  return SettingsSection(
    title: title,
    tiles: tiles,
    titleTextStyle: Theme.of(context).textTheme.caption.copyWith(
      fontWeight: FontWeight.bold,
    ),
    titlePadding: Platform.isAndroid ? EdgeInsets.symmetric(
      vertical: normalMargin,
      horizontal: normalMargin,
    ) : EdgeInsets.only(
      left: normalMargin,
      right: normalMargin,
      bottom: littleMargin,
    ),
  );
}

SettingsTile getTile(BuildContext context, {
  @required String title,
  String subtitle,
  @required Function(BuildContext context) onPressed,
}) {
  return SettingsTile(
    title: title,
    subtitle: subtitle,
    onPressed: onPressed,
    titleMaxLines: 3,
    titleTextStyle: Theme.of(context).textTheme.subtitle2,
    subtitleMaxLines: 3,
    subtitleTextStyle: Theme.of(context).textTheme.caption,
  );
}

SettingsTile getSwitchTile(BuildContext context, {
  @required String title,
  String subtitle,
  @required bool switchValue,
  @required Function(bool value) onToggle,
}) {
  return SettingsTile.switchTile(
    title: title,
    subtitle: subtitle,
    switchValue: switchValue,
    onToggle: onToggle,
    titleMaxLines: 3,
    titleTextStyle: Theme.of(context).textTheme.subtitle2,
    subtitleMaxLines: 3,
    subtitleTextStyle: Theme.of(context).textTheme.caption,
    switchActiveColor: Platform.isIOS
        ? CupertinoColors.activeGreen
        : ThemeColors.colorAlert,
  );
}

SettingsTile getListTile(BuildContext context, {
  @required String title,
  String subtitle,
  @required List<String> itemKeys,
  @required List<String> itemNames,
  @required Function(String value) onSelect,
}) {
  return SettingsTile(
    title: title,
    subtitle: subtitle,
    onPressed: (BuildContext context) {
      final theme = Theme.of(context);

      final options = <Widget>[];
      for (int i = 0; i < itemKeys.length; i ++) {
        options.add(
            SimpleDialogOption(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: littleMargin),
                child: Text(itemNames[i],
                  style: theme.textTheme.subtitle2,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, itemKeys[i]);
              },
            )
        );
      }

      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(title,
              style: theme.textTheme.headline6,
            ),
            children: options,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
          );
        }
      ).then((value) {
        if (value != null) {
          onSelect(value);
        }
      });
    },
    titleMaxLines: 3,
    titleTextStyle: Theme.of(context).textTheme.subtitle2,
    subtitleMaxLines: 3,
    subtitleTextStyle: Theme.of(context).textTheme.caption,
  );
}

SettingsTile getTimePickerTile(BuildContext context, {
  @required String title,
  @required String currentTime, // e.g. 14:34.
  @required Function(String value) onPick,
}) {
  return SettingsTile(
    title: title,
    subtitle: currentTime,
    onPressed: (BuildContext context) {
      return showDialog<TimeOfDay>(
        context: context,
        builder: (BuildContext context) {
          return tp.TimePickerDialog(
            initialTime: TimeOfDay(
              hour: int.parse(currentTime.split(':')[0]),
              minute: int.parse(currentTime.split(':')[1]),
            ),
            cancelText: S.of(context).cancel,
            confirmText: S.of(context).done,
            helpText: title,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
          );
        },
      ).then((value) {
        if (value != null) {
          String hour = value.hour < 10 ? '0${value.hour}' : '${value.hour}';
          String minute = value.minute < 10 ? '0${value.minute}' : '${value.minute}';

          onPick('$hour:$minute');
        }
      });
    },
    titleMaxLines: 3,
    titleTextStyle: Theme.of(context).textTheme.subtitle2,
    subtitleMaxLines: 3,
    subtitleTextStyle: Theme.of(context).textTheme.caption,
  );
}