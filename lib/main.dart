import 'package:exachanger_app/core/service_locator.dart';
import 'package:exachanger_app/features/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependencies
  await setupDependencies();

  // Configure for development
  toggleRepositories(true); // Use fake repositories

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Splashscreen(),
      ),
    ),
  );
}
