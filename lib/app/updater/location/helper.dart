import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';

import '../models.dart';

const TIMEOUT_SECONDS = 10;

enum PermissionStatus {
  denied,
  onlyForeground,
  allowAllTheTime,
}

class MethodChannelDisposable extends Disposable {
  final MethodChannel _methodChannel;
  bool _disposed;

  MethodChannelDisposable(this._methodChannel): _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _methodChannel?.invokeMethod('cancelRequest');
  }

  @override
  bool get disposed => _disposed;
}

class LocationHelper {

  static DisposableFuture<UpdateResult<Location>> requestLocation(
      Location location, {
        bool inBackground = false,
      }) {
    if (Platform.isAndroid) {
      return requestLocationOnAndroidPlatform(location,
        inBackground: inBackground,
      );
    }

    return DisposableFuture(
      Future.sync(() async {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return _buildFailedResult(
              location,
              UpdateStatus.LOCATOR_DISABLED
          );
        }
        testLog('Location service is enabled.');

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          // only request permissions on foreground.
          if (inBackground) {
            return _buildFailedResult(
                location,
                UpdateStatus.LOCATOR_PERMISSIONS_DENIED
            );
          }

          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return _buildFailedResult(
                location,
                UpdateStatus.LOCATOR_PERMISSIONS_DENIED
            );
          }
        } else if (permission == LocationPermission.deniedForever) {
          return _buildFailedResult(
              location,
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

          return _buildFailedResult(
            location,
            UpdateStatus.LOCATOR_FAILED,
          );
        }
      }),
      MethodChannelDisposable(null),
    );
  }

  static DisposableFuture<UpdateResult<Location>> requestLocationOnAndroidPlatform(
      Location location, {
        bool inBackground = false,
      }) {

    final locationChannel = MethodChannel('com.wangdaye.geometricweather/location');

    return DisposableFuture(
      Future.sync(() async {
        final serviceEnabled = await locationChannel.invokeMethod('isLocationServiceEnabled');
        if (!serviceEnabled) {
          return _buildFailedResult(
              location,
              UpdateStatus.LOCATOR_DISABLED
          );
        }
        testLog('[Android] Location service is enabled.');

        final status = PermissionStatus.values[
          await locationChannel.invokeMethod('checkPermissions')
        ];
        if (inBackground) {
          if (status != PermissionStatus.allowAllTheTime) {
            // only request permissions on foreground.
            return _buildFailedResult(
                location,
                UpdateStatus.LOCATOR_PERMISSIONS_DENIED
            );
          }
        } else if (status == PermissionStatus.denied) {
          final requestGranted = await locationChannel.invokeMethod(
              'requestPermissions'
          );
          if (!requestGranted) {
            return _buildFailedResult(
                location,
                UpdateStatus.LOCATOR_PERMISSIONS_DENIED
            );
          }
        }
        testLog('[Android] Got all location permissions.');

        try {
          final result = await locationChannel.invokeMethod('requestLocation', {
            'timeOutMillis': 10 * 1000,
            'inBackground': inBackground,
          }) as Map;
          testLog('[Android] Got current location.');
          return UpdateResult(
              location.copyOf(
                latitude: result['latitude'],
                longitude: result['longitude'],
              ),
              true,
              UpdateStatus.LOCATOR_SUCCEED
          );
        } on Exception catch (e, stacktrace) {
          testLog(e.toString());
          testLog(stacktrace.toString());

          return _buildFailedResult(
            location,
            UpdateStatus.LOCATOR_FAILED,
          );
        }
      }),
      MethodChannelDisposable(locationChannel),
    );
  }

  static UpdateResult<Location> _buildFailedResult(
      Location location,
      UpdateStatus status) => UpdateResult(
    location.usable ? location : Location.buildDefaultLocation(),
    true,
    status,
  );
}