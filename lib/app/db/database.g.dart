// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorGeoDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$GeoDatabaseBuilder databaseBuilder(String name) =>
      _$GeoDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$GeoDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$GeoDatabaseBuilder(null);
}

class _$GeoDatabaseBuilder {
  _$GeoDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$GeoDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$GeoDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<GeoDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$GeoDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$GeoDatabase extends GeoDatabase {
  _$GeoDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LocationDao? _locationDaoInstance;

  WeatherDao? _weatherDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LocationEntity` (`formattedId` TEXT NOT NULL, `cityId` TEXT NOT NULL, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `timezone` TEXT NOT NULL, `country` TEXT NOT NULL, `province` TEXT NOT NULL, `city` TEXT NOT NULL, `district` TEXT NOT NULL, `weatherCodeIndex` INTEGER NOT NULL, `weatherSourceKey` TEXT NOT NULL, `currentPosition` INTEGER NOT NULL, `residentPosition` INTEGER NOT NULL, `china` INTEGER NOT NULL, PRIMARY KEY (`formattedId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WeatherEntity` (`formattedId` TEXT NOT NULL, `json` TEXT NOT NULL, PRIMARY KEY (`formattedId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LocationDao get locationDao {
    return _locationDaoInstance ??= _$LocationDao(database, changeListener);
  }

  @override
  WeatherDao get weatherDao {
    return _weatherDaoInstance ??= _$WeatherDao(database, changeListener);
  }
}

class _$LocationDao extends LocationDao {
  _$LocationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _locationEntityInsertionAdapter = InsertionAdapter(
            database,
            'LocationEntity',
            (LocationEntity item) => <String, Object?>{
                  'formattedId': item.formattedId,
                  'cityId': item.cityId,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'timezone': item.timezone,
                  'country': item.country,
                  'province': item.province,
                  'city': item.city,
                  'district': item.district,
                  'weatherCodeIndex': item.weatherCodeIndex,
                  'weatherSourceKey': item.weatherSourceKey,
                  'currentPosition': item.currentPosition ? 1 : 0,
                  'residentPosition': item.residentPosition ? 1 : 0,
                  'china': item.china ? 1 : 0
                }),
        _locationEntityUpdateAdapter = UpdateAdapter(
            database,
            'LocationEntity',
            ['formattedId'],
            (LocationEntity item) => <String, Object?>{
                  'formattedId': item.formattedId,
                  'cityId': item.cityId,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'timezone': item.timezone,
                  'country': item.country,
                  'province': item.province,
                  'city': item.city,
                  'district': item.district,
                  'weatherCodeIndex': item.weatherCodeIndex,
                  'weatherSourceKey': item.weatherSourceKey,
                  'currentPosition': item.currentPosition ? 1 : 0,
                  'residentPosition': item.residentPosition ? 1 : 0,
                  'china': item.china ? 1 : 0
                }),
        _locationEntityDeletionAdapter = DeletionAdapter(
            database,
            'LocationEntity',
            ['formattedId'],
            (LocationEntity item) => <String, Object?>{
                  'formattedId': item.formattedId,
                  'cityId': item.cityId,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'timezone': item.timezone,
                  'country': item.country,
                  'province': item.province,
                  'city': item.city,
                  'district': item.district,
                  'weatherCodeIndex': item.weatherCodeIndex,
                  'weatherSourceKey': item.weatherSourceKey,
                  'currentPosition': item.currentPosition ? 1 : 0,
                  'residentPosition': item.residentPosition ? 1 : 0,
                  'china': item.china ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LocationEntity> _locationEntityInsertionAdapter;

  final UpdateAdapter<LocationEntity> _locationEntityUpdateAdapter;

  final DeletionAdapter<LocationEntity> _locationEntityDeletionAdapter;

  @override
  Future<LocationEntity?> selectLocationEntity(String formattedId) async {
    return _queryAdapter.query(
        'SELECT * FROM LocationEntity WHERE formattedId = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => LocationEntity(
            row['formattedId'] as String,
            row['cityId'] as String,
            row['latitude'] as double,
            row['longitude'] as double,
            row['timezone'] as String,
            row['country'] as String,
            row['province'] as String,
            row['city'] as String,
            row['district'] as String,
            row['weatherCodeIndex'] as int,
            row['weatherSourceKey'] as String,
            (row['currentPosition'] as int) != 0,
            (row['residentPosition'] as int) != 0,
            (row['china'] as int) != 0),
        arguments: [formattedId]);
  }

  @override
  Future<List<LocationEntity>> selectLocationEntityList() async {
    return _queryAdapter.queryList('SELECT * FROM LocationEntity',
        mapper: (Map<String, Object?> row) => LocationEntity(
            row['formattedId'] as String,
            row['cityId'] as String,
            row['latitude'] as double,
            row['longitude'] as double,
            row['timezone'] as String,
            row['country'] as String,
            row['province'] as String,
            row['city'] as String,
            row['district'] as String,
            row['weatherCodeIndex'] as int,
            row['weatherSourceKey'] as String,
            (row['currentPosition'] as int) != 0,
            (row['residentPosition'] as int) != 0,
            (row['china'] as int) != 0));
  }

  @override
  Future<int?> countLocationEntity() async {
    await _queryAdapter.queryNoReturn('SELECT COUNT(*) FROM LocationEntity');
  }

  @override
  Future<void> insertLocationEntity(LocationEntity entity) async {
    await _locationEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertLocationEntityList(List<LocationEntity> entityList) async {
    await _locationEntityInsertionAdapter.insertList(
        entityList, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateLocationEntity(LocationEntity entity) async {
    await _locationEntityUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteLocationEntity(LocationEntity entity) async {
    await _locationEntityDeletionAdapter.delete(entity);
  }

  @override
  Future<void> deleteLocationEntityList(List<LocationEntity> entityList) async {
    await _locationEntityDeletionAdapter.deleteList(entityList);
  }
}

class _$WeatherDao extends WeatherDao {
  _$WeatherDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _weatherEntityInsertionAdapter = InsertionAdapter(
            database,
            'WeatherEntity',
            (WeatherEntity item) => <String, Object?>{
                  'formattedId': item.formattedId,
                  'json': item.json
                }),
        _weatherEntityDeletionAdapter = DeletionAdapter(
            database,
            'WeatherEntity',
            ['formattedId'],
            (WeatherEntity item) => <String, Object?>{
                  'formattedId': item.formattedId,
                  'json': item.json
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WeatherEntity> _weatherEntityInsertionAdapter;

  final DeletionAdapter<WeatherEntity> _weatherEntityDeletionAdapter;

  @override
  Future<WeatherEntity?> selectWeatherEntity(String formattedId) async {
    return _queryAdapter.query(
        'SELECT * FROM WeatherEntity WHERE formattedId = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) =>
            WeatherEntity(row['formattedId'] as String, row['json'] as String),
        arguments: [formattedId]);
  }

  @override
  Future<List<WeatherEntity>> selectWeatherEntityList(
      String formattedId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WeatherEntity WHERE formattedId = ?1',
        mapper: (Map<String, Object?> row) =>
            WeatherEntity(row['formattedId'] as String, row['json'] as String),
        arguments: [formattedId]);
  }

  @override
  Future<void> insertWeatherEntity(WeatherEntity entity) async {
    await _weatherEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWeather(List<WeatherEntity> entityList) async {
    await _weatherEntityDeletionAdapter.deleteList(entityList);
  }
}
