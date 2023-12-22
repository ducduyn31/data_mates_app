import 'package:data_mates/domain/model/info_status.dart';

abstract class StatusRepository {
  Future<InfoStatus> getStatus();

  Stream<InfoStatus> getStatusStream();

  void updateStatus(InfoStatus status);
}