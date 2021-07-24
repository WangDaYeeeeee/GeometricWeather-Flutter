import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';

import '../models.dart';

const TIMEOUT_SECONDS = 10;

const _CHANNEL_NAME = 'com.wangdaye.geometricweather/location';

const _METHOD_REQUEST_LOCATION = 'requestLocation';
const _METHOD_GET_LAST_KNOWN_LOCATION = 'getLastKnownLocation';
const _METHOD_CANCEL_REQUEST = 'cancelRequest';
const _METHOD_IS_LOCATION_SERVICE_ENABLED = 'isLocationServiceEnabled';
const _METHOD_CHECK_PERMISSIONS = 'checkPermissions';
const _METHOD_REQUEST_PERMISSIONS = 'requestPermissions';

const _PARAM_IN_BACKGROUND = 'inBackground';
const _PARAM_LATITUDE = 'latitude';
const _PARAM_LONGITUDE = 'longitude';

enum PermissionStatus {
  denied,
  onlyForeground,
  allowAllTheTime,
}

class LocationHelper {

  static Stream<UpdateResult<Location>> _locationStream;
  static int _subscribeCount = 0;

  static Future<UpdateResult<Location>> _prepareForLocation(
      Location location,
      MethodChannel locationChannel, {
        bool inBackground = false,
      }) async {

    final serviceEnabled = await locationChannel.invokeMethod(
        _METHOD_IS_LOCATION_SERVICE_ENABLED
    );
    if (!serviceEnabled) {
      return _buildFailedResult(
          location,
          UpdateStatus.LOCATOR_DISABLED
      );
    }
    testLog('Location service is enabled.');

    final status = PermissionStatus.values[
    await locationChannel.invokeMethod(_METHOD_CHECK_PERMISSIONS)
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
          _METHOD_REQUEST_PERMISSIONS
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

  static Stream<UpdateResult<Location>> requestLocation(
      Location location, {
        bool inBackground = false,
      }) {
    // ensure location stream.
    if (_locationStream == null) {
      final locationChannel = MethodChannel(_CHANNEL_NAME);
      _locationStream = Stream.fromFuture(Future(() async {
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
              if (_locationStream == null) {
                return _buildFailedResult(
                  location,
                  UpdateStatus.LOCATOR_FAILED,
                );
              }
              final result = await locationChannel.invokeMethod(_METHOD_REQUEST_LOCATION, {
                _PARAM_IN_BACKGROUND: inBackground,
              }) as Map;
              // check whether ended after request done.
              if (_locationStream == null) {
                return _buildFailedResult(
                  location,
                  UpdateStatus.LOCATOR_FAILED,
                );
              }
              _locationStream = null;
              _subscribeCount = 0;

              testLog('Got current location.');
              return UpdateResult(
                  location.copyOf(
                    latitude: result[_PARAM_LATITUDE],
                    longitude: result[_PARAM_LONGITUDE],
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
            if (_locationStream == null) {
              return _buildFailedResult(
                location,
                UpdateStatus.LOCATOR_FAILED,
              );
            }

            await Future.delayed(Duration(seconds: TIMEOUT_SECONDS));

            if (_locationStream != null) {
              _locationStream = null;
              _subscribeCount = 0;
              try {
                locationChannel.invokeMethod(_METHOD_CANCEL_REQUEST);

                final result = await locationChannel.invokeMethod(
                    _METHOD_GET_LAST_KNOWN_LOCATION
                ) as Map;
                testLog('Got last known location.');
                return UpdateResult(
                    location.copyOf(
                      latitude: result[_PARAM_LATITUDE],
                      longitude: result[_PARAM_LONGITUDE],
                    ),
                    true,
                    UpdateStatus.LOCATOR_FAILED
                );
              } on Exception catch (e, stacktrace) {
                testLog(e.toString());
                testLog(stacktrace.toString());

                return _buildFailedResult(
                  location,
                  UpdateStatus.LOCATOR_FAILED,
                );
              }
            }

            return _buildFailedResult(
              location,
              UpdateStatus.LOCATOR_FAILED,
            );
          }),
        ]);

        locationChannel.invokeMethod(_METHOD_CANCEL_REQUEST);

        return result;
      })).asBroadcastStream(
        onListen: (_) {
          _subscribeCount ++;
        },
        onCancel: (_) {
          _subscribeCount --;
          if (_subscribeCount <= 0) {
            locationChannel.invokeMethod(_METHOD_CANCEL_REQUEST);
            _locationStream = null;
          }
        }
      );
      _subscribeCount = 0;
    }
    return _locationStream;
  }

  static UpdateResult<Location> _buildFailedResult(
      Location location,
      UpdateStatus status) => UpdateResult(
    location.usable ? location : Location.buildDefaultLocation(),
    true,
    status,
  );
}