// @dart=2.12

import 'dart:core';

import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';

enum InitializationStage {
  INITIALIZING,

  // RELOADING_LOCATION_LIST,
  // RELOADING_WEATHER_CACHES,

  INITIALIZATION_DONE,
}

enum LocationEvent {
  INITIALIZE_RUNNING,
  INITIALIZE_DONE,

  // RELOAD_RUNNING,
  // RELOAD_DONE,

  SET_LOCATION,
  ADJUST_LIST_CHANGED,

  UPDATE_BEGIN,
  UPDATE_RUNNING,
  UPDATE_SUCCEED,

  LOCATOR_DISABLED,
  LOCATOR_PERMISSION_DENIED,
  LOCATOR_FAILED,

  GET_GEO_POSITION_FAILED,
  GET_WEATHER_FAILED,

  UPDATE_FROM_BACKGROUND,
}

class CurrentLocationResource extends Resource<Location> {

  CurrentLocationResource(
      Location? data,
      ResourceStatus status,
      this.defaultLocation,
      this.initStage,
      this.locationEvent) : super(data, status);

  final bool defaultLocation;

  final InitializationStage initStage;
  final LocationEvent locationEvent;

  static CurrentLocationResource success(
      Location data,
      bool defaultLocation,
      InitializationStage stage,
      LocationEvent event) {
    return new CurrentLocationResource(
        data, ResourceStatus.SUCCESS, defaultLocation, stage, event);
  }

  static CurrentLocationResource error(
      Location data,
      bool defaultLocation,
      InitializationStage stage,
      LocationEvent event) {
    return new CurrentLocationResource(
        data, ResourceStatus.ERROR, defaultLocation, stage, event);
  }

  static CurrentLocationResource loading(
      Location data,
      bool defaultLocation,
      InitializationStage stage,
      LocationEvent event) {
    return new CurrentLocationResource(
        data, ResourceStatus.LOADING, defaultLocation, stage, event);
  }
}

class Indicator {

  final int total;
  final int index;

  Indicator(this.total, this.index);

  @override
  bool operator ==(Object other) {
    if (other is Indicator) {
      return index == other.index && total == other.total;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => super.hashCode;
}

class SelectableLocationListResource extends ListResource<Location> {

  final String? selectedId;

  SelectableLocationListResource(List<Location> dataList, [
    this.selectedId,
    ListEvent event = const DataSetChanged()
  ]): super(dataList);
}