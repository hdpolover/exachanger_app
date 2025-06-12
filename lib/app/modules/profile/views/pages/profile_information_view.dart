import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/core/widgets/cutom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';

class ProfileInformationView extends BaseView<ProfileController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Profile Information',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Avatar Section
          Center(
            child: Column(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?background=random&name=${controller.userData.value?.name ?? "User"}&size=200',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement image picker
                    Get.snackbar(
                      'Coming Soon',
                      'Profile picture update feature will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.colorPrimary,
                      colorText: Colors.white,
                    );
                  },
                  icon: Icon(Icons.camera_alt, size: 18),
                  label: Text('Change Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Profile Information Form
          Text(
            'Personal Information',
            style: titleTextStyle.copyWith(fontSize: 18),
          ),

          SizedBox(height: 16),
          // Full Name Field
          Obx(() {
            final TextEditingController nameController =
                TextEditingController();
            nameController.text = controller.userData.value?.name ?? '';
            return CustomTextFormField(
              controller: nameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outline),
            );
          }),

          SizedBox(height: 16),

          // Email Field
          Obx(() {
            final TextEditingController emailController =
                TextEditingController();
            emailController.text = controller.userData.value?.email ?? '';
            return CustomTextFormField(
              controller: emailController,
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email_outlined),
            );
          }),

          SizedBox(height: 16),

          // Role Field (read-only)
          Obx(() {
            final TextEditingController roleController =
                TextEditingController();
            roleController.text =
                controller.userData.value?.role?.toUpperCase() ?? 'USER';
            return CustomTextFormField(
              controller: roleController,
              labelText: 'Account Type',
              hintText: 'Account type',
              prefixIcon: Icon(Icons.verified_user_outlined),
            );
          }),

          SizedBox(height: 24),

          // Info Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Profile editing features will be available in the next update. Contact support for urgent changes.',
                    style: regularBodyTextStyle.copyWith(
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Spacer(),

          // Future: Update Profile Button (disabled for now)
          CustomButton(
            label: 'Update Profile',
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Profile update feature will be available soon',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.colorPrimary,
                colorText: Colors.white,
              );
            },
            isSmallBtn: false,
          ),
        ],
      ),
    );
  }
}
