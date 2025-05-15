import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/modules/profile/views/widgets/setting_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends BaseView<ProfileController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  List<SettingItem> items = [
    SettingItem(
      icon: Icons.person,
      title: 'Profile Information',
      subtitle: 'Manage account details',
      onTap: () {
        // Handle navigation
      },
    ),
    // referral code
    SettingItem(
      icon: Icons.person,
      title: 'Referral Code',
      subtitle: 'Invite your friends and earn rewards',
      onTap: () {
        // Handle navigation
      },
    ),
    // about exchanger
    SettingItem(
      icon: Icons.info,
      title: 'About Exchanger',
      subtitle: 'Get to know more about Exchanger',
      onTap: () {
        // Handle navigation
      },
    ),
    // faq
    SettingItem(
      icon: Icons.help,
      title: 'FAQs',
      subtitle: 'Frequently asked questions',
      onTap: () {
        // Handle navigation
      },
    ),
    // log out
    SettingItem(
      icon: Icons.logout,
      title: 'Logout',
      subtitle: 'Sign out of your account',
      onTap: () {
        // Handle logout
        Get.find<PreferenceManagerImpl>().logout();

        Get.offAllNamed(Routes.WELCOME);
      },
      isSignOutBtn: true,
    ),
  ];

  _buildBottomListSection() {
    String year = DateTime.now().year.toString();
    String appVersion = "1.0.0"; // Default version
    String appName = "Exachanger"; // Default app name

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      appName = packageInfo.appName;
    });

    return SizedBox(
      height: Get.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'v$appVersion',
            style: extraSmallBodyTextStyle.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '© $year $appName. All rights reserved.',
            style: extraSmallBodyTextStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _topStack() {
    return SizedBox(
      height: Get.height * 0.4,
      child: Stack(
        children: [
          // Blue top container
          Container(
            height: Get.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // White container with inward curve at top
          Positioned(
            top: Get.height * 0.2,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.only(top: Get.height * 0.08),
              child: Column(
                children: [
                  Obx(() => Text(
                        controller.userData.value?.name?.toUpperCase() ??
                            'User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(height: 4),
                  Obx(() => Text(
                        controller.userData.value?.email ??
                            'Email not available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Display user role
                  Obx(() => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          'Role: ${controller.userData.value?.role?.toUpperCase() ?? 'USER'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

          // Profile avatar overlapping blue and white sections
          Positioned(
            top: Get.height * 0.125,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(
                        'https://ui-avatars.com/api/?background=random&name=${controller.userData.value?.name ?? "User"}',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          // Top section with blue background, curved white container and avatar
          _topStack(),

          // Content section
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Settings items
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: item,
                    )),

                // Bottom section with version info
              ],
            ),
          ),

          _buildBottomListSection(),
        ],
      ),
    );
    // return Stack(
    //   // Use Stack to layer widgets
    //   children: [
    //     // Blue Section (Curved Bottom)
    //     Container(
    //       height: 200, // Adjust height as needed
    //       decoration: const BoxDecoration(
    //         color: Colors.blue, // Or your specific blue color
    //         borderRadius: BorderRadius.only(
    //           bottomLeft: Radius.circular(20),
    //           bottomRight: Radius.circular(20),
    //         ),
    //       ),
    //     ),

    //     // White Section (Curved Top)
    //     Positioned(
    //       // Position the white container
    //       top: 100, // Adjust top position to control overlap
    //       left: 20,
    //       right: 20,
    //       bottom: 20, // Or adjust as needed
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         padding: const EdgeInsets.all(20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const SizedBox(height: 80), // Adjust spacing for the image
    //             const Text(
    //               'Account Details',
    //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //             ),
    //             const SizedBox(height: 20),
    //             SettingItem(
    //               icon: Icons.person,
    //               title: 'Personal Information',
    //               subtitle: 'Update your name, email, and password',
    //               onTap: () {
    //                 // Handle navigation
    //               },
    //             ),
    //             const SizedBox(height: 20),
    //             SettingItem(
    //               icon: Icons.notifications,
    //               title: 'Notifications',
    //               subtitle: 'Choose which notifications you want to receive',
    //               onTap: () {
    //                 // Handle navigation
    //               },
    //             ),
    //             const SizedBox(height: 20), // Add space before logout
    //             Center(
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   // Handle logout
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.red,
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 40, vertical: 15),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                 ),
    //                 child: const Text('Logout',
    //                     style: TextStyle(color: Colors.white)),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),

    //     // Profile Image (Centered and Overlapping)
    //     Positioned(
    //       top: 50, // Adjust top position to control image placement
    //       left: 0,
    //       right: 0,
    //       child: Center(
    //         child: CircleAvatar(
    //           radius: 50,
    //           backgroundImage: const NetworkImage(
    //             'https://www.pngitem.com/pimgs/m/150-1503945_transparent-hd-user-png-free-download-png-download.png',
    //           ),
    //         ),
    //       ),
    //     ),
    //     // Name and email
    //     Positioned(
    //       top: 130, // Adjust top position to control image placement
    //       left: 0,
    //       right: 0,
    //       child: Center(
    //           child: Column(
    //         children: const [
    //           Text(
    //             'Alfina Rosyida',
    //             style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.white),
    //           ),
    //           Text(
    //             'alfinarosyida@gmail.com',
    //             style: TextStyle(fontSize: 16, color: Colors.white),
    //           ),
    //         ],
    //       )),
    //     ),
    //   ],
    // );
  }
}
