import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/location/helper.dart';
import 'package:geometricweather_flutter/app/weather/helper.dart';

typedef UpdateValidator = Location Function();

class UpdateProgressHandler {

  static Disposable _requestWeather(
      BuildContext context,
      Location location,
      StreamController<UpdateResult<Location>> controller) {

    DisposableFuture<Weather> df = WeatherHelper().requestWeather(context, location);

    df.future.then((value) {
      // check is closed.
      if (controller.isClosed) {
        return;
      }

      // send data and close stream.
      controller.add(
          UpdateResult(
              Location.copyOf(location, weather: value),
              UpdateStatus.REQUEST_SUCCEED
          )
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
      controller.add(
          UpdateResult(
              location,
              UpdateStatus.REQUEST_FAILED
          )
      );
    }).whenComplete(() {
      controller.close();
    });

    return df.disposable;
  }

  static Stream<UpdateResult<Location>> requestWeatherUpdate(
      BuildContext context, Location location) {

    StreamController<UpdateResult<Location>> controller;
    StreamSubscription subscription;
    Disposable disposable;

    controller = StreamController(
      onListen: () {
        if (!location.currentPosition) {
          // just request weather.
          disposable = _requestWeather(context, location, controller);
          return;
        }

        // get location at first.
        subscription = LocationHelper.requestLocation(location).listen((event) {
          // check is closed.
          if (controller.isClosed) {
            return;
          }

          // send data.
          location = event.data;
          controller.add(event);

          // request weather.
          if (event.status == UpdateStatus.LOCATOR_SUCCEED) {
            disposable = _requestWeather(context, location, controller);
          }
        });
      },
      onCancel: () {
        subscription?.cancel();
        disposable?.dispose();
        controller.close();
      },
    );

    return controller.stream;
  }
}