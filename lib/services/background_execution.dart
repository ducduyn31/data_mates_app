import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  final String? channelId;
  final int notificationId;
  final String initialNotificationContent;
  final String initialNotificationTitle;
  final Function(ServiceInstance instance) onStart;


  BackgroundService({
    this.channelId,
    this.notificationId = 112233,
    required this.onStart,
    this.initialNotificationContent = 'Preparing',
    this.initialNotificationTitle = 'Background Service',
  });

  Future<void> deploy() async {
    final service = FlutterBackgroundService();
    await service.configure(iosConfiguration: IosConfiguration(
      onBackground: (instance) async {
        await onStart(instance);
        return true;
      },
      onForeground: (instance) async {
        await onStart(instance);
        return true;
      },
    ), androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      notificationChannelId: channelId,
      foregroundServiceNotificationId: notificationId,
      initialNotificationContent: initialNotificationContent,
      initialNotificationTitle: initialNotificationTitle,
    ));
  }
}

abstract class RecurringTask {
  final String name;
  final Duration frequency;
  final Constraints? constraints;

  RecurringTask({
    required this.name,
    required this.frequency,
    this.constraints,
  });

  Future<void> execute();
}
