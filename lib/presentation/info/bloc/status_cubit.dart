import 'package:data_mates/domain/model/info_status.dart';
import 'package:data_mates/domain/repository/status_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusCubit extends Cubit<InfoStatus> {
  late final StatusRepository _statusRepository;

  StatusCubit(this._statusRepository)
      : super(const InfoStatus(workerStatus: false, serverStatus: true)) {
    _statusRepository.getStatusStream().listen(_onStatusChanged);
  }

  _onStatusChanged(InfoStatus status) {
    emit(status);
  }

  void updateStatus() {
    _statusRepository.updateStatus(const InfoStatus(workerStatus: true, serverStatus: true));
  }
}