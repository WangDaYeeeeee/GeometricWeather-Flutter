// @dart=2.12

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:geometricweather_flutter/app/db/daos.dart';
import 'package:geometricweather_flutter/app/db/entities.dart';

part 'database.g.dart';

const DB_NAME = 'geometricweather.db';
const DB_VERSION = 5;

@Database(
  version: DB_VERSION,
  entities: [
    LocationEntity,
    WeatherEntity,
    TodayForecastRecord,
    TomorrowForecastRecord,
  ]
)
abstract class GeoDatabase extends FloorDatabase {

  LocationDao get locationDao;
  WeatherDao get weatherDao;
  TodayForecastRecordDao get todayForecastRecordDao;
  TomorrowForecastRecordDao get tomorrowForecastRecordDao;
}

final migration3to5 = Migration(3, 5, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `TodayForecastRecord` '
          '(`dateTimeMillis` INTEGER NOT NULL, PRIMARY KEY (`dateTimeMillis`))'
  );
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `TomorrowForecastRecord` '
          '(`dateTimeMillis` INTEGER NOT NULL, PRIMARY KEY (`dateTimeMillis`))'
  );
});