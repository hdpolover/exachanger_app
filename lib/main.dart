import 'package:exachanger_get_app/app/bindings/initial_binding.dart';
import 'package:flutter/material.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

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
