import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controllers/profile_controller.dart';

class AboutExachangerView extends BaseView<ProfileController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'About Exachanger',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo and Name Section
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.currency_exchange,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Exachanger',
                  style: titleTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    return Text(
                      'Version ${snapshot.data?.version ?? "1.0.0"}',
                      style: regularBodyTextStyle.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // About Section
          Text('About Us', style: titleTextStyle.copyWith(fontSize: 18)),

          SizedBox(height: 16),

          Text(
            'Exachanger is a modern, secure, and user-friendly digital currency exchange platform. We provide seamless trading experiences with competitive rates and reliable services.',
            style: regularBodyTextStyle.copyWith(height: 1.5),
          ),

          SizedBox(height: 24),

          // Features Section
          Text('Key Features', style: titleTextStyle.copyWith(fontSize: 18)),

          SizedBox(height: 16),

          Column(
            children: [
              _buildFeatureItem(
                icon: Icons.security,
                title: 'Secure Transactions',
                description: 'Bank-level security with end-to-end encryption',
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                icon: Icons.speed,
                title: 'Fast Processing',
                description: 'Quick and efficient transaction processing',
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                icon: Icons.support_agent,
                title: '24/7 Support',
                description: 'Round-the-clock customer support',
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                icon: Icons.trending_up,
                title: 'Competitive Rates',
                description: 'Best exchange rates in the market',
              ),
            ],
          ),

          SizedBox(height: 32),

          // Contact Information
          Text(
            'Contact Information',
            style: titleTextStyle.copyWith(fontSize: 18),
          ),

          SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactItem(
                  icon: Icons.email,
                  label: 'Email',
                  value: 'support@exachanger.com',
                ),
                SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: '+1 (555) 123-4567',
                ),
                SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.language,
                  label: 'Website',
                  value: 'www.exachanger.com',
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Legal Section
          Text('Legal', style: titleTextStyle.copyWith(fontSize: 18)),

          SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Terms of Service will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.colorPrimary,
                    colorText: Colors.white,
                  );
                },
                child: Text('Terms of Service'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.colorPrimary,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Privacy Policy will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.colorPrimary,
                    colorText: Colors.white,
                  );
                },
                child: Text('Privacy Policy'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.colorPrimary,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Licenses information will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.colorPrimary,
                    colorText: Colors.white,
                  );
                },
                child: Text('Open Source Licenses'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.colorPrimary,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),

          SizedBox(height: 32),

          // Copyright
          Center(
            child: Text(
              '© ${DateTime.now().year} Exachanger. All rights reserved.',
              style: smallBodyTextStyle.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.colorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.colorPrimary, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: regularBodyTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: regularBodyTextStyle.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.colorPrimary, size: 20),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: smallBodyTextStyle.copyWith(color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: regularBodyTextStyle.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
