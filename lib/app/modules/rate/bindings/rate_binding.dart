import 'package:get/get.dart';

import '../controllers/rate_controller.dart';

class RateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RateController>(
      () => RateController(),
    );
  }
}
