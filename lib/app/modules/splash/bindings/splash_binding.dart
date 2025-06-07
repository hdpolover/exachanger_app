import 'package:exachanger_get_app/app/bindings/initial_binding.dart';
import 'package:exachanger_get_app/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure core dependencies are available
    _ensureCoreServicesAreAvailable();

    // Use put instead of lazyPut with permanent:true to keep the controller in memory
    Get.put<SplashController>(
      SplashController(),
      permanent: true, // Keep the controller in memory for data sharing
      tag: "splash_controller", // Add a tag for easier retrieval
    );

    Get.put<WelcomeController>(WelcomeController(), permanent: true);
  }

  /// Ensure that critical dependencies are available
  /// This is particularly important when coming back from error pages
  void _ensureCoreServicesAreAvailable() {
    print('🔧 SplashBinding: Checking core services...');

    // Check if critical dependencies are missing and re-initialize if needed
    bool needsReinitialization = false;

    try {
      // Try to find AuthRemoteDataSource
      Get.find(tag: 'AuthRemoteDataSource');
    } catch (e) {
      print('🔧 AuthRemoteDataSource not found - needs reinitialization');
      needsReinitialization = true;
    }

    if (needsReinitialization) {
      print('🔧 Re-initializing core dependencies...');
      try {
        InitialBinding.reinitializeDependencies();
        print('🔧 Core dependencies re-initialized successfully');
      } catch (e) {
        print('🔧 Error re-initializing dependencies: $e');
        // If re-initialization fails, we'll let the error propagate
        // but the user will see a meaningful error message
      }
    } else {
      print('🔧 All core services are available');
    }
  }
}
