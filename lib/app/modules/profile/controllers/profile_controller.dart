import 'dart:convert';

import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';
import 'package:get/get.dart';

class ProfileController extends BaseController {
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();

  // User data observable
  final Rx<UserModel?> userData = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Load user data from preferences
  Future<void> loadUserData() async {
    try {
      final userDataJson = await preferenceManager.getString('user_data');
      if (userDataJson.isNotEmpty) {
        final userMap = jsonDecode(userDataJson);
        userData.value = UserModel.fromJson(userMap);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
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
