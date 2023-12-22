import 'package:data_mates/domain/model/location.dart';
import 'package:data_mates/domain/repository/location_repository.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeolocatorPlatform _geolocator;

  LocationRepositoryImpl({GeolocatorPlatform? geolocator})
      : _geolocator = geolocator ?? GeolocatorPlatform.instance;

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are denied
      permission = await _geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
  }

  @override
  Future<Location> getLocation() async {
    await _determinePosition();
    final gPosition = await _geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    final direction = await FlutterCompass.events?.last;
    return Location(gPosition.latitude, gPosition.longitude, direction?.heading ?? 0);
  }

  @override
  Stream<Location> getLocationStream() async* {
    await _determinePosition();

    if (FlutterCompass.events == null) {
      yield* _geolocator
          .getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      )
          .map((pos) => Location(pos.latitude, pos.longitude, 0));
    } else {
      yield* Rx.combineLatest2(
        _geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ),
        FlutterCompass.events!.throttleTime(const Duration(milliseconds: 100)),
        (Position pos, CompassEvent event) =>
            Location(pos.latitude, pos.longitude, event.heading ?? 0),
      );
    }
  }
}
