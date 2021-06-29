import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

SettingsSection getSection(BuildContext context, {
  @required String title,
  @required List<SettingsTile> tiles,
}) {
  return SettingsSection(
    title: title,
    tiles: tiles,
    titleTextStyle: Theme.of(context).textTheme.button,
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
  );
}