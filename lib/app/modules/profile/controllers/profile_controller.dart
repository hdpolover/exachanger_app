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
      // First try to get from Get.find which would be faster
      try {
        if (Get.isRegistered<UserModel>(tag: "current_user")) {
          UserModel user = Get.find<UserModel>(tag: "current_user");
          userData.value = user;
          print('Profile: User data fetched from Get: ${user.name}');
          return;
        } else {
          print('Profile: UserModel not registered with tag "current_user"');
        }
      } catch (e) {
        print('Profile: Error accessing user data from Get storage: $e');
        // Fall back to getting reactive object
        try {
          if (Get.isRegistered<Rx<UserModel?>>(tag: "user_data")) {
            Rx<UserModel?> rxUser = Get.find<Rx<UserModel?>>(tag: "user_data");
            if (rxUser.value != null) {
              userData.value = rxUser.value;
              print(
                  'Profile: User data fetched from reactive object: ${rxUser.value?.name}');
              return;
            } else {
              print('Profile: Reactive user data found but value is null');
            }
          } else {
            print(
                'Profile: Reactive user data not registered with tag "user_data"');
          }
        } catch (e) {
          print('Profile: Error accessing reactive user data: $e');
        }
      }

      // Fall back to loading from preferences
      final userFromPrefs = await preferenceManager.getUserData();
      if (userFromPrefs != null) {
        userData.value = userFromPrefs;
        print(
            'Profile: User data loaded from preferences: ${userFromPrefs.name}');

        // Store for future use
        if (Get.isRegistered<UserModel>(tag: "current_user")) {
          Get.delete<UserModel>(tag: "current_user");
        }
        Get.put<UserModel>(userFromPrefs, tag: "current_user", permanent: true);
        print('Profile: User data registered with GetX');
      } else {
        print('Profile: No user data found in preferences');

        // As last resort, try parsing from raw JSON
        final userDataJson = await preferenceManager.getString('user_data');
        if (userDataJson.isNotEmpty) {
          final userMap = jsonDecode(userDataJson);
          userData.value = UserModel.fromJson(userMap);
          print('Profile: User data parsed from raw JSON');
        }
      }
    } catch (e) {
      print('Error loading user data in ProfileController: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Reload user data when screen becomes active
    loadUserData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
