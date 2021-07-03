import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  final VoidCallback _callback;
  bool _disposed;

  MethodChannelDisposable(
      this._methodChannel,
      this._callback): _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _callback?.call();
    _methodChannel?.invokeMethod('cancelRequest');
  }

  @override
  bool get disposed => _disposed;
}

class LocationHelper {

  static Future<UpdateResult<Location>> _prepareForLocation(
      Location location,
      MethodChannel locationChannel, {
        bool inBackground = false,
      }) async {

    final serviceEnabled = await locationChannel.invokeMethod(
        'isLocationServiceEnabled'
    );
    if (!serviceEnabled) {
      return _buildFailedResult(
          location,
          UpdateStatus.LOCATOR_DISABLED
      );
    }
    testLog('Location service is enabled.');

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
    testLog('Got all location permissions.');

    return null;
  }

  static DisposableFuture<UpdateResult<Location>> requestLocation(
      Location location, {
        bool inBackground = false,
      }) {

    final locationChannel = MethodChannel(
        'com.wangdaye.geometricweather/location'
    );
    bool locating = true;

    return DisposableFuture<UpdateResult<Location>>(
      Future(() async {
        final prepareResult = await _prepareForLocation(
          location,
          locationChannel,
          inBackground: inBackground,
        );
        if (prepareResult != null) {
          return prepareResult;
        }

        final result = await Future.any([
          Future(() async {
            try {
              // check whether ended before start request.
              if (!locating) {
                return _buildFailedResult(
                  location,
                  UpdateStatus.LOCATOR_FAILED,
                );
              }
              final result = await locationChannel.invokeMethod('requestLocation', {
                'inBackground': inBackground,
              }) as Map;
              // check whether ended after request done.
              if (!locating) {
                return _buildFailedResult(
                  location,
                  UpdateStatus.LOCATOR_FAILED,
                );
              }
              locating = false;

              testLog('Got current location.');
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
          Future(() async {
            if (!locating) {
              return _buildFailedResult(
                location,
                UpdateStatus.LOCATOR_FAILED,
              );
            }

            await Future.delayed(Duration(seconds: TIMEOUT_SECONDS));

            if (locating) {
              locating = false;
              locationChannel.invokeMethod("cancelRequest");

              final result = await locationChannel.invokeMethod(
                  'getLastKnownLocation'
              ) as Map;
              testLog('Got last known location.');
              return UpdateResult(
                  location.copyOf(
                    latitude: result['latitude'],
                    longitude: result['longitude'],
                  ),
                  true,
                  UpdateStatus.LOCATOR_FAILED
              );
            }

            return _buildFailedResult(
              location,
              UpdateStatus.LOCATOR_FAILED,
            );
          }),
        ]);

        locationChannel.invokeMethod("cancelRequest");

        return result;
      }),
      MethodChannelDisposable(locationChannel, () {
        locating = false;
      }),
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