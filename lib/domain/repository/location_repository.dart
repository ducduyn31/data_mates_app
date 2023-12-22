import 'package:data_mates/domain/model/location.dart';

abstract class LocationRepository {
  Future<Location> getLocation();

  Stream<Location> getLocationStream();
}