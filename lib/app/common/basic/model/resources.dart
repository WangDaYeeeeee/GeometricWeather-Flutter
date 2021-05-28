import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';

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