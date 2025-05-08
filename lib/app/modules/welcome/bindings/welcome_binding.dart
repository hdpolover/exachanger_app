import 'package:exachanger_get_app/app/bindings/initial_binding.dart';
import 'package:get/get.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<WelcomeController>(
    //   () => WelcomeController(),
    // );
    InitialBinding.reinitializeDependencies();
  }
}
