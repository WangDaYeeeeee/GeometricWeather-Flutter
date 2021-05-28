import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/db/converters.dart';
import 'package:geometricweather_flutter/app/db/database.dart';
import 'package:geometricweather_flutter/app/db/entities.dart';

class DatabaseHelper {

  static DatabaseHelper _instance;
  
  factory DatabaseHelper.getInstance() => _getInstance();
  static _getInstance() {
    if (_instance == null) {
      _instance = DatabaseHelper._();
    }
    return _instance;
  }

  DatabaseHelper._();

  GeoDatabase _database;

  Future<GeoDatabase> _ensureDatabase() async {
    if (_database == null) {
      _database = await $FloorGeoDatabase.databaseBuilder(DB_NAME).build();
    }
    return _database;
  }

  Future<void> writeLocation(Location location) async {
    LocationEntity entity = locationToEntity(location);

    final database = await _ensureDatabase();

    if (await database.locationDao.selectLocationEntity(entity.formattedId) == null) {
      await database.locationDao.insertLocationEntity(entity);
    } else {
      await database.locationDao.updateLocationEntity(entity);
    }
  }

  Future<void> writeLocationList(List<Location> list) async {
    var entityList = <LocationEntity>[];
    for (Location l in list) {
      entityList.add(locationToEntity(l));
    }

    final database = await _ensureDatabase();
    await database.locationDao.insertLocationEntityList(entityList);
  }

  Future<void> deleteLocation(Location location) async {
    final database = await _ensureDatabase();
    await database.locationDao.deleteLocationEntity(locationToEntity(location));
  }

  Future<Location> readLocation(String formattedId) async {
    final database = await _ensureDatabase();
    final entity = await database.locationDao.selectLocationEntity(formattedId);
    if (entity == null) {
      return null;
    }
    return entityToLocation(entity);
  }

  Future<List<Location>> readLocationList() async {
    final database = await _ensureDatabase();
    final entityList = await database.locationDao.selectLocationEntityList();

    if (entityList == null || entityList.length == 0) {
      final local = Location.buildLocal();
      await database.locationDao.insertLocationEntity(locationToEntity(local));
      return [local];
    }

    final locationList = <Location>[];
    for (LocationEntity e in entityList) {
      locationList.add(entityToLocation(e));
    }
    return locationList;
  }

  Future<int> countLocation() async {
    final database = await _ensureDatabase();
    return await database.locationDao.countLocationEntity();
  }

  Future<void> writeWeather(String formattedId, Weather weather) async {
    final entity = await weatherToEntity(formattedId, weather);
    final database = await _ensureDatabase();
    await database.weatherDao.insertWeatherEntity(entity);
  }

  Future<Weather> readWeather(String formattedId) async {
    final database = await _ensureDatabase();
    final entity = await database.weatherDao.selectWeatherEntity(formattedId);
    if (entity == null) {
      return null;
    }

    return entityToWeather(entity);
  }

  Future<void> deleteWeather(String formattedId) async {
    final database = await _ensureDatabase();
    final entityList = await database.weatherDao.selectWeatherEntityList(formattedId);
    await database.weatherDao.deleteWeather(entityList);
  }
}