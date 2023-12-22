import 'dart:io' show Platform;

import 'package:app_usage/app_usage.dart';
import 'package:data_mates/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'background_execution.dart';

extension on AppUsageInfo {
  Map<String, dynamic> toJson() {
    return {
      'package_name': packageName,
      'app_name': appName,
      'usage': usage.inSeconds,
      'last_foreground': lastForeground.toIso8601String(),
      'start_time': startDate.toIso8601String(),
      'end_time': endDate.toIso8601String(),
    };
  }
}

class AppUsageRecordTask extends RecurringTask {
  AppUsageRecordTask(Duration frequency)
      : super(
          name: 'app_usage_record_task',
          frequency: frequency,
        );

  @override
  Future<void> execute() async {
    if (!Platform.isAndroid) return;
    await Supabase.initialize(
        url: 'https://cexfbcoxhnijobphhdnf.supabase.co',
        anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNleGZiY294aG5pam9icGhoZG5mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI5NTM3OTYsImV4cCI6MjAxODUyOTc5Nn0.VOg0AaQTDBx3pxUNqQdHS_FufY4EWYh4kc1VrGinigA');

    final endDate = DateTime.now();
    final startDate = endDate.subtract(frequency);
    try {
      final infoList = await AppUsage().getAppUsage(startDate, endDate);
      for (final info in infoList) {
        DMLogger().i({
          'packageName': info.packageName,
          'appName': info.appName,
          'usage': info.usage.inSeconds,
          'lastForeground': info.lastForeground,
          'startTime': info.startDate,
          'endTime': info.endDate,
        });
      }
      await Supabase.instance.client
          .from('raw_logs')
          .insert(infoList.map((e) => e.toJson()).toList());
    } on AppUsageException catch (e) {
      DMLogger().e(e);
    }
  }
}
