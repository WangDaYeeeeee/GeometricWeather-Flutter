import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';

import '../models.dart';

const TIMEOUT_SECONDS = 20;

typedef LocatorStreamCallback = void Function(UpdateResult<Location> result);

class LocationHelper {

  static Future<UpdateResult<Location>> requestLocation(Location location) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return UpdateResult(
          location.usable ? location : Location.buildDefaultLocation(),
          true,
          UpdateStatus.LOCATOR_DISABLED
      );
    }
    testLog('Location service is enabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return UpdateResult(
            location.usable ? location : Location.buildDefaultLocation(),
            true,
            UpdateStatus.LOCATOR_PERMISSIONS_DENIED
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return UpdateResult(
          location.usable ? location : Location.buildDefaultLocation(),
          true,
          UpdateStatus.LOCATOR_PERMISSIONS_DENIED
      );
    }
    testLog('Got all location permissions.');

    try {
      final data = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: TIMEOUT_SECONDS)
      );
      testLog('Got current location.');
      return UpdateResult(
          location.copyOf(
            latitude: data.latitude,
            longitude: data.longitude,
          ),
          true,
          UpdateStatus.LOCATOR_SUCCEED
      );
    } on Exception catch (e, stacktrace) {
      testLog(e.toString());
      testLog(stacktrace.toString());

      return UpdateResult(
        location.usable ? location : Location.buildDefaultLocation(),
        true,
        UpdateStatus.LOCATOR_FAILED,
      );
    }
  }
}