import 'package:data_mates/services/app_usage_service.dart';
import 'package:data_mates/services/background_execution.dart';
import 'package:data_mates/services/location_service.dart';
import 'package:data_mates/utils/logger.dart';
import 'package:workmanager/workmanager.dart';

final services = [
  BackgroundService(onStart: recordLocationLog),
];

final recurringTasks = [
  AppUsageRecordTask(const Duration(hours: 1)),
];

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    DMLogger().d("Executing $taskName in background");
    for (final task in recurringTasks) {
      if (task.name == taskName) {
        await task.execute();
      }
    }
    return Future.value(true);
  });
}

Future<void> setupBackgroundTasks() async {
  for (final service in services) {
    await service.deploy();
  }
  Workmanager().initialize(callbackDispatcher);
  for (final task in recurringTasks) {
    await Workmanager().registerPeriodicTask(
      task.name,
      task.name,
      frequency: task.frequency,
      constraints: task.constraints,
    );
    await Workmanager().registerOneOffTask(
      "${task.name}_one_off",
      task.name,
      initialDelay: const Duration(seconds: 10),
    );
  }
}
