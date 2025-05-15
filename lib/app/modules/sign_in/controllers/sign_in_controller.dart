import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/signin_model.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:get/get.dart';

import '../../../network/dio_provider.dart';
import '../../../routes/app_pages.dart';

class SignInController extends BaseController {
  final AuthRepository authRepository =
      Get.find(tag: (AuthRepository).toString());

  final Rx<SigninModel?> signinData = Rx<SigninModel?>(null);
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();

  void doSignIn(Map<String, dynamic> data) {
    var service = authRepository.getAuthData(data);

    callDataService(service, onSuccess: (data) {
      // Store signIn data in the controller
      signinData.value = data;

      // Save all user data and tokens
      preferenceManager.saveUserDataFromSignin(data);

      // Set auth token for API calls
      DioProvider.setAuthToken(data.accessToken!);

      // go to main view
      Get.offNamed(Routes.MAIN);
    }, onError: (error) {
      showErrorMessage(error.toString());
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
