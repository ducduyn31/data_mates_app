import 'dart:async';

import 'package:data_mates/domain/model/location.dart';
import 'package:data_mates/presentation/location/bloc/location_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _mapController = Completer<GoogleMapController>();
  Location? _currentLocation;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationCubit>(context).stream.listen((location) {
      _mapController.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 14,
            bearing: location.heading)));
      });
    });
    BlocProvider.of<LocationCubit>(context)
        .stream
        .throttleTime(const Duration(seconds: 3))
        .listen((location) {
      setState(() {
        _currentLocation = location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 14,
          bearing: 0,
        ),
        onMapCreated: (controller) {
          _mapController.complete(controller);
        },
        myLocationButtonEnabled: true,
        markers: {
          Marker(
              markerId: const MarkerId("currentLocation"),
              position: LatLng(_currentLocation?.latitude ?? 0,
                  _currentLocation?.longitude ?? 0),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure))
        },
      ),
    );
  }
}
