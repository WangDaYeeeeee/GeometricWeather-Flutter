import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';

const TIMEOUT_SECONDS = 20;

typedef LocatorStreamCallback = void Function(UpdateResult<Location> result);

class LocationHelper {

  static Future<UpdateResult<Location>> _prepare(Location location) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return UpdateResult(
          location,
          UpdateStatus.LOCATOR_DISABLED
      );
    }
    log('Location service is enabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return UpdateResult(
            location,
            UpdateStatus.LOCATOR_PERMISSIONS_DENIED
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return UpdateResult(
          location,
          UpdateStatus.LOCATOR_PERMISSIONS_DENIED
      );
    }
    log('Got all location permissions.');

    return UpdateResult(
        location,
        UpdateStatus.LOCATOR_RUNNING
    );
  }

  static StreamSubscription _listenLocatorStream(
      Location location, StreamController<UpdateResult<Location>> controller) {

    return Geolocator.getPositionStream(
        timeLimit: Duration(seconds: TIMEOUT_SECONDS)
    ).transform(StreamTransformer<Position, UpdateResult<Location>>.fromHandlers(
        handleData: (data, sink) {
          Location loc = Location.copyOf(location,
              latitude: data.latitude,
              longitude: data.longitude
          );
          sink.add(
              UpdateResult(
                  loc,
                  UpdateStatus.LOCATOR_SUCCEED
              )
          );
        },
        handleError: (error, stackTrace, sink) {
          log(error.toString());
          log(stackTrace.toString());
          sink.add(
              UpdateResult(
                  location,
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
            return Future.error('Stream was already closed.');
          }

          // send data.
          controller.add(value);

          // listen locator and send data.
          _listenLocatorStream(value.data, controller);
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