import 'package:exachanger_get_app/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Use put instead of lazyPut with permanent:true to keep the controller in memory
    Get.put<SplashController>(
      SplashController(),
      permanent: true, // Keep the controller in memory for data sharing
      tag: "splash_controller", // Add a tag for easier retrieval
    );

    Get.put<WelcomeController>(
      WelcomeController(),
      permanent: true,
    );
  }
}
