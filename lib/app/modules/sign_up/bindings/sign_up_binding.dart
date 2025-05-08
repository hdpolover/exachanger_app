import 'package:get/get.dart';

import '../controllers/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    // Use put instead of lazyPut and mark as permanent to ensure single instance
    Get.put<SignUpController>(
      SignUpController(),
      permanent: true,
    );
  }
}
