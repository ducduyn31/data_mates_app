import 'package:data_mates/presentation/app_root.dart';
import 'package:data_mates/services/background_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const AppRoot());
}

Future<void> initializeService() async {
  await setupBackgroundTasks();
}
