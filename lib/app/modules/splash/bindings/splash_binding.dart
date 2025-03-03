import 'package:exachanger_get_app/app/data/local/preference/preference_manager.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
    Get.put<WelcomeController>(
      WelcomeController(),
      permanent: true,
    );
  }
}
