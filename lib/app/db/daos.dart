// @dart=2.12

import 'package:floor/floor.dart';
import 'package:geometricweather_flutter/app/db/entities.dart';

@dao
abstract class LocationDao {

  @insert
  Future<void> insertLocationEntity(LocationEntity entity);

  @insert
  Future<void> insertLocationEntityList(List<LocationEntity> entityList);

  @delete
  Future<void> deleteLocationEntity(LocationEntity entity);

  @delete
  Future<void> deleteLocationEntityList(List<LocationEntity> entityList);

  @update
  Future<void> updateLocationEntity(LocationEntity entity);

  @Query("SELECT * FROM LocationEntity WHERE formattedId = :formattedId LIMIT 1")
  Future<LocationEntity?> selectLocationEntity(String formattedId);

  @Query("SELECT * FROM LocationEntity")
  Future<List<LocationEntity>> selectLocationEntityList();

  @Query("SELECT COUNT(*) FROM LocationEntity")
  Future<int?> countLocationEntity();
}

@dao
abstract class WeatherDao {

  @insert
  Future<void> insertWeatherEntity(WeatherEntity entity);

  @delete
  Future<void> deleteWeather(List<WeatherEntity> entityList);

  @Query("SELECT * FROM WeatherEntity WHERE formattedId = :formattedId LIMIT 1")
  Future<WeatherEntity?> selectWeatherEntity(String formattedId);

  @Query("SELECT * FROM WeatherEntity WHERE formattedId = :formattedId")
  Future<List<WeatherEntity>> selectWeatherEntityList(String formattedId);
}