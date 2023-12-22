import 'dart:async';

import 'package:data_mates/domain/model/info_status.dart';
import 'package:data_mates/domain/repository/status_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusRepositoryImpl implements StatusRepository {

  @override
  Future<InfoStatus> getStatus() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final workerStatus = sharedPrefs.getBool('workerStatus');

    return InfoStatus(workerStatus: workerStatus ?? false, serverStatus: true);
  }

  @override
  Stream<InfoStatus> getStatusStream() async* {
       // Simulate an interval of 3 seconds
    yield* Stream.periodic(const Duration(seconds: 3))
      .asyncMap((_) async {
        final sharedPrefs = await SharedPreferences.getInstance();
        final workerStatus = sharedPrefs.getBool('workerStatus');

        return InfoStatus(workerStatus: workerStatus ?? false, serverStatus: true);
      });
  }

  @override
  void updateStatus(InfoStatus status) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('workerStatus', status.workerStatus);
    sharedPrefs.setBool('serverStatus', status.serverStatus);
  }
}