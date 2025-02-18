import 'package:exachanger_get_app/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    super.onInit();

    // get metadata
    var metadataController = Get.find<WelcomeController>();

    metadataController.getWelcomeInfo();

    // Simplified ever listener
    ever(metadataController.metaData, (metadata) {
      if (metadata != null) {
        navigateToWelcome();
      }
    });
  }

  void navigateToWelcome() {
    Get.offNamed(Routes.WELCOME);
  }
}
