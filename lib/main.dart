import 'package:exachanger_get_app/app/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import '/app/services/notification_service.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Notification Service
  await Get.putAsync(() => NotificationService().init());

  // First set up BuildConfig as many services depend on it
  EnvConfig devConfig = EnvConfig(
    appName: "Exachanger",
    baseUrl: "https://api-exchanger.ngodingin.org/api/mobile/v1",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  // Now that BuildConfig is set up, initialize other dependencies
  InitialBinding().dependencies();

  runApp(const MyApp());
}
