import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ReferralController extends BaseController {
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();

  // User data observable
  final Rx<UserModel?> userData = Rx<UserModel?>(null);

  // Referral statistics
  final RxInt totalReferrals = 0.obs;
  final RxDouble totalEarnings = 0.0.obs;
  final RxList<Map<String, dynamic>> referralHistory =
      <Map<String, dynamic>>[].obs;

  // Referral code
  final RxString referralCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    generateReferralCode();
    loadReferralStats();
  }

  // Load user data from preferences
  Future<void> loadUserData() async {
    try {
      // First try to get from Get.find which would be faster
      try {
        if (Get.isRegistered<UserModel>(tag: "current_user")) {
          UserModel user = Get.find<UserModel>(tag: "current_user");
          userData.value = user;
          print('Referral: User data fetched from Get: ${user.name}');
          return;
        }
      } catch (e) {
        print('Referral: Error accessing user data from Get storage: $e');
      }

      // Fall back to loading from preferences
      final userFromPrefs = await preferenceManager.getUserData();
      if (userFromPrefs != null) {
        userData.value = userFromPrefs;
        print(
          'Referral: User data loaded from preferences: ${userFromPrefs.name}',
        );
      }
    } catch (e) {
      print('Error loading user data in ReferralController: $e');
    }
  }

  // Generate referral code based on user data
  void generateReferralCode() {
    // TODO: Get actual referral code from API or generate based on user ID
    final userId = userData.value?.id ?? 'USER';
    final userIdShort = userId.length > 8 ? userId.substring(0, 8) : userId;
    referralCode.value =
        'EXCH${DateTime.now().year}${userIdShort.toUpperCase()}';
  }

  // Load referral statistics
  Future<void> loadReferralStats() async {
    try {
      // TODO: Load from API
      // For now, use mock data
      totalReferrals.value = 5;
      totalEarnings.value = 125.50;

      referralHistory.value = [
        {
          'name': 'John Doe',
          'date': '2025-06-10',
          'status': 'Active',
          'earnings': 25.0,
        },
        {
          'name': 'Jane Smith',
          'date': '2025-06-08',
          'status': 'Active',
          'earnings': 25.0,
        },
        {
          'name': 'Mike Johnson',
          'date': '2025-06-05',
          'status': 'Pending',
          'earnings': 0.0,
        },
        {
          'name': 'Sarah Wilson',
          'date': '2025-06-03',
          'status': 'Active',
          'earnings': 25.0,
        },
        {
          'name': 'David Brown',
          'date': '2025-06-01',
          'status': 'Active',
          'earnings': 25.0,
        },
      ];
    } catch (e) {
      print('Error loading referral stats: $e');
    }
  }

  // Copy referral code to clipboard
  void copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied!',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
      icon: Icon(Icons.check_circle, color: Get.theme.colorScheme.onPrimary),
      duration: Duration(seconds: 2),
    );
  }

  // Share referral code
  void shareReferralCode() {
    // TODO: Implement share functionality
    Get.snackbar(
      'Coming Soon',
      'Share feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  // Refresh referral data
  Future<void> refreshData() async {
    try {
      await loadUserData();
      generateReferralCode();
      await loadReferralStats();
    } catch (e) {
      print('Error refreshing referral data: $e');
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
