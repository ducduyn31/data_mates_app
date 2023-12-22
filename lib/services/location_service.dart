import 'dart:async';

import 'package:data_mates/data/location_repository_impl.dart';
import 'package:data_mates/utils/logger.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:rxdart/rxdart.dart';

@pragma('vm:entry-point')
Future<void> recordLocationLog(ServiceInstance instance) async {
  var counter = 0;

  final repo = LocationRepositoryImpl();

  repo.getLocationStream().throttleTime(const Duration(seconds: 1)).listen((event) async {
    if (instance is AndroidServiceInstance &&
        !(await instance.isForegroundService())) {
      DMLogger().d({
        'counter': counter,
        'latitude': event.latitude,
        'longitude': event.longitude,
        'heading': event.heading,
        'time': DateTime.now(),
      });
      counter++;
    }
  });
}
