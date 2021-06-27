// @dart=2.12

import 'dart:async';
import 'dart:core';

import 'package:flutter/src/widgets/framework.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/db/helper.dart';
import 'package:geometricweather_flutter/app/settings/interfaces.dart';
import 'package:geometricweather_flutter/app/theme/manager.dart';
import 'package:geometricweather_flutter/app/updater/models.dart';

import '../updater/helper.dart';
import 'models.dart';

class _MainRepository {

  static Future<List<Location>> getLocationList(List<Location> oldList) async {
    final list = await DatabaseHelper.getInstance().readLocationList();

    for (var oldOne in oldList) {
      for (int i = 0; i < list.length; i ++) {
        if (list[i] == oldOne) {
          list[i] = list[i].copyOf(weather: oldOne.weather);
          break;
        }
      }
    }

    return list;
  }

  Future<List<Location>> getWeatherCaches(List<Location> list) async {

    List<Future<Weather?>> futureList = [];
    for (var l in list) {
      futureList.add(DatabaseHelper.getInstance().readWeather(l.formattedId));
    }

    List<Weather?> weatherList = await Future.wait(futureList);
    for (int i = 0; i < list.length; i ++) {
      list[i] = list[i].copyOf(weather: weatherList[i]);
    }

    return list;
  }

  Future<void> writeLocation(Location location) => Future.wait([
    // location.
    DatabaseHelper.getInstance().writeLocation(location),
    // weather if necessary.
    Future(() async {
      if (location.weather != null) {
        await DatabaseHelper.getInstance().writeWeather(
            location.formattedId,
            location.weather!
        );
      }
    })
  ]);

  Future<void> writeLocationList(List<Location> locationList) =>
      DatabaseHelper.getInstance().writeLocationList(locationList);

  Future<void> writeLocationListWithIndex(
      List<Location> locationList,
      int newIndex) => Future.wait([
    // location.
    DatabaseHelper.getInstance().writeLocationList(locationList),
    // weather.
    Future(() async {
      if (locationList[newIndex].weather != null) {
        await DatabaseHelper.getInstance().writeWeather(
            locationList[newIndex].formattedId,
            locationList[newIndex].weather!
        );
      }
    })
  ]);

  Future<void> deleteLocation(Location location) => Future.wait([
    DatabaseHelper.getInstance().deleteLocation(location),
    DatabaseHelper.getInstance().deleteWeather(location.formattedId)
  ]);

  Stream<UpdateResult<Location>> update(Location location) =>
      requestWeatherUpdate(location);
}

class MainViewModel extends ViewModel {

  // live data.
  final LiveData<Location> currentLocation;
  final LiveData<MainEvent> event;
  final LiveData<Indicator> indicator;
  final LiveData<SelectableLocationListResource> listResource;

  // inner data.
  String? _formattedId; // current formatted id.
  List<Location> _totalList; // all locations.
  List<Location> _validList; // location list optimized for resident city.
  final SettingsManager _settingsManager;
  final ThemeManager _themeManager;

  // async control.
  final _MainRepository _repository = _MainRepository();
  StreamSubscription? _updateDescription;
  bool _updating = false;

  MainViewModel._(
      this._totalList,
      this._validList,
      this._settingsManager,
  ): currentLocation = LiveData(
      _validList[0]
  ), event = LiveData(
      MainEvent(
          _validList[0],
          ResourceStatus.SUCCESS,
          true,
          InitializationStage.INITIALIZING,
          LocationEvent.INITIALIZE_RUNNING
      )
  ), indicator = LiveData(
      Indicator(_validList.length, 0)
  ), listResource = LiveData(
      SelectableLocationListResource(_totalList)
  ), _themeManager = ThemeManager.getInstance(
      _settingsManager.darkMode
  );

  static Future<MainViewModel> getInstance() async {
    
    final results = await Future.wait([
      _MainRepository.getLocationList(List.empty()),
      SettingsManager.getInstance()
    ]);

    final list = results[0] as List<Location>;
    final settingsManager = results[1] as SettingsManager;

    final totalList = List<Location>.from(list);
    final validList = Location.excludeInvalidResidentLocation(totalList);

    return MainViewModel._(totalList, validList, settingsManager);
  }

  void init([String? formattedId]) {
    _setLiveDataWithVerification(
      location: currentLocation.value,
      defaultLocation: event.value.defaultLocation,
      initStage: InitializationStage.INITIALIZING,
      locationEvent: LocationEvent.INITIALIZE_RUNNING,
    );

    formattedId = formattedId ?? _formattedId;

    _repository.getWeatherCaches(_totalList).then((value) {
      final totalList = List<Location>.from(value);
      final validList = Location.excludeInvalidResidentLocation(totalList);

      final validIndex = indexLocation(validList, formattedId);
      setInnerData(totalList, validList, validIndex);

      _setLiveDataWithVerification(
          location: validList[validIndex],
          defaultLocation: validIndex == 0,
          initStage: InitializationStage.INITIALIZATION_DONE,
          locationEvent: LocationEvent.INITIALIZE_DONE,
          indicatorValue: Indicator(validList.length, validIndex),
          listEvent: DataSetChanged()
      );
    });
  }

  @override
  void dispose(BuildContext context) {
    cancelUpdate();
  }

  void checkToUpdate() {
    MainEvent ev = event.value;
    Location? location = ev.data;
    if (location == null) {
      return;
    }

    _themeManager.update(
        darkMode: _settingsManager.darkMode,
        location: location
    );

    if (_updating) {
      return;
    }

    _setLiveDataWithVerification(
      location: location,
      defaultLocation: ev.defaultLocation,
      initStage: ev.initStage,
      locationEvent: LocationEvent.SET_LOCATION,
    );
  }

  void updateLocationFromBackground(Location location) {
    List<Location> totalList = List.from(_totalList);
    for (int i = 0; i < totalList.length; i ++) {
      if (totalList[i] == location) {
        totalList[i] = location;
        break;
      }
    }

    List<Location> validList = Location.excludeInvalidResidentLocation(totalList);
    int validIndex = indexLocation(validList, _formattedId);

    setInnerData(totalList, validList, validIndex);

    Location current = validList[validIndex];
    Indicator indicatorValue = Indicator(validList.length, validIndex);
    bool defaultLocation = validIndex == 0;

    _setLiveDataWithVerification(
        location: location == current ? current : null,
        defaultLocation: defaultLocation,
        locationEvent: LocationEvent.UPDATE_FROM_BACKGROUND,
        indicatorValue: indicatorValue,
        listEvent: DataSetChanged()
    );
  }

  void setLocation(String formattedId) {
    List<Location> totalList = List.from(_totalList);
    List<Location> validList = List.from(_validList);
    int validIndex = indexLocation(validList, formattedId);

    setInnerData(totalList, validList, validIndex);

    Location current = validList[validIndex];
    Indicator indicator = new Indicator(validList.length, validIndex);
    bool defaultLocation = validIndex == 0;

    _setLiveDataWithVerification(
        location: current,
        defaultLocation: defaultLocation,
        locationEvent: LocationEvent.SET_LOCATION,
        indicatorValue: indicator,
        listEvent: DataSetChanged()
    );
  }

  void offsetLocation(int offset) {
    int validIndex = indexLocation(_validList, _formattedId);
    validIndex += offset + _validList.length;
    validIndex %= _validList.length;

    List<Location> totalList = List.from(_totalList);
    List<Location> validList = List.from(_validList);

    setInnerData(totalList, validList, validIndex);

    Location current = validList[validIndex];
    Indicator indicator = new Indicator(validList.length, validIndex);
    bool defaultLocation = validIndex == 0;

    _setLiveDataWithVerification(
        location: current,
        defaultLocation: defaultLocation,
        locationEvent: LocationEvent.SWITCH_LOCATION,
        indicatorValue: indicator,
        listEvent: DataSetChanged()
    );
  }

  void updateWeather() {
    if (event.value.initStage != InitializationStage.INITIALIZATION_DONE
        || _updating) {
      return;
    }

    _updating = true;

    Location? location = event.value.data;
    if (location == null) {
      return;
    }

    _themeManager.update(
        darkMode: _settingsManager.darkMode,
        location: location
    );

    _setLiveDataWithVerification(
      location: location,
      defaultLocation: event.value.defaultLocation,
      locationEvent: LocationEvent.UPDATE_BEGIN,
    );

    _updateDescription = _repository.update(location).listen((event) {
      List<Location> totalList = List.from(_totalList);
      for (int i = 0; i < totalList.length; i ++) {
        if (totalList[i] == event.data) {
          totalList[i] = event.data;
          break;
        }
      }

      List<Location> validList = Location.excludeInvalidResidentLocation(totalList);
      int validIndex = indexLocation(validList, getCurrentFormattedId());
      bool defaultLocation = event.data == validList[0];

      setInnerData(totalList, validList, validIndex);

      LocationEvent locationEvent = LocationEvent.INITIALIZE_RUNNING;
      switch (event.status) {
        case UpdateStatus.LOCATOR_DISABLED:
          locationEvent = LocationEvent.LOCATOR_DISABLED;
          break;

        case UpdateStatus.LOCATOR_PERMISSIONS_DENIED:
          locationEvent = LocationEvent.LOCATOR_PERMISSION_DENIED;
          break;

        case UpdateStatus.LOCATOR_FAILED:
          locationEvent = LocationEvent.LOCATOR_FAILED;
          break;

        case UpdateStatus.LOCATOR_SUCCEED:
          locationEvent = LocationEvent.UPDATE_RUNNING;
          break;

        case UpdateStatus.GET_GEO_POSITION_FAILED:
          locationEvent = LocationEvent.GET_GEO_POSITION_FAILED;
          break;

        case UpdateStatus.JSON_DECODE_FAILED:
        case UpdateStatus.GET_WEATHER_FAILED:
          locationEvent = LocationEvent.GET_WEATHER_FAILED;
          break;

        case UpdateStatus.REQUEST_SUCCEED:
          locationEvent = LocationEvent.UPDATE_SUCCEED;
          break;
      }

      _themeManager.update(
          darkMode: _settingsManager.darkMode,
          location: event.data
      );

      if (!event.running) {
        _updateDescription = null;
        _updating = false;
      }

      _setLiveDataWithVerification(
          location: event.data,
          defaultLocation: defaultLocation,
          locationEvent: locationEvent,
          forceSetCurrentRunning: event.running,
          indicatorValue: Indicator(validList.length, validIndex),
          listEvent: DataSetChanged()
      );
    });
  }

  void cancelUpdate() {
    _updateDescription?.cancel();
    _updateDescription = null;
    _updating = false;
  }

  bool get updating => _updating;

  void addLocation(Location location, [int? position]) {
    position = position ?? _totalList.length;

    List<Location> totalList = List.from(_totalList);
    totalList.insert(position, location);

    List<Location> validList = Location.excludeInvalidResidentLocation(totalList);
    int validIndex = indexLocation(validList, _formattedId);

    setInnerData(totalList, validList, validIndex);

    Indicator indicator = new Indicator(validList.length, validIndex);

    _setLiveDataWithVerification(
        indicatorValue: indicator,
        listEvent: DataSetChanged()
    );

    if (position == totalList.length - 1) {
      _repository.writeLocation(location);
    } else {
      _repository.writeLocationListWithIndex(List.unmodifiable(totalList), position);
    }
  }

  void moveLocation(int from, int to) {
    List<Location> totalList = List.from(_totalList);
    totalList.insert(to, totalList.removeAt(from));

    final validList = Location.excludeInvalidResidentLocation(totalList);
    final validIndex = indexLocation(validList, _formattedId);

    setInnerData(totalList, validList, validIndex);

    _setLiveDataWithVerification(
        indicatorValue: Indicator(validList.length, validIndex),
        listEvent: ItemMoved(from, to)
    );

    _repository.writeLocationList(totalList);
  }

  void forceUpdateLocation(Location location) {
    List<Location> totalList = List.from(_totalList);
    for (int i = 0; i < totalList.length; i ++) {
      if (totalList[i] == location) {
        totalList[i] = location;
        break;
      }
    }

    List<Location> validList = Location.excludeInvalidResidentLocation(totalList);
    int validIndex = indexLocation(validList, _formattedId);

    setInnerData(totalList, validList, validIndex);

    Location current = validList[validIndex];
    Indicator indicator = new Indicator(validList.length, validIndex);
    bool defaultLocation = validIndex == 0;

    _setLiveDataWithVerification(
        location: location == current ? current : null,
        defaultLocation: defaultLocation,
        locationEvent: LocationEvent.SET_LOCATION,
        indicatorValue: indicator,
        listEvent: DataSetChanged()
    );

    _repository.writeLocation(location);
  }

  void forceUpdateLocationWithPosition(Location location, int position) {

    List<Location> totalList = List.from(_totalList);
    totalList[position] = location;

    List<Location> validList = Location.excludeInvalidResidentLocation(totalList);
    int validIndex = indexLocation(validList, _formattedId);

    setInnerData(totalList, validList, validIndex);

    Location current = validList[validIndex];
    Indicator indicator = new Indicator(validList.length, validIndex);
    bool defaultLocation = validIndex == 0;

    _setLiveDataWithVerification(
        location: location == current ? current : null,
        defaultLocation: defaultLocation,
        locationEvent: LocationEvent.SET_LOCATION,
        indicatorValue: indicator,
        listEvent: DataSetChanged()
    );

    _repository.writeLocation(location);
  }

  Location deleteLocation(int position) {
    String currentFormattedId = event.value.data?.formattedId
        ?? Location.NULL_ID;

    List<Location> totalList = List.from(_totalList);
    Location location = totalList.removeAt(position);
    if (location.formattedId == _formattedId) {
      formattedId = totalList[0].formattedId;
    }

    List<Location> validList = Location.excludeInvalidResidentLocation(totalList);
    int validIndex = indexLocation(validList, _formattedId);

    setInnerData(totalList, validList, validIndex);

    Location current = validList[validIndex];
    Indicator indicator = new Indicator(validList.length, validIndex);
    bool defaultLocation = validIndex == 0;

    _setLiveDataWithVerification(
        location: _formattedId != currentFormattedId ? current : null,
        defaultLocation: defaultLocation,
        locationEvent: LocationEvent.SET_LOCATION,
        indicatorValue: indicator,
        listEvent: DataSetChanged()
    );

    _repository.deleteLocation(location);

    return location;
  }

  set formattedId(String? formattedId) {
    _formattedId = formattedId;
  }

  void setInnerData(
      List<Location> totalList,
      List<Location> validList,
      int validIndex) {

    _totalList = totalList;
    _validList = validList;
    _formattedId = validList[validIndex].formattedId;
  }

  void _setLiveDataWithVerification({
    Location? location,
    bool? defaultLocation,
    InitializationStage? initStage,
    LocationEvent? locationEvent,
    bool? forceSetCurrentRunning,
    Indicator? indicatorValue,
    ListEvent? listEvent
  }) {

    _themeManager.update(
        darkMode: _settingsManager.darkMode,
        location: location
    );

    if (location != null
        && defaultLocation != null
        && locationEvent != null) {
      initStage = initStage ?? event.value.initStage;
      forceSetCurrentRunning = forceSetCurrentRunning ?? false;

      if (location != currentLocation.value) {
        currentLocation.value = location;
      } else if (location.weather == null) {
        if (currentLocation.value.weather != null) {
          currentLocation.value = location;
        }
      } else if (location.weather != currentLocation.value.weather) {
        currentLocation.value = location;
      } else if (locationEvent == LocationEvent.SWITCH_LOCATION) {
        currentLocation.value = location;
      }

      switch (locationEvent) {
        case LocationEvent.INITIALIZE_RUNNING:
          event.value = MainEvent.loading(
              location, defaultLocation, initStage, locationEvent);
          break;

        case LocationEvent.INITIALIZE_DONE:
        case LocationEvent.SET_LOCATION:
        case LocationEvent.SWITCH_LOCATION:
          cancelUpdate();

          if (initStage == InitializationStage.INITIALIZATION_DONE
              && _needUpdate(location)) {
            event.value = MainEvent.loading(
                location, defaultLocation, initStage, locationEvent);
            updateWeather();
          } else {
            event.value = MainEvent.success(
                location, defaultLocation, initStage, locationEvent);
          }
          break;

        case LocationEvent.ADJUST_LIST_CHANGED:
          event.value = MainEvent(
              location,
              event.value.status,
              defaultLocation,
              initStage,
              locationEvent
          );
          break;

        case LocationEvent.UPDATE_BEGIN:
        case LocationEvent.UPDATE_RUNNING:
        event.value = MainEvent.loading(
              location, defaultLocation, initStage, locationEvent);
          break;

        case LocationEvent.UPDATE_SUCCEED:
          event.value = MainEvent.success(
              location, defaultLocation, initStage, locationEvent);
          break;

        case LocationEvent.LOCATOR_DISABLED:
        case LocationEvent.LOCATOR_PERMISSION_DENIED:
        case LocationEvent.LOCATOR_FAILED:
        case LocationEvent.GET_GEO_POSITION_FAILED:
        case LocationEvent.GET_WEATHER_FAILED:
        event.value = MainEvent(
              location,
              forceSetCurrentRunning
                  ? ResourceStatus.LOADING
                  : ResourceStatus.ERROR,
              defaultLocation,
              initStage,
              locationEvent
          );
          break;

        case LocationEvent.UPDATE_FROM_BACKGROUND:
          cancelUpdate();

          event.value = MainEvent.success(
              location, defaultLocation, initStage, locationEvent);
          break;
      }
    }

    if (indicatorValue != null) {
      indicator.value = indicatorValue;
    }
    if (listEvent != null) {
      listResource.value = SelectableLocationListResource(
          List.from(_totalList),
          location?.formattedId ?? listResource.value.selectedId,
          listEvent
      );
    }
  }

  static bool _needUpdate(Location location) => !location.usable
      || location.weather == null
      || !location.weather!.isValid(1.5);

  static int indexLocation(List<Location> locationList, String? formattedId) {
    if (isEmptyString(formattedId)) {
      return 0;
    }
    for (int i = 0; i < locationList.length; i ++) {
      if (locationList[i].formattedId == formattedId) {
        return i;
      }
    }
    return 0;
  }

  Location getLocationFromList(int offset) {
    int validIndex = indexLocation(_validList, _formattedId);
    return _validList[
      (validIndex + offset + _validList.length) % _validList.length
    ];
  }

  String getCurrentFormattedId() {
    Location? location = event.value.data;
    if (location != null) {
      return location.formattedId;
    } else if (_formattedId != null) {
      return _formattedId!;
    } else {
      return _validList[0].formattedId;
    }
  }

  List<Location> get totalLocationList {
    return List<Location>.unmodifiable(_totalList);
  }

  List<Location> get validLocationList {
    return List<Location>.unmodifiable(_validList);
  }

  SettingsManager get settingsManager => _settingsManager;

  ThemeManager get themeManager => _themeManager;
}