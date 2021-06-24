import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';

import '../models.dart';

const TIMEOUT_SECONDS = 20;

typedef LocatorStreamCallback = void Function(UpdateResult<Location> result);

class LocationHelper {

  static Future<UpdateResult<Location>> _prepare(Location location) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return UpdateResult(
          location,
          location.usable,
          UpdateStatus.LOCATOR_DISABLED
      );
    }
    testLog('Location service is enabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return UpdateResult(
            location,
            location.usable,
            UpdateStatus.LOCATOR_PERMISSIONS_DENIED
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return UpdateResult(
          location,
          location.usable,
          UpdateStatus.LOCATOR_PERMISSIONS_DENIED
      );
    }
    testLog('Got all location permissions.');

    return UpdateResult(
        location,
        true,
        UpdateStatus.LOCATOR_RUNNING
    );
  }

  static StreamSubscription _listenLocatorStream(
      Location location, StreamController<UpdateResult<Location>> controller) {

    return Geolocator.getPositionStream(
        timeLimit: Duration(seconds: TIMEOUT_SECONDS)
    ).transform(StreamTransformer<Position, UpdateResult<Location>>.fromHandlers(
        handleData: (data, sink) {
          location = location.copyOf(
              latitude: 39.904000, // data.latitude, //
              longitude: 116.391000, // data.longitude, //
          );
          sink.add(
              UpdateResult(
                  location,
                  true,
                  UpdateStatus.LOCATOR_SUCCEED
              )
          );
        },
        handleError: (error, stackTrace, sink) {
          testLog(error.toString());
          testLog(stackTrace.toString());
          sink.add(
              UpdateResult(
                  location.usable ? location : Location.buildDefaultLocation(),
                  true, // always usable.
                  UpdateStatus.LOCATOR_FAILED
              )
          );
        },
        handleDone: (sink) {
          controller.close();
        }
    )).take(
        1
    ).listen((event) {
      if (controller.isClosed) {
        return;
      }
      controller.add(event);
    });
  }

  static Stream<UpdateResult<Location>> requestLocation(Location location) {
    StreamController<UpdateResult<Location>> controller;
    StreamSubscription subscription;

    controller = StreamController(
      onListen: () {
        _prepare(location).then((value) {
          // check is closed.
          if (controller.isClosed) {
            return;
          }

          // send data.
          controller.add(value);

          // listen locator and send data.
          subscription = _listenLocatorStream(value.data, controller);
        });
      },
      onCancel: () {
        subscription?.cancel();
        controller.close();
      }
    );

    return controller.stream;
  }
}