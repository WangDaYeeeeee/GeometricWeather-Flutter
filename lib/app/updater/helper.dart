import 'dart:async';

import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/db/helper.dart';
import 'package:geometricweather_flutter/app/updater/weather/helper.dart';

import 'location/helper.dart';
import 'models.dart';

typedef UpdateValidator = Location Function();

Disposable _requestWeather(
    Location location,
    StreamController<UpdateResult<Location>> controller) {

  final disposableFuture = WeatherHelper().requestWeather(location);

  disposableFuture.future.then((value) async {
    // check is closed.
    if (controller.isClosed) {
      return;
    }

    location = value.data ?? location;
    if (location.weather == null) {
      location = location.copyOf(
          weather: await DatabaseHelper.getInstance().readWeather(location.formattedId)
      );
    }

    // send data and close stream.
    UpdateStatus status;
    if (value.getGeoPositionFailed) {
      status = UpdateStatus.GET_GEO_POSITION_FAILED;
    } else if (value.getWeatherFailed) {
      status = UpdateStatus.GET_WEATHER_FAILED;
    } else if (value.jsonDecodeFailed) {
      status = UpdateStatus.JSON_DECODE_FAILED;
    } else {
      status = UpdateStatus.REQUEST_SUCCEED;
    }
    controller.add(UpdateResult(location, false, status));

    // save.
    if (value.data != null) {
      DatabaseHelper.getInstance().writeLocation(value.data);
      if (value.data.weather != null) {
        DatabaseHelper.getInstance().writeWeather(
            value.data.formattedId,
            value.data.weather
        );
      }
    }

  }).onError((error, stackTrace) async {
    testLog(error.toString());
    testLog(stackTrace.toString());

    // read cache.
    location = location.copyOf(
        weather: await DatabaseHelper.getInstance().readWeather(
            location.formattedId
        )
    );

    // check is closed.
    if (controller.isClosed) {
      return;
    }

    // send data.
    controller.add(
        UpdateResult(
            location,
            false,
            UpdateStatus.GET_WEATHER_FAILED
        )
    );
  }).whenComplete(() {
    controller.close();
  });

  return disposableFuture.disposable;
}

Stream<UpdateResult<Location>> requestWeatherUpdate(Location location, {
  bool inBackground = false,
}) {

  StreamController<UpdateResult<Location>> controller;
  Disposable locationDisposable;
  Disposable weatherDisposable;

  controller = StreamController(
    onListen: () {
      if (!location.currentPosition) {
        // just request weather.
        weatherDisposable = _requestWeather(location, controller);
        return;
      }

      // get location at first.
      final disposableFuture = LocationHelper.requestLocation(location,
        inBackground: inBackground,
      );
      locationDisposable = disposableFuture.disposable;
      disposableFuture.future.then((event) {
        // check is closed.
        if (controller.isClosed) {
          return;
        }

        // send data.
        location = event.data;
        controller.add(event);

        // request weather.
        weatherDisposable = _requestWeather(location, controller);
      });
    },
    onCancel: () {
      locationDisposable?.dispose();
      weatherDisposable?.dispose();
      controller.close();
    },
  );

  return controller.stream;
}

Stream<UpdateResult<Location>> pollingUpdate(List<Location> locationList, {
  bool inBackground = false,
}) {

  StreamController<UpdateResult<Location>> controller;
  final idSubscriptionMap = Map<String, StreamSubscription>();

  controller = StreamController(
    onListen: () {
      for (Location location in locationList) {
        idSubscriptionMap[location.formattedId] = requestWeatherUpdate(location,
          inBackground: inBackground,
        ).listen((event) {
          // check is closed.
          if (controller.isClosed || event.running) {
            return;
          }

          controller.add(event);
          idSubscriptionMap.remove(event.data.formattedId);
        });
      }
    },
    onCancel: () {
      idSubscriptionMap.values.forEach((element) {
        element.cancel();
      });
      idSubscriptionMap.clear();

      controller.close();
    },
  );

  return controller.stream;
}