import 'package:animations/animations.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/modules/profile/views/widgets/setting_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../routes/app_pages.dart';
import '../../controllers/profile_controller.dart';

class ProfileView extends BaseView<ProfileController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  // logout button
  Widget _logOutButton() {
    return GestureDetector(
      onTap: () {
        showModal(
          context: Get.context!,
          configuration: FadeScaleTransitionConfiguration(),
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 60,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Are you sure you want to logout?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 24),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            // Clear user data and navigate to login page
                            PreferenceManagerImpl().logout();
                            Get.offAllNamed(Routes.WELCOME);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Logout'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _getItems => [
        SettingItem(
          icon: Icons.person,
          title: 'Profile Information',
          subtitle: 'Manage account details',
          onTap: () => () {
            // Handle navigation
          },
        ),
        // referral code
        SettingItem(
          icon: Icons.person,
          title: 'Referral Code',
          subtitle: 'Invite your friends and earn rewards',
          onTap: () => () {
            // Handle navigation
          },
        ),
        // about exchanger
        SettingItem(
          icon: Icons.info,
          title: 'About Exchanger',
          subtitle: 'Get to know more about Exchanger',
          onTap: () => () {
            // Handle navigation
          },
        ),
        // faq
        SettingItem(
          icon: Icons.help,
          title: 'FAQs',
          subtitle: 'Frequently asked questions',
          onTap: () => () {
            // Handle navigation
          },
        ),
        // log out
        _logOutButton(),
      ];

  _buildBottomListSection() {
    String year = DateTime.now().year.toString();
    String appVersion = "1.0.0"; // Default version
    String appName = "Exachanger"; // Default app name

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      appName = packageInfo.appName;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
            '� $year $appName. All rights reserved.',
            style: extraSmallBodyTextStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _topStack() {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Blue top container
          Container(
            height: Get.height * 0.25,
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
            top: Get.height * 0.17,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.only(
                top: Get.height * 0.08,
                bottom: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                        controller.userData.value?.name?.toUpperCase() ??
                            'USER',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(height: 4),
                  Obx(() => Text(
                        controller.userData.value?.email ??
                            'You are not logged in',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )),
                ],
              ),
            ),
          ),

          // Profile avatar overlapping blue and white sections
          Positioned(
            top: Get.height * 0.11,
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
                        'https://ui-avatars.com/api/?background=random&name=${controller.userData.value?.name ?? "User"}&size=200',
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
    return Stack(
      children: [
        // Fixed background parts
        Column(
          children: [
            // Top section with blue background
            Container(
              height: Get.height * 0.2,
              color: AppColors.colorPrimary,
            ),

            // Remaining space as white
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Scrollable content
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top space for the blue section and avatar
              SizedBox(height: Get.height * 0.35),

              // Content section with settings items
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Settings items
                    ..._getItems.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: item,
                        )),
                  ],
                ),
              ),

              _buildBottomListSection(),
            ],
          ),
        ),

        // Fixed top elements with curve and profile info
        _topStack(),
      ],
    );
  }
}
