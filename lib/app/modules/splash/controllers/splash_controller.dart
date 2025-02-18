import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed(Routes.WELCOME);
    });
  }
}
