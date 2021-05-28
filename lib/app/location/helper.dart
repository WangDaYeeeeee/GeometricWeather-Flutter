import 'package:geolocator/geolocator.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/db/helper.dart';

const TIMEOUT_SECONDS = 20;

class LocationHelper {

  Future<Location> requestLocation(Location location) async {
    LocationPermission permission;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    List<Position> positions = await Future.wait<Position>([
      Geolocator.getCurrentPosition(timeLimit: Duration(seconds: TIMEOUT_SECONDS)),
      Geolocator.getLastKnownPosition(),
    ]);

    Location result;
    if (positions[0] != null) {
      result = Location.copyOf(location,
        latitude: positions[0].latitude,
        longitude: positions[0].longitude
      );
    } else if (positions[1] != null) {
      result = Location.copyOf(location,
          latitude: positions[1].latitude,
          longitude: positions[1].longitude
      );
    }

    if (result != null) {
      DatabaseHelper.getInstance().writeLocation(result);
    }

    return Future.error('Location failed by unknown reason.');
  }
}