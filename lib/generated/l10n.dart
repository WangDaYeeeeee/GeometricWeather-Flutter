// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Weather`
  String get app_name {
    return Intl.message(
      'Weather',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Geometric Weather`
  String get geometric_weather {
    return Intl.message(
      'Geometric Weather',
      name: 'geometric_weather',
      desc: '',
      args: [],
    );
  }

  /// `Current location`
  String get current_location {
    return Intl.message(
      'Current location',
      name: 'current_location',
      desc: '',
      args: [],
    );
  }

  /// `Resident location`
  String get resident_location {
    return Intl.message(
      'Resident location',
      name: 'resident_location',
      desc: '',
      args: [],
    );
  }

  /// `default location`
  String get default_location {
    return Intl.message(
      'default location',
      name: 'default_location',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Refreshed at`
  String get refresh_at {
    return Intl.message(
      'Refreshed at',
      name: 'refresh_at',
      desc: '',
      args: [],
    );
  }

  /// `Local time`
  String get local_time {
    return Intl.message(
      'Local time',
      name: 'local_time',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation`
  String get precipitation {
    return Intl.message(
      'Precipitation',
      name: 'precipitation',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation probability`
  String get precipitation_probability {
    return Intl.message(
      'Precipitation probability',
      name: 'precipitation_probability',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation duration`
  String get precipitation_duration {
    return Intl.message(
      'Precipitation duration',
      name: 'precipitation_duration',
      desc: '',
      args: [],
    );
  }

  /// `daytime`
  String get maxi_temp {
    return Intl.message(
      'daytime',
      name: 'maxi_temp',
      desc: '',
      args: [],
    );
  }

  /// `nighttime`
  String get mini_temp {
    return Intl.message(
      'nighttime',
      name: 'mini_temp',
      desc: '',
      args: [],
    );
  }

  /// `time`
  String get time {
    return Intl.message(
      'time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `daytime`
  String get day {
    return Intl.message(
      'daytime',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `nighttime`
  String get night {
    return Intl.message(
      'nighttime',
      name: 'night',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get temperature {
    return Intl.message(
      'Temperature',
      name: 'temperature',
      desc: '',
      args: [],
    );
  }

  /// `Wind`
  String get wind {
    return Intl.message(
      'Wind',
      name: 'wind',
      desc: '',
      args: [],
    );
  }

  /// `Wind direction`
  String get wind_direction {
    return Intl.message(
      'Wind direction',
      name: 'wind_direction',
      desc: '',
      args: [],
    );
  }

  /// `Wind speed`
  String get wind_speed {
    return Intl.message(
      'Wind speed',
      name: 'wind_speed',
      desc: '',
      args: [],
    );
  }

  /// `Wind gauge`
  String get wind_level {
    return Intl.message(
      'Wind gauge',
      name: 'wind_level',
      desc: '',
      args: [],
    );
  }

  /// `Sensible temp`
  String get sensible_temp {
    return Intl.message(
      'Sensible temp',
      name: 'sensible_temp',
      desc: '',
      args: [],
    );
  }

  /// `Humidity`
  String get humidity {
    return Intl.message(
      'Humidity',
      name: 'humidity',
      desc: '',
      args: [],
    );
  }

  /// `UV index`
  String get uv_index {
    return Intl.message(
      'UV index',
      name: 'uv_index',
      desc: '',
      args: [],
    );
  }

  /// `Hours of sun`
  String get hours_of_sun {
    return Intl.message(
      'Hours of sun',
      name: 'hours_of_sun',
      desc: '',
      args: [],
    );
  }

  /// `Forecast`
  String get forecast {
    return Intl.message(
      'Forecast',
      name: 'forecast',
      desc: '',
      args: [],
    );
  }

  /// `Briefings`
  String get briefings {
    return Intl.message(
      'Briefings',
      name: 'briefings',
      desc: '',
      args: [],
    );
  }

  /// `Daytime`
  String get daytime {
    return Intl.message(
      'Daytime',
      name: 'daytime',
      desc: '',
      args: [],
    );
  }

  /// `Nighttime`
  String get nighttime {
    return Intl.message(
      'Nighttime',
      name: 'nighttime',
      desc: '',
      args: [],
    );
  }

  /// `Publish at`
  String get publish_at {
    return Intl.message(
      'Publish at',
      name: 'publish_at',
      desc: '',
      args: [],
    );
  }

  /// `Feels like`
  String get feels_like {
    return Intl.message(
      'Feels like',
      name: 'feels_like',
      desc: '',
      args: [],
    );
  }

  /// `Follow system`
  String get follow_system {
    return Intl.message(
      'Follow system',
      name: 'follow_system',
      desc: '',
      args: [],
    );
  }

  /// `Background information`
  String get background_information {
    return Intl.message(
      'Background information',
      name: 'background_information',
      desc: '',
      args: [],
    );
  }

  /// `Atmospheric pressure`
  String get pressure {
    return Intl.message(
      'Atmospheric pressure',
      name: 'pressure',
      desc: '',
      args: [],
    );
  }

  /// `Visibility`
  String get visibility {
    return Intl.message(
      'Visibility',
      name: 'visibility',
      desc: '',
      args: [],
    );
  }

  /// `Dew point`
  String get dew_point {
    return Intl.message(
      'Dew point',
      name: 'dew_point',
      desc: '',
      args: [],
    );
  }

  /// `Cloud cover`
  String get cloud_cover {
    return Intl.message(
      'Cloud cover',
      name: 'cloud_cover',
      desc: '',
      args: [],
    );
  }

  /// `Ceiling`
  String get ceiling {
    return Intl.message(
      'Ceiling',
      name: 'ceiling',
      desc: '',
      args: [],
    );
  }

  /// `Get more`
  String get get_more {
    return Intl.message(
      'Get more',
      name: 'get_more',
      desc: '',
      args: [],
    );
  }

  /// `Get more from app store`
  String get get_more_store {
    return Intl.message(
      'Get more from app store',
      name: 'get_more_store',
      desc: '',
      args: [],
    );
  }

  /// `Get more from GitHub`
  String get get_more_github {
    return Intl.message(
      'Get more from GitHub',
      name: 'get_more_github',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Restart`
  String get restart {
    return Intl.message(
      'Restart',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `:00`
  String get of_clock {
    return Intl.message(
      ':00',
      name: 'of_clock',
      desc: '',
      args: [],
    );
  }

  /// `yday`
  String get yesterday {
    return Intl.message(
      'yday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `tmw`
  String get tomorrow {
    return Intl.message(
      'tmw',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `week`
  String get week {
    return Intl.message(
      'week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get week_1 {
    return Intl.message(
      'Mon',
      name: 'week_1',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get week_2 {
    return Intl.message(
      'Tue',
      name: 'week_2',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get week_3 {
    return Intl.message(
      'Wed',
      name: 'week_3',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get week_4 {
    return Intl.message(
      'Thu',
      name: 'week_4',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get week_5 {
    return Intl.message(
      'Fri',
      name: 'week_5',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get week_6 {
    return Intl.message(
      'Sat',
      name: 'week_6',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get week_7 {
    return Intl.message(
      'Sun',
      name: 'week_7',
      desc: '',
      args: [],
    );
  }

  /// `Real feel`
  String get real_feel_temperature {
    return Intl.message(
      'Real feel',
      name: 'real_feel_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Real feel shade`
  String get real_feel_shade_temperature {
    return Intl.message(
      'Real feel shade',
      name: 'real_feel_shade_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Apparent`
  String get apparent_temperature {
    return Intl.message(
      'Apparent',
      name: 'apparent_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Wind chill`
  String get wind_chill_temperature {
    return Intl.message(
      'Wind chill',
      name: 'wind_chill_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Wet bulb`
  String get wet_bulb_temperature {
    return Intl.message(
      'Wet bulb',
      name: 'wet_bulb_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Degree day`
  String get degree_day_temperature {
    return Intl.message(
      'Degree day',
      name: 'degree_day_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm`
  String get thunderstorm {
    return Intl.message(
      'Thunderstorm',
      name: 'thunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `Rain`
  String get rain {
    return Intl.message(
      'Rain',
      name: 'rain',
      desc: '',
      args: [],
    );
  }

  /// `Snow`
  String get snow {
    return Intl.message(
      'Snow',
      name: 'snow',
      desc: '',
      args: [],
    );
  }

  /// `Ice`
  String get ice {
    return Intl.message(
      'Ice',
      name: 'ice',
      desc: '',
      args: [],
    );
  }

  /// `Calm`
  String get wind_0 {
    return Intl.message(
      'Calm',
      name: 'wind_0',
      desc: '',
      args: [],
    );
  }

  /// `Light air`
  String get wind_1 {
    return Intl.message(
      'Light air',
      name: 'wind_1',
      desc: '',
      args: [],
    );
  }

  /// `Light breeze`
  String get wind_2 {
    return Intl.message(
      'Light breeze',
      name: 'wind_2',
      desc: '',
      args: [],
    );
  }

  /// `Gentle breeze`
  String get wind_3 {
    return Intl.message(
      'Gentle breeze',
      name: 'wind_3',
      desc: '',
      args: [],
    );
  }

  /// `Moderate breeze`
  String get wind_4 {
    return Intl.message(
      'Moderate breeze',
      name: 'wind_4',
      desc: '',
      args: [],
    );
  }

  /// `Fresh breeze`
  String get wind_5 {
    return Intl.message(
      'Fresh breeze',
      name: 'wind_5',
      desc: '',
      args: [],
    );
  }

  /// `Strong breeze`
  String get wind_6 {
    return Intl.message(
      'Strong breeze',
      name: 'wind_6',
      desc: '',
      args: [],
    );
  }

  /// `Moderate gale`
  String get wind_7 {
    return Intl.message(
      'Moderate gale',
      name: 'wind_7',
      desc: '',
      args: [],
    );
  }

  /// `Gale`
  String get wind_8 {
    return Intl.message(
      'Gale',
      name: 'wind_8',
      desc: '',
      args: [],
    );
  }

  /// `Strong gale`
  String get wind_9 {
    return Intl.message(
      'Strong gale',
      name: 'wind_9',
      desc: '',
      args: [],
    );
  }

  /// `Storm`
  String get wind_10 {
    return Intl.message(
      'Storm',
      name: 'wind_10',
      desc: '',
      args: [],
    );
  }

  /// `Violent storm`
  String get wind_11 {
    return Intl.message(
      'Violent storm',
      name: 'wind_11',
      desc: '',
      args: [],
    );
  }

  /// `Hurricane`
  String get wind_12 {
    return Intl.message(
      'Hurricane',
      name: 'wind_12',
      desc: '',
      args: [],
    );
  }

  /// `Drizzle`
  String get precipitation_light {
    return Intl.message(
      'Drizzle',
      name: 'precipitation_light',
      desc: '',
      args: [],
    );
  }

  /// `Rain`
  String get precipitation_middle {
    return Intl.message(
      'Rain',
      name: 'precipitation_middle',
      desc: '',
      args: [],
    );
  }

  /// `Heavy rain`
  String get precipitation_heavy {
    return Intl.message(
      'Heavy rain',
      name: 'precipitation_heavy',
      desc: '',
      args: [],
    );
  }

  /// `Rainstorm`
  String get precipitation_rainstorm {
    return Intl.message(
      'Rainstorm',
      name: 'precipitation_rainstorm',
      desc: '',
      args: [],
    );
  }

  /// `Fresh air`
  String get aqi_1 {
    return Intl.message(
      'Fresh air',
      name: 'aqi_1',
      desc: '',
      args: [],
    );
  }

  /// `Clear air`
  String get aqi_2 {
    return Intl.message(
      'Clear air',
      name: 'aqi_2',
      desc: '',
      args: [],
    );
  }

  /// `Slight polluted`
  String get aqi_3 {
    return Intl.message(
      'Slight polluted',
      name: 'aqi_3',
      desc: '',
      args: [],
    );
  }

  /// `Moderate pollution`
  String get aqi_4 {
    return Intl.message(
      'Moderate pollution',
      name: 'aqi_4',
      desc: '',
      args: [],
    );
  }

  /// `Heavy pollution`
  String get aqi_5 {
    return Intl.message(
      'Heavy pollution',
      name: 'aqi_5',
      desc: '',
      args: [],
    );
  }

  /// `Severe pollution`
  String get aqi_6 {
    return Intl.message(
      'Severe pollution',
      name: 'aqi_6',
      desc: '',
      args: [],
    );
  }

  /// `New moon`
  String get phase_new {
    return Intl.message(
      'New moon',
      name: 'phase_new',
      desc: '',
      args: [],
    );
  }

  /// `Waxing crescent`
  String get phase_waxing_crescent {
    return Intl.message(
      'Waxing crescent',
      name: 'phase_waxing_crescent',
      desc: '',
      args: [],
    );
  }

  /// `First quarter`
  String get phase_first {
    return Intl.message(
      'First quarter',
      name: 'phase_first',
      desc: '',
      args: [],
    );
  }

  /// `Waxing gibbous`
  String get phase_waxing_gibbous {
    return Intl.message(
      'Waxing gibbous',
      name: 'phase_waxing_gibbous',
      desc: '',
      args: [],
    );
  }

  /// `Full moon`
  String get phase_full {
    return Intl.message(
      'Full moon',
      name: 'phase_full',
      desc: '',
      args: [],
    );
  }

  /// `Waning gibbous`
  String get phase_waning_gibbous {
    return Intl.message(
      'Waning gibbous',
      name: 'phase_waning_gibbous',
      desc: '',
      args: [],
    );
  }

  /// `Third quarter`
  String get phase_third {
    return Intl.message(
      'Third quarter',
      name: 'phase_third',
      desc: '',
      args: [],
    );
  }

  /// `Waning crescent`
  String get phase_waning_crescent {
    return Intl.message(
      'Waning crescent',
      name: 'phase_waning_crescent',
      desc: '',
      args: [],
    );
  }

  /// `Grass`
  String get grass {
    return Intl.message(
      'Grass',
      name: 'grass',
      desc: '',
      args: [],
    );
  }

  /// `Mold`
  String get mold {
    return Intl.message(
      'Mold',
      name: 'mold',
      desc: '',
      args: [],
    );
  }

  /// `Ragweed`
  String get ragweed {
    return Intl.message(
      'Ragweed',
      name: 'ragweed',
      desc: '',
      args: [],
    );
  }

  /// `Tree`
  String get tree {
    return Intl.message(
      'Tree',
      name: 'tree',
      desc: '',
      args: [],
    );
  }

  /// `Daily forecast`
  String get daily_overview {
    return Intl.message(
      'Daily forecast',
      name: 'daily_overview',
      desc: '',
      args: [],
    );
  }

  /// `Hourly forecast`
  String get hourly_overview {
    return Intl.message(
      'Hourly forecast',
      name: 'hourly_overview',
      desc: '',
      args: [],
    );
  }

  /// `Minutely forecast`
  String get minutely_overview {
    return Intl.message(
      'Minutely forecast',
      name: 'minutely_overview',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation forecast`
  String get precipitation_overview {
    return Intl.message(
      'Precipitation forecast',
      name: 'precipitation_overview',
      desc: '',
      args: [],
    );
  }

  /// `Air quality`
  String get air_quality {
    return Intl.message(
      'Air quality',
      name: 'air_quality',
      desc: '',
      args: [],
    );
  }

  /// `Allergen`
  String get allergen {
    return Intl.message(
      'Allergen',
      name: 'allergen',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get life_details {
    return Intl.message(
      'Details',
      name: 'life_details',
      desc: '',
      args: [],
    );
  }

  /// `Sun &amp; moon`
  String get sunrise_sunset {
    return Intl.message(
      'Sun &amp; moon',
      name: 'sunrise_sunset',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message(
      'NEXT',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `DONE`
  String get done {
    return Intl.message(
      'DONE',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel {
    return Intl.message(
      'CANCEL',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get on {
    return Intl.message(
      'Enabled',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `Disabled`
  String get off {
    return Intl.message(
      'Disabled',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `SET`
  String get go_to_set {
    return Intl.message(
      'SET',
      name: 'go_to_set',
      desc: '',
      args: [],
    );
  }

  /// `HELP`
  String get help {
    return Intl.message(
      'HELP',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `LEARN MORE`
  String get learn_more {
    return Intl.message(
      'LEARN MORE',
      name: 'learn_more',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter_weather_sources {
    return Intl.message(
      'Filter',
      name: 'filter_weather_sources',
      desc: '',
      args: [],
    );
  }

  /// `ABOUT APP`
  String get about_app {
    return Intl.message(
      'ABOUT APP',
      name: 'about_app',
      desc: '',
      args: [],
    );
  }

  /// `introduce`
  String get introduce {
    return Intl.message(
      'introduce',
      name: 'introduce',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `GitHub`
  String get gitHub {
    return Intl.message(
      'GitHub',
      name: 'gitHub',
      desc: '',
      args: [],
    );
  }

  /// `Translators`
  String get translator {
    return Intl.message(
      'Translators',
      name: 'translator',
      desc: '',
      args: [],
    );
  }

  /// `Thanks`
  String get thanks {
    return Intl.message(
      'Thanks',
      name: 'thanks',
      desc: '',
      args: [],
    );
  }

  /// `Alipay`
  String get alipay {
    return Intl.message(
      'Alipay',
      name: 'alipay',
      desc: '',
      args: [],
    );
  }

  /// `Wechat`
  String get wechat {
    return Intl.message(
      'Wechat',
      name: 'wechat',
      desc: '',
      args: [],
    );
  }

  /// `M-d`
  String get date_format_short {
    return Intl.message(
      'M-d',
      name: 'date_format_short',
      desc: '',
      args: [],
    );
  }

  /// `MMM d`
  String get date_format_long {
    return Intl.message(
      'MMM d',
      name: 'date_format_long',
      desc: '',
      args: [],
    );
  }

  /// `EEEE, MMM d`
  String get date_format_widget_short {
    return Intl.message(
      'EEEE, MMM d',
      name: 'date_format_widget_short',
      desc: '',
      args: [],
    );
  }

  /// `EEEE, MMM d`
  String get date_format_widget_long {
    return Intl.message(
      'EEEE, MMM d',
      name: 'date_format_widget_long',
      desc: '',
      args: [],
    );
  }

  /// `EEEE, MMM d│`
  String get date_format_widget_oreo_style {
    return Intl.message(
      'EEEE, MMM d│',
      name: 'date_format_widget_oreo_style',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get feedback_request_permission {
    return Intl.message(
      'Permissions',
      name: 'feedback_request_permission',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get feedback_request_location {
    return Intl.message(
      'Location',
      name: 'feedback_request_location',
      desc: '',
      args: [],
    );
  }

  /// `Locating in background`
  String get feedback_request_location_in_background {
    return Intl.message(
      'Locating in background',
      name: 'feedback_request_location_in_background',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions request success`
  String get feedback_request_location_permission_success {
    return Intl.message(
      'Location permissions request success',
      name: 'feedback_request_location_permission_success',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions request failed`
  String get feedback_request_location_permission_failed {
    return Intl.message(
      'Location permissions request failed',
      name: 'feedback_request_location_permission_failed',
      desc: '',
      args: [],
    );
  }

  /// `Access location information`
  String get feedback_location_permissions_title {
    return Intl.message(
      'Access location information',
      name: 'feedback_location_permissions_title',
      desc: '',
      args: [],
    );
  }

  /// `Geometric Weather needs to collect your location information in foreground or background to provide the weather data of your current location. For this, we will request some permissions. Your location information will only be used to obtain weather data at your current location. If you don't want us to obtain your location information, you can deny those requirements and manually set your location in the management page.`
  String get feedback_location_permissions_statement {
    return Intl.message(
      'Geometric Weather needs to collect your location information in foreground or background to provide the weather data of your current location. For this, we will request some permissions. Your location information will only be used to obtain weather data at your current location. If you don\'t want us to obtain your location information, you can deny those requirements and manually set your location in the management page.',
      name: 'feedback_location_permissions_statement',
      desc: '',
      args: [],
    );
  }

  /// `Access location in background`
  String get feedback_background_location_title {
    return Intl.message(
      'Access location in background',
      name: 'feedback_background_location_title',
      desc: '',
      args: [],
    );
  }

  /// `In order to allow the app to access location information in background, so that we can perceive changes in location and provide you with valid weather data, please set location access as "Allow all the time",`
  String get feedback_background_location_summary {
    return Intl.message(
      'In order to allow the app to access location information in background, so that we can perceive changes in location and provide you with valid weather data, please set location access as "Allow all the time",',
      name: 'feedback_background_location_summary',
      desc: '',
      args: [],
    );
  }

  /// `Location failed`
  String get feedback_location_failed {
    return Intl.message(
      'Location failed',
      name: 'feedback_location_failed',
      desc: '',
      args: [],
    );
  }

  /// `Request weather data failed`
  String get feedback_get_weather_failed {
    return Intl.message(
      'Request weather data failed',
      name: 'feedback_get_weather_failed',
      desc: '',
      args: [],
    );
  }

  /// `Cannot get location correctly?`
  String get feedback_location_help_title {
    return Intl.message(
      'Cannot get location correctly?',
      name: 'feedback_location_help_title',
      desc: '',
      args: [],
    );
  }

  /// `Check location permissions`
  String get feedback_check_location_permission {
    return Intl.message(
      'Check location permissions',
      name: 'feedback_check_location_permission',
      desc: '',
      args: [],
    );
  }

  /// `Enable Location Information`
  String get feedback_enable_location_information {
    return Intl.message(
      'Enable Location Information',
      name: 'feedback_enable_location_information',
      desc: '',
      args: [],
    );
  }

  /// `Select Location Provider`
  String get feedback_select_location_provider {
    return Intl.message(
      'Select Location Provider',
      name: 'feedback_select_location_provider',
      desc: '',
      args: [],
    );
  }

  /// `Add Location Manually And Delete '$'`
  String get feedback_add_location_manually {
    return Intl.message(
      'Add Location Manually And Delete \'\$\'',
      name: 'feedback_add_location_manually',
      desc: '',
      args: [],
    );
  }

  /// `Weather`
  String get feedback_live_wallpaper_weather_kind {
    return Intl.message(
      'Weather',
      name: 'feedback_live_wallpaper_weather_kind',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get feedback_live_wallpaper_day_night_type {
    return Intl.message(
      'Time',
      name: 'feedback_live_wallpaper_day_night_type',
      desc: '',
      args: [],
    );
  }

  /// `Press chart to toggle data`
  String get feedback_click_toggle {
    return Intl.message(
      'Press chart to toggle data',
      name: 'feedback_click_toggle',
      desc: '',
      args: [],
    );
  }

  /// `NO DATA`
  String get feedback_no_data {
    return Intl.message(
      'NO DATA',
      name: 'feedback_no_data',
      desc: '',
      args: [],
    );
  }

  /// `This location already exists`
  String get feedback_collect_failed {
    return Intl.message(
      'This location already exists',
      name: 'feedback_collect_failed',
      desc: '',
      args: [],
    );
  }

  /// `Add location success`
  String get feedback_collect_succeed {
    return Intl.message(
      'Add location success',
      name: 'feedback_collect_succeed',
      desc: '',
      args: [],
    );
  }

  /// `Delete location success`
  String get feedback_delete_succeed {
    return Intl.message(
      'Delete location success',
      name: 'feedback_delete_succeed',
      desc: '',
      args: [],
    );
  }

  /// `Location list cannot be empty`
  String get feedback_location_list_cannot_be_null {
    return Intl.message(
      'Location list cannot be empty',
      name: 'feedback_location_list_cannot_be_null',
      desc: '',
      args: [],
    );
  }

  /// `Search a location…`
  String get feedback_search_location {
    return Intl.message(
      'Search a location…',
      name: 'feedback_search_location',
      desc: '',
      args: [],
    );
  }

  /// `No location yet…`
  String get feedback_not_yet_location {
    return Intl.message(
      'No location yet…',
      name: 'feedback_not_yet_location',
      desc: '',
      args: [],
    );
  }

  /// `No locations found`
  String get feedback_search_nothing {
    return Intl.message(
      'No locations found',
      name: 'feedback_search_nothing',
      desc: '',
      args: [],
    );
  }

  /// `Initializing…`
  String get feedback_initializing {
    return Intl.message(
      'Initializing…',
      name: 'feedback_initializing',
      desc: '',
      args: [],
    );
  }

  /// `Changes will take effect when you return to the home page`
  String get feedback_refresh_notification_after_back {
    return Intl.message(
      'Changes will take effect when you return to the home page',
      name: 'feedback_refresh_notification_after_back',
      desc: '',
      args: [],
    );
  }

  /// `Refresh now`
  String get feedback_refresh_notification_now {
    return Intl.message(
      'Refresh now',
      name: 'feedback_refresh_notification_now',
      desc: '',
      args: [],
    );
  }

  /// `Changes will take effect when data is refreshed`
  String get feedback_refresh_ui_after_refresh {
    return Intl.message(
      'Changes will take effect when data is refreshed',
      name: 'feedback_refresh_ui_after_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Changes will take effect after restart`
  String get feedback_restart {
    return Intl.message(
      'Changes will take effect after restart',
      name: 'feedback_restart',
      desc: '',
      args: [],
    );
  }

  /// `Please re-add locations`
  String get feedback_readd_location {
    return Intl.message(
      'Please re-add locations',
      name: 'feedback_readd_location',
      desc: '',
      args: [],
    );
  }

  /// `Please re-add locations after changing data source`
  String get feedback_readd_location_after_changing_source {
    return Intl.message(
      'Please re-add locations after changing data source',
      name: 'feedback_readd_location_after_changing_source',
      desc: '',
      args: [],
    );
  }

  /// `Running in background to keep updating`
  String get feedback_running_in_background {
    return Intl.message(
      'Running in background to keep updating',
      name: 'feedback_running_in_background',
      desc: '',
      args: [],
    );
  }

  /// `Updating weather data`
  String get feedback_updating_weather_data {
    return Intl.message(
      'Updating weather data',
      name: 'feedback_updating_weather_data',
      desc: '',
      args: [],
    );
  }

  /// `Updated in background`
  String get feedback_updated_in_background {
    return Intl.message(
      'Updated in background',
      name: 'feedback_updated_in_background',
      desc: '',
      args: [],
    );
  }

  /// `In some devices, after turning off 'Background free', there might be a notification that cannot be cleared in the notification bar.`
  String get feedback_interpret_background_notification_content {
    return Intl.message(
      'In some devices, after turning off \'Background free\', there might be a notification that cannot be cleared in the notification bar.',
      name: 'feedback_interpret_background_notification_content',
      desc: '',
      args: [],
    );
  }

  /// `Block notification group`
  String get feedback_interpret_notification_group_title {
    return Intl.message(
      'Block notification group',
      name: 'feedback_interpret_notification_group_title',
      desc: '',
      args: [],
    );
  }

  /// `After turning off "Free background", a notification indicating that background service is running will appear in the notification bar. You can turn off the Background Information Channel in the app's information page to block this notifications.`
  String get feedback_interpret_notification_group_content {
    return Intl.message(
      'After turning off "Free background", a notification indicating that background service is running will appear in the notification bar. You can turn off the Background Information Channel in the app\'s information page to block this notifications.',
      name: 'feedback_interpret_notification_group_content',
      desc: '',
      args: [],
    );
  }

  /// `Ignore battery optimization`
  String get feedback_ignore_battery_optimizations_title {
    return Intl.message(
      'Ignore battery optimization',
      name: 'feedback_ignore_battery_optimizations_title',
      desc: '',
      args: [],
    );
  }

  /// `In order to ensure that the background services can continue to work, please ignore the battery optimization for GeometricWeather.`
  String get feedback_ignore_battery_optimizations_content {
    return Intl.message(
      'In order to ensure that the background services can continue to work, please ignore the battery optimization for GeometricWeather.',
      name: 'feedback_ignore_battery_optimizations_content',
      desc: '',
      args: [],
    );
  }

  /// `Unable to start live wallpaper preview context`
  String get feedback_cannot_start_live_wallpaper_activity {
    return Intl.message(
      'Unable to start live wallpaper preview context',
      name: 'feedback_cannot_start_live_wallpaper_activity',
      desc: '',
      args: [],
    );
  }

  /// `This device does not contain a valid geocoder. The location provider has been changed to Baidu Location.`
  String get feedback_unusable_geocoder {
    return Intl.message(
      'This device does not contain a valid geocoder. The location provider has been changed to Baidu Location.',
      name: 'feedback_unusable_geocoder',
      desc: '',
      args: [],
    );
  }

  /// `Geocoder is a component that converts the location result from lat-lon format to a format like 'XX city, YY province'. In the absence of this component, you can only get weather data through AccuWeather when using the native API as location provider.`
  String get feedback_about_geocoder {
    return Intl.message(
      'Geocoder is a component that converts the location result from lat-lon format to a format like \'XX city, YY province\'. In the absence of this component, you can only get weather data through AccuWeather when using the native API as location provider.',
      name: 'feedback_about_geocoder',
      desc: '',
      args: [],
    );
  }

  /// `There may be precipitation today.`
  String get feedback_today_precipitation_alert {
    return Intl.message(
      'There may be precipitation today.',
      name: 'feedback_today_precipitation_alert',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation may occur in the next few hours.`
  String get feedback_short_term_precipitation_alert {
    return Intl.message(
      'Precipitation may occur in the next few hours.',
      name: 'feedback_short_term_precipitation_alert',
      desc: '',
      args: [],
    );
  }

  /// `Set as a resident city`
  String get feedback_resident_location {
    return Intl.message(
      'Set as a resident city',
      name: 'feedback_resident_location',
      desc: '',
      args: [],
    );
  }

  /// `GeometricWeather will automatically show and hide resident cities based on your current location.\nFor example, you can set your hometown as a resident city. You can check the weather in your hometown while you are traveling. When you get home, the weather in your hometown will be hidden and replaced by the weather for your current location.`
  String get feedback_resident_location_description {
    return Intl.message(
      'GeometricWeather will automatically show and hide resident cities based on your current location.\nFor example, you can set your hometown as a resident city. You can check the weather in your hometown while you are traveling. When you get home, the weather in your hometown will be hidden and replaced by the weather for your current location.',
      name: 'feedback_resident_location_description',
      desc: '',
      args: [],
    );
  }

  /// `Click to get more…`
  String get feedback_click_to_get_more {
    return Intl.message(
      'Click to get more…',
      name: 'feedback_click_to_get_more',
      desc: '',
      args: [],
    );
  }

  /// `Click again to exit`
  String get feedback_click_again_to_exit {
    return Intl.message(
      'Click again to exit',
      name: 'feedback_click_again_to_exit',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get content_desc_back {
    return Intl.message(
      'Back',
      name: 'content_desc_back',
      desc: '',
      args: [],
    );
  }

  /// `Check details`
  String get content_desc_check_details {
    return Intl.message(
      'Check details',
      name: 'content_desc_check_details',
      desc: '',
      args: [],
    );
  }

  /// `$ weather alerts`
  String get content_desc_weather_alert_button {
    return Intl.message(
      '\$ weather alerts',
      name: 'content_desc_weather_alert_button',
      desc: '',
      args: [],
    );
  }

  /// `PM two point five`
  String get content_des_pm25 {
    return Intl.message(
      'PM two point five',
      name: 'content_des_pm25',
      desc: '',
      args: [],
    );
  }

  /// `PM ten`
  String get content_des_pm10 {
    return Intl.message(
      'PM ten',
      name: 'content_des_pm10',
      desc: '',
      args: [],
    );
  }

  /// `Sulfur dioxide`
  String get content_des_so2 {
    return Intl.message(
      'Sulfur dioxide',
      name: 'content_des_so2',
      desc: '',
      args: [],
    );
  }

  /// `Nitrogen dioxide`
  String get content_des_no2 {
    return Intl.message(
      'Nitrogen dioxide',
      name: 'content_des_no2',
      desc: '',
      args: [],
    );
  }

  /// `Ozone`
  String get content_des_o3 {
    return Intl.message(
      'Ozone',
      name: 'content_des_o3',
      desc: '',
      args: [],
    );
  }

  /// `Carbon monoxide`
  String get content_des_co {
    return Intl.message(
      'Carbon monoxide',
      name: 'content_des_co',
      desc: '',
      args: [],
    );
  }

  /// `Carbon monoxide`
  String get content_des_m3 {
    return Intl.message(
      'Carbon monoxide',
      name: 'content_des_m3',
      desc: '',
      args: [],
    );
  }

  /// `Sunrise at $`
  String get content_des_sunrise {
    return Intl.message(
      'Sunrise at \$',
      name: 'content_des_sunrise',
      desc: '',
      args: [],
    );
  }

  /// `Sunset at $`
  String get content_des_sunset {
    return Intl.message(
      'Sunset at \$',
      name: 'content_des_sunset',
      desc: '',
      args: [],
    );
  }

  /// `Moonrise at $`
  String get content_des_moonrise {
    return Intl.message(
      'Moonrise at \$',
      name: 'content_des_moonrise',
      desc: '',
      args: [],
    );
  }

  /// `Moonset at $`
  String get content_des_moonset {
    return Intl.message(
      'Moonset at \$',
      name: 'content_des_moonset',
      desc: '',
      args: [],
    );
  }

  /// `No precipitation`
  String get content_des_no_precipitation {
    return Intl.message(
      'No precipitation',
      name: 'content_des_no_precipitation',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation between $1 and $2`
  String get content_des_minutely_precipitation {
    return Intl.message(
      'Precipitation between \$1 and \$2',
      name: 'content_des_minutely_precipitation',
      desc: '',
      args: [],
    );
  }

  /// `Add current location`
  String get content_des_add_current_location {
    return Intl.message(
      'Add current location',
      name: 'content_des_add_current_location',
      desc: '',
      args: [],
    );
  }

  /// `Tap to drag the list items to sort`
  String get content_des_drag_flag {
    return Intl.message(
      'Tap to drag the list items to sort',
      name: 'content_des_drag_flag',
      desc: '',
      args: [],
    );
  }

  /// `Delete this item`
  String get content_des_delete_flag {
    return Intl.message(
      'Delete this item',
      name: 'content_des_delete_flag',
      desc: '',
      args: [],
    );
  }

  /// `You can swipe left to delete this item`
  String get content_des_swipe_left_to_delete {
    return Intl.message(
      'You can swipe left to delete this item',
      name: 'content_des_swipe_left_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `You can swipe right to delete this item`
  String get content_des_swipe_right_to_delete {
    return Intl.message(
      'You can swipe right to delete this item',
      name: 'content_des_swipe_right_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `Only show locations from default weather source`
  String get content_desc_search_filter_on {
    return Intl.message(
      'Only show locations from default weather source',
      name: 'content_desc_search_filter_on',
      desc: '',
      args: [],
    );
  }

  /// `Show locations from all weather sources`
  String get content_desc_search_filter_off {
    return Intl.message(
      'Show locations from all weather sources',
      name: 'content_desc_search_filter_off',
      desc: '',
      args: [],
    );
  }

  /// `Powered by $`
  String get content_desc_powered_by {
    return Intl.message(
      'Powered by \$',
      name: 'content_desc_powered_by',
      desc: '',
      args: [],
    );
  }

  /// `@string/action_appStore`
  String get content_desc_app_store {
    return Intl.message(
      '@string/action_appStore',
      name: 'content_desc_app_store',
      desc: '',
      args: [],
    );
  }

  /// `Payment QR code of wechat`
  String get content_desc_wechat_payment_code {
    return Intl.message(
      'Payment QR code of wechat',
      name: 'content_desc_wechat_payment_code',
      desc: '',
      args: [],
    );
  }

  /// `Weather icon`
  String get content_desc_weather_icon {
    return Intl.message(
      'Weather icon',
      name: 'content_desc_weather_icon',
      desc: '',
      args: [],
    );
  }

  /// `Light icon`
  String get content_desc_weather_icon_light {
    return Intl.message(
      'Light icon',
      name: 'content_desc_weather_icon_light',
      desc: '',
      args: [],
    );
  }

  /// `Grey icon`
  String get content_desc_weather_icon_grey {
    return Intl.message(
      'Grey icon',
      name: 'content_desc_weather_icon_grey',
      desc: '',
      args: [],
    );
  }

  /// `Dark icon`
  String get content_desc_weather_icon_dark {
    return Intl.message(
      'Dark icon',
      name: 'content_desc_weather_icon_dark',
      desc: '',
      args: [],
    );
  }

  /// `Filter weather sources`
  String get content_desc_filter_weather_sources {
    return Intl.message(
      'Filter weather sources',
      name: 'content_desc_filter_weather_sources',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get action_alert {
    return Intl.message(
      'Alert',
      name: 'action_alert',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get action_manage {
    return Intl.message(
      'Manage',
      name: 'action_manage',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get action_search {
    return Intl.message(
      'Search',
      name: 'action_search',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get action_settings {
    return Intl.message(
      'Settings',
      name: 'action_settings',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get action_preview {
    return Intl.message(
      'Preview',
      name: 'action_preview',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get action_about {
    return Intl.message(
      'About',
      name: 'action_about',
      desc: '',
      args: [],
    );
  }

  /// `App Store`
  String get action_appStore {
    return Intl.message(
      'App Store',
      name: 'action_appStore',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get widget_day {
    return Intl.message(
      'Daily',
      name: 'widget_day',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get widget_week {
    return Intl.message(
      'Weekly',
      name: 'widget_week',
      desc: '',
      args: [],
    );
  }

  /// `Daily + Weekly`
  String get widget_day_week {
    return Intl.message(
      'Daily + Weekly',
      name: 'widget_day_week',
      desc: '',
      args: [],
    );
  }

  /// `Clock + Daily (Horizontal style)`
  String get widget_clock_day_horizontal {
    return Intl.message(
      'Clock + Daily (Horizontal style)',
      name: 'widget_clock_day_horizontal',
      desc: '',
      args: [],
    );
  }

  /// `Clock + Daily (Details)`
  String get widget_clock_day_details {
    return Intl.message(
      'Clock + Daily (Details)',
      name: 'widget_clock_day_details',
      desc: '',
      args: [],
    );
  }

  /// `Clock + Daily (Vertical style)`
  String get widget_clock_day_vertical {
    return Intl.message(
      'Clock + Daily (Vertical style)',
      name: 'widget_clock_day_vertical',
      desc: '',
      args: [],
    );
  }

  /// `Clock + Daily + Weekly`
  String get widget_clock_day_week {
    return Intl.message(
      'Clock + Daily + Weekly',
      name: 'widget_clock_day_week',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get widget_text {
    return Intl.message(
      'Text',
      name: 'widget_text',
      desc: '',
      args: [],
    );
  }

  /// `Daily Trend`
  String get widget_trend_daily {
    return Intl.message(
      'Daily Trend',
      name: 'widget_trend_daily',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Trend`
  String get widget_trend_hourly {
    return Intl.message(
      'Hourly Trend',
      name: 'widget_trend_hourly',
      desc: '',
      args: [],
    );
  }

  /// `Multi City`
  String get widget_multi_city {
    return Intl.message(
      'Multi City',
      name: 'widget_multi_city',
      desc: '',
      args: [],
    );
  }

  /// `waiting`
  String get wait_refresh {
    return Intl.message(
      'waiting',
      name: 'wait_refresh',
      desc: '',
      args: [],
    );
  }

  /// `…`
  String get ellipsis {
    return Intl.message(
      '…',
      name: 'ellipsis',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get settings_category_basic {
    return Intl.message(
      'Basic',
      name: 'settings_category_basic',
      desc: '',
      args: [],
    );
  }

  /// `Background Free`
  String get settings_title_background_free {
    return Intl.message(
      'Background Free',
      name: 'settings_title_background_free',
      desc: '',
      args: [],
    );
  }

  /// `Enabled\nIf widgets and notification cannot refresh automatically, please turn off this option.`
  String get settings_summary_background_free_on {
    return Intl.message(
      'Enabled\nIf widgets and notification cannot refresh automatically, please turn off this option.',
      name: 'settings_summary_background_free_on',
      desc: '',
      args: [],
    );
  }

  /// `Disabled\nIf you do not want any services to continue working in background, please turn on this option.`
  String get settings_summary_background_free_off {
    return Intl.message(
      'Disabled\nIf you do not want any services to continue working in background, please turn on this option.',
      name: 'settings_summary_background_free_off',
      desc: '',
      args: [],
    );
  }

  /// `Live wallpaper`
  String get settings_title_live_wallpaper {
    return Intl.message(
      'Live wallpaper',
      name: 'settings_title_live_wallpaper',
      desc: '',
      args: [],
    );
  }

  /// `Set Material weather animation as live wallpaper`
  String get settings_summary_live_wallpaper {
    return Intl.message(
      'Set Material weather animation as live wallpaper',
      name: 'settings_summary_live_wallpaper',
      desc: '',
      args: [],
    );
  }

  /// `Service provider`
  String get settings_title_service_provider {
    return Intl.message(
      'Service provider',
      name: 'settings_title_service_provider',
      desc: '',
      args: [],
    );
  }

  /// `Select service provider of weather data and location information`
  String get settings_summary_service_provider {
    return Intl.message(
      'Select service provider of weather data and location information',
      name: 'settings_summary_service_provider',
      desc: '',
      args: [],
    );
  }

  /// `Weather source`
  String get settings_title_weather_source {
    return Intl.message(
      'Weather source',
      name: 'settings_title_weather_source',
      desc: '',
      args: [],
    );
  }

  /// `Location service`
  String get settings_title_location_service {
    return Intl.message(
      'Location service',
      name: 'settings_title_location_service',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get settings_title_dark_mode {
    return Intl.message(
      'Dark mode',
      name: 'settings_title_dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Interface style`
  String get settings_title_ui_style {
    return Intl.message(
      'Interface style',
      name: 'settings_title_ui_style',
      desc: '',
      args: [],
    );
  }

  /// `Icon pack`
  String get settings_title_icon_provider {
    return Intl.message(
      'Icon pack',
      name: 'settings_title_icon_provider',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get settings_title_appearance {
    return Intl.message(
      'Appearance',
      name: 'settings_title_appearance',
      desc: '',
      args: [],
    );
  }

  /// `Interface style, card order, language…`
  String get settings_summary_appearance {
    return Intl.message(
      'Interface style, card order, language…',
      name: 'settings_summary_appearance',
      desc: '',
      args: [],
    );
  }

  /// `Displayed cards`
  String get settings_title_card_display {
    return Intl.message(
      'Displayed cards',
      name: 'settings_title_card_display',
      desc: '',
      args: [],
    );
  }

  /// `Display daily trend`
  String get settings_title_daily_trend_display {
    return Intl.message(
      'Display daily trend',
      name: 'settings_title_daily_trend_display',
      desc: '',
      args: [],
    );
  }

  /// `Horizontal lines in trend`
  String get settings_title_trend_horizontal_line_switch {
    return Intl.message(
      'Horizontal lines in trend',
      name: 'settings_title_trend_horizontal_line_switch',
      desc: '',
      args: [],
    );
  }

  /// `Exchange day night temperature`
  String get settings_title_exchange_day_night_temp_switch {
    return Intl.message(
      'Exchange day night temperature',
      name: 'settings_title_exchange_day_night_temp_switch',
      desc: '',
      args: [],
    );
  }

  /// `Card order`
  String get settings_title_card_order {
    return Intl.message(
      'Card order',
      name: 'settings_title_card_order',
      desc: '',
      args: [],
    );
  }

  /// `Gravity sensor`
  String get settings_title_gravity_sensor_switch {
    return Intl.message(
      'Gravity sensor',
      name: 'settings_title_gravity_sensor_switch',
      desc: '',
      args: [],
    );
  }

  /// `List animation`
  String get settings_title_list_animation_switch {
    return Intl.message(
      'List animation',
      name: 'settings_title_list_animation_switch',
      desc: '',
      args: [],
    );
  }

  /// `Item animation`
  String get settings_title_item_animation_switch {
    return Intl.message(
      'Item animation',
      name: 'settings_title_item_animation_switch',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settings_language {
    return Intl.message(
      'Language',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get settings_title_unit {
    return Intl.message(
      'Units',
      name: 'settings_title_unit',
      desc: '',
      args: [],
    );
  }

  /// `Set the unit of weather data`
  String get settings_summary_unit {
    return Intl.message(
      'Set the unit of weather data',
      name: 'settings_summary_unit',
      desc: '',
      args: [],
    );
  }

  /// `Temperature unit`
  String get settings_title_temperature_unit {
    return Intl.message(
      'Temperature unit',
      name: 'settings_title_temperature_unit',
      desc: '',
      args: [],
    );
  }

  /// `Distance unit`
  String get settings_title_distance_unit {
    return Intl.message(
      'Distance unit',
      name: 'settings_title_distance_unit',
      desc: '',
      args: [],
    );
  }

  /// `Precipitation unit`
  String get settings_title_precipitation_unit {
    return Intl.message(
      'Precipitation unit',
      name: 'settings_title_precipitation_unit',
      desc: '',
      args: [],
    );
  }

  /// `Pressure unit`
  String get settings_title_pressure_unit {
    return Intl.message(
      'Pressure unit',
      name: 'settings_title_pressure_unit',
      desc: '',
      args: [],
    );
  }

  /// `Speed unit`
  String get settings_title_speed_unit {
    return Intl.message(
      'Speed unit',
      name: 'settings_title_speed_unit',
      desc: '',
      args: [],
    );
  }

  /// `Automatic refresh rate`
  String get settings_title_refresh_rate {
    return Intl.message(
      'Automatic refresh rate',
      name: 'settings_title_refresh_rate',
      desc: '',
      args: [],
    );
  }

  /// `Send Alert Notification`
  String get settings_title_alert_notification_switch {
    return Intl.message(
      'Send Alert Notification',
      name: 'settings_title_alert_notification_switch',
      desc: '',
      args: [],
    );
  }

  /// `Send Precipitation Forecast`
  String get settings_title_precipitation_notification_switch {
    return Intl.message(
      'Send Precipitation Forecast',
      name: 'settings_title_precipitation_notification_switch',
      desc: '',
      args: [],
    );
  }

  /// `Permanent service`
  String get settings_title_permanent_service {
    return Intl.message(
      'Permanent service',
      name: 'settings_title_permanent_service',
      desc: '',
      args: [],
    );
  }

  /// `Forecast`
  String get settings_category_forecast {
    return Intl.message(
      'Forecast',
      name: 'settings_category_forecast',
      desc: '',
      args: [],
    );
  }

  /// `Forecast for today`
  String get settings_title_forecast_today {
    return Intl.message(
      'Forecast for today',
      name: 'settings_title_forecast_today',
      desc: '',
      args: [],
    );
  }

  /// `Forecast time for today`
  String get settings_title_forecast_today_time {
    return Intl.message(
      'Forecast time for today',
      name: 'settings_title_forecast_today_time',
      desc: '',
      args: [],
    );
  }

  /// `Forecast for tomorrow`
  String get settings_title_forecast_tomorrow {
    return Intl.message(
      'Forecast for tomorrow',
      name: 'settings_title_forecast_tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Forecast time for tomorrow`
  String get settings_title_forecast_tomorrow_time {
    return Intl.message(
      'Forecast time for tomorrow',
      name: 'settings_title_forecast_tomorrow_time',
      desc: '',
      args: [],
    );
  }

  /// `Widget`
  String get settings_category_widget {
    return Intl.message(
      'Widget',
      name: 'settings_category_widget',
      desc: '',
      args: [],
    );
  }

  /// `Weekly icons mode`
  String get settings_title_week_icon_mode {
    return Intl.message(
      'Weekly icons mode',
      name: 'settings_title_week_icon_mode',
      desc: '',
      args: [],
    );
  }

  /// `Minimalistic icons`
  String get settings_title_minimal_icon {
    return Intl.message(
      'Minimalistic icons',
      name: 'settings_title_minimal_icon',
      desc: '',
      args: [],
    );
  }

  /// `Refresh widget when clicked`
  String get settings_title_click_widget_to_refresh {
    return Intl.message(
      'Refresh widget when clicked',
      name: 'settings_title_click_widget_to_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Widget config`
  String get settings_title_widget_config {
    return Intl.message(
      'Widget config',
      name: 'settings_title_widget_config',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get settings_category_notification {
    return Intl.message(
      'Notification',
      name: 'settings_category_notification',
      desc: '',
      args: [],
    );
  }

  /// `Send Notification`
  String get settings_title_notification {
    return Intl.message(
      'Send Notification',
      name: 'settings_title_notification',
      desc: '',
      args: [],
    );
  }

  /// `Notification style`
  String get settings_title_notification_style {
    return Intl.message(
      'Notification style',
      name: 'settings_title_notification_style',
      desc: '',
      args: [],
    );
  }

  /// `Temperature as status bar icon`
  String get settings_title_notification_temp_icon {
    return Intl.message(
      'Temperature as status bar icon',
      name: 'settings_title_notification_temp_icon',
      desc: '',
      args: [],
    );
  }

  /// `Notification color`
  String get settings_title_notification_color {
    return Intl.message(
      'Notification color',
      name: 'settings_title_notification_color',
      desc: '',
      args: [],
    );
  }

  /// `Custom Notification Color`
  String get settings_title_notification_custom_color {
    return Intl.message(
      'Custom Notification Color',
      name: 'settings_title_notification_custom_color',
      desc: '',
      args: [],
    );
  }

  /// `Text color`
  String get settings_title_notification_text_color {
    return Intl.message(
      'Text color',
      name: 'settings_title_notification_text_color',
      desc: '',
      args: [],
    );
  }

  /// `Background color`
  String get settings_title_notification_background {
    return Intl.message(
      'Background color',
      name: 'settings_title_notification_background',
      desc: '',
      args: [],
    );
  }

  /// `Follow System`
  String get settings_notification_background_off {
    return Intl.message(
      'Follow System',
      name: 'settings_notification_background_off',
      desc: '',
      args: [],
    );
  }

  /// `Can be cleared`
  String get settings_title_notification_can_be_cleared {
    return Intl.message(
      'Can be cleared',
      name: 'settings_title_notification_can_be_cleared',
      desc: '',
      args: [],
    );
  }

  /// `Can be cleared by dragging`
  String get settings_notification_can_be_cleared_on {
    return Intl.message(
      'Can be cleared by dragging',
      name: 'settings_notification_can_be_cleared_on',
      desc: '',
      args: [],
    );
  }

  /// `Cannot be cleared`
  String get settings_notification_can_be_cleared_off {
    return Intl.message(
      'Cannot be cleared',
      name: 'settings_notification_can_be_cleared_off',
      desc: '',
      args: [],
    );
  }

  /// `Hide notification icon`
  String get settings_title_notification_hide_icon {
    return Intl.message(
      'Hide notification icon',
      name: 'settings_title_notification_hide_icon',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get settings_notification_hide_icon_on {
    return Intl.message(
      'Hide',
      name: 'settings_notification_hide_icon_on',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get settings_notification_hide_icon_off {
    return Intl.message(
      'Show',
      name: 'settings_notification_hide_icon_off',
      desc: '',
      args: [],
    );
  }

  /// `Hide in lock screen`
  String get settings_title_notification_hide_in_lockScreen {
    return Intl.message(
      'Hide in lock screen',
      name: 'settings_title_notification_hide_in_lockScreen',
      desc: '',
      args: [],
    );
  }

  /// `Hide (need to open in the system settings)`
  String get settings_notification_hide_in_lockScreen_on {
    return Intl.message(
      'Hide (need to open in the system settings)',
      name: 'settings_notification_hide_in_lockScreen_on',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get settings_notification_hide_in_lockScreen_off {
    return Intl.message(
      'Show',
      name: 'settings_notification_hide_in_lockScreen_off',
      desc: '',
      args: [],
    );
  }

  /// `Extended style`
  String get settings_title_notification_hide_big_view {
    return Intl.message(
      'Extended style',
      name: 'settings_title_notification_hide_big_view',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get settings_notification_hide_big_view_on {
    return Intl.message(
      'Hide',
      name: 'settings_notification_hide_big_view_on',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get settings_notification_hide_big_view_off {
    return Intl.message(
      'Show',
      name: 'settings_notification_hide_big_view_off',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}