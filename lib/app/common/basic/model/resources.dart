import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';

// weather update.

enum UpdateStatus {
  LOCATOR_DISABLED,
  LOCATOR_PERMISSIONS_DENIED,
  LOCATOR_RUNNING,
  LOCATOR_FAILED,
  LOCATOR_SUCCEED,

  JSON_DECODE_FAILED,
  REQUEST_FAILED,
  REQUEST_SUCCEED,
}

class UpdateResult<T> {

  final T data;
  final UpdateStatus status;

  UpdateResult(this.data, this.status);
}

// event.

abstract class Event {}

class DataChanged extends Event {}

abstract class ItemEvent extends Event {

  ItemEvent(this.itemPosition);

  final int itemPosition;
}

class ItemInserted extends ItemEvent {
  ItemInserted(int itemPosition) : super(itemPosition);
}

class ItemRemoved extends ItemEvent {
  ItemRemoved(int itemPosition) : super(itemPosition);
}

class ItemChanged extends ItemEvent {
  ItemChanged(int itemPosition) : super(itemPosition);
}

abstract class ItemRangeEvent extends Event {

  ItemRangeEvent(this.itemPositionFrom, this.itemPositionTo);

  final int itemPositionFrom;
  final int itemPositionTo;
}

class ItemRangeInserted extends ItemRangeEvent {
  ItemRangeInserted(int itemPositionFrom, int itemPositionTo) : super(
      itemPositionFrom, itemPositionTo);
}

class ItemRangeRemoved extends ItemRangeEvent {
  ItemRangeRemoved(int itemPositionFrom, int itemPositionTo) : super(
      itemPositionFrom, itemPositionTo);
}

class ItemRangeUpdated extends ItemRangeEvent {
  ItemRangeUpdated(int itemPositionFrom, int itemPositionTo) : super(
      itemPositionFrom, itemPositionTo);
}

class ItemMoved extends ItemRangeEvent {
  ItemMoved(int itemPositionFrom, int itemPositionTo) : super(
      itemPositionFrom, itemPositionTo);
}

// location list res.

typedef Updater = Event Function(List<Location> list);

class LocationListResource with ChangeNotifier {

  final List<Location> locationList;
  Event _event;

  LocationListResource(this.locationList, this._event);

  void update(Updater updater) {
    _event = updater(locationList);
    notifyListeners();
  }

  Event get event => _event;
}