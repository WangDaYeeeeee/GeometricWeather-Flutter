// @dart=2.12

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:geometricweather_flutter/app/db/daos.dart';
import 'package:geometricweather_flutter/app/db/entities.dart';

part 'database.g.dart';

const DB_NAME = 'geometricweather.db';

@Database(version: 1, entities: [
  LocationEntity,
  WeatherEntity
])
abstract class GeoDatabase extends FloorDatabase {

  LocationDao get locationDao;
  WeatherDao get weatherDao;
}