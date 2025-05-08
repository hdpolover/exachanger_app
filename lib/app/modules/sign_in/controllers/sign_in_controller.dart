import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/model/signin_model.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:get/get.dart';

import '../../../network/dio_provider.dart';
import '../../../routes/app_pages.dart';

class SignInController extends BaseController {
  final AuthRepository authRepository =
      Get.find(tag: (AuthRepository).toString());

  final Rx<SigninModel?> signinData = Rx<SigninModel?>(null);

  void doSignIn(Map<String, dynamic> data) {
    var service = authRepository.getAuthData(data);

    callDataService(service, onSuccess: (data) {
      // do something
      signinData.value = data;

      PreferenceManagerImpl().setString("access_token", data.accessToken!);
      PreferenceManagerImpl().setString("refresh_token", data.refreshToken!);
      PreferenceManagerImpl().setBool("is_signed_in", true);

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
