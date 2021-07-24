// @dart=2.12

import 'package:floor/floor.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/db/converters.dart';
import 'package:geometricweather_flutter/app/db/database.dart';
import 'package:geometricweather_flutter/app/db/entities.dart';

class DatabaseHelper {

  static DatabaseHelper? _instance;
  
  factory DatabaseHelper.getInstance() => _getInstance();
  static _getInstance() {
    if (_instance == null) {
      _instance = DatabaseHelper._();
    }
    return _instance;
  }

  DatabaseHelper._();

  GeoDatabase? _database;

  Future<GeoDatabase> _ensureDatabase() async {
    if (_database == null) {
      _database = await $FloorGeoDatabase.databaseBuilder(
        DB_NAME
      ).addMigrations([
        migration3to5,
      ]).build();
    }
    return _database!;
  }

  @transaction
  Future<void> writeLocation(Location location) async {
    LocationEntity entity = locationToEntity(location);

    final database = await _ensureDatabase();

    if (await database.locationDao.selectLocationEntity(entity.formattedId) == null) {
      await database.locationDao.insertLocationEntity(entity);
    } else {
      await database.locationDao.updateLocationEntity(entity);
    }
  }

  @transaction
  Future<void> writeLocationList(List<Location> list) async {
    final database = await _ensureDatabase();

    var entityList = await database.locationDao.selectLocationEntityList();
    await database.locationDao.deleteLocationEntityList(entityList);

    entityList = <LocationEntity>[];
    for (Location l in list) {
      entityList.add(locationToEntity(l));
    }
    await database.locationDao.insertLocationEntityList(entityList);
  }

  @transaction
  Future<void> deleteLocation(Location location) async {
    final database = await _ensureDatabase();
    await database.locationDao.deleteLocationEntity(locationToEntity(location));
  }

  @transaction
  Future<Location?> readLocation(String formattedId) async {
    final database = await _ensureDatabase();
    final entity = await database.locationDao.selectLocationEntity(formattedId);
    if (entity == null) {
      return null;
    }
    return entityToLocation(entity);
  }

  @transaction
  Future<List<Location>> readLocationList() async {
    final database = await _ensureDatabase();
    final entityList = await database.locationDao.selectLocationEntityList();

    if (entityList.isEmpty) {
      final local = await Location.buildLocal();
      writeLocationList([local]);
      return [local];
    }

    final locationList = <Location>[];
    for (LocationEntity e in entityList) {
      locationList.add(entityToLocation(e));
    }
    return locationList;
  }

  @transaction
  Future<int> countLocation() async {
    final database = await _ensureDatabase();
    return await database.locationDao.countLocationEntity() ?? 0;
  }

  @transaction
  Future<void> writeWeather(String formattedId, Weather weather) async {
    await deleteWeather(formattedId);

    final entity = await weatherToEntity(formattedId, weather);
    final database = await _ensureDatabase();
    await database.weatherDao.insertWeatherEntity(entity);
  }

  @transaction
  Future<Weather?> readWeather(String formattedId) async {
    final database = await _ensureDatabase();
    final entity = await database.weatherDao.selectWeatherEntity(formattedId);
    if (entity == null) {
      return null;
    }

    return entityToWeather(entity);
  }

  @transaction
  Future<void> deleteWeather(String formattedId) async {
    final database = await _ensureDatabase();
    final entityList = await database.weatherDao.selectWeatherEntityList(formattedId);
    await database.weatherDao.deleteWeather(entityList);
  }

  @transaction
  Future<DateTime?> readTodayForecastRecord() async {
    final database = await _ensureDatabase();
    final record = await database.todayForecastRecordDao.selectTodayForecastRecord();
    return record == null ? null : DateTime.fromMillisecondsSinceEpoch(record.dateTimeMillis);
  }

  @transaction
  Future<void> writeTodayForecastRecord(DateTime dateTime) async {
    final database = await _ensureDatabase();
    final recordList = await database.todayForecastRecordDao.selectTodayForecastRecordList();
    await database.todayForecastRecordDao.deleteTodayForecastRecord(recordList);
    await database.todayForecastRecordDao.insertTodayForecastRecord(
      TodayForecastRecord(dateTime.millisecondsSinceEpoch)
    );
  }

  @transaction
  Future<DateTime?> readTomorrowForecastRecord() async {
    final database = await _ensureDatabase();
    final record = await database.tomorrowForecastRecordDao.selectTomorrowForecastRecord();
    return record == null ? null : DateTime.fromMillisecondsSinceEpoch(record.dateTimeMillis);
  }

  @transaction
  Future<void> writeTomorrowForecastRecord(DateTime dateTime) async {
    final database = await _ensureDatabase();
    final recordList = await database.tomorrowForecastRecordDao.selectTomorrowForecastRecordList();
    await database.tomorrowForecastRecordDao.deleteTomorrowForecastRecord(recordList);
    await database.tomorrowForecastRecordDao.insertTomorrowForecastRecord(
        TomorrowForecastRecord(dateTime.millisecondsSinceEpoch)
    );
  }
}