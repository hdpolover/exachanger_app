import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:exachanger_get_app/app/network/dio_provider.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class SplashController extends BaseController {
  // check if signed in
  Future<bool> isSignedIn() async {
    bool isSignedIn =
        await Get.find<PreferenceManagerImpl>().getBool("is_signed_in");
    if (isSignedIn) {
      return true;
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();

    // check if signed in
    isSignedIn().then((isSignedIn) async {
      if (isSignedIn) {
        String token =
            await Get.find<PreferenceManagerImpl>().getString("access_token");

        DioProvider.setAuthToken(token);

        Get.offNamed(Routes.MAIN);
      } else {
        // get metadata
        var metadataController = Get.find<WelcomeController>();

        metadataController.getWelcomeInfo();

        // Simplified ever listener
        ever(metadataController.metaData, (metadata) {
          if (metadata != null) {
            Get.offNamed(Routes.WELCOME);
          }
        });
      }
    });
  }
}
