import 'package:get/get.dart';

import '../controllers/setup_pin_controller.dart';

class SetupPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetupPinController>(() => SetupPinController());
  }
}
