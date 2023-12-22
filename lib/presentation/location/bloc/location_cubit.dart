import 'package:data_mates/domain/model/location.dart';
import 'package:data_mates/domain/repository/location_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<Location> {
  late final LocationRepository _locationRepository;

  LocationCubit(this._locationRepository) : super(Location.initial()) {
    _locationRepository.getLocationStream().listen(_onLocationChanged);
  }

  _onLocationChanged(Location location) {
    emit(location);
  }
}