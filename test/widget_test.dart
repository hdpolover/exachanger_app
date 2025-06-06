// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exachanger_get_app/app/my_app.dart';
import 'package:exachanger_get_app/app/bindings/initial_binding.dart';
import 'package:exachanger_get_app/flavors/build_config.dart';
import 'package:exachanger_get_app/flavors/env_config.dart';
import 'package:exachanger_get_app/flavors/environment.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Set up environment configuration for testing
    EnvConfig testConfig = EnvConfig(
      appName: "Exachanger Test",
      baseUrl: "https://api-exchanger.ngodingin.org/api/mobile/v1",
      shouldCollectCrashLog: false,
    );

    BuildConfig.instantiate(
      envType: Environment.DEVELOPMENT,
      envConfig: testConfig,
    );

    InitialBinding().dependencies();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads (check for Material app)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
