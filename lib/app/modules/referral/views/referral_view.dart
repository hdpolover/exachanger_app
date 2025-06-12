import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/referral_controller.dart';

class ReferralView extends BaseView<ReferralController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Referral Program',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards Section
            _buildStatsSection(),

            SizedBox(height: 24),

            // Referral Code Section
            _buildReferralCodeSection(),

            SizedBox(height: 24),

            // How it Works Section
            _buildHowItWorksSection(),

            SizedBox(height: 24),

            // Referral History Section
            _buildReferralHistorySection(),

            SizedBox(height: 24),

            // Terms & Conditions
            _buildTermsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referral Stats',
          style: titleTextStyle.copyWith(fontSize: 18),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCardInt(
                title: 'Total Referrals',
                value: controller.totalReferrals,
                icon: Icons.people,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCardDouble(
                title: 'Total Earnings',
                value: controller.totalEarnings,
                icon: Icons.attach_money,
                color: Colors.green,
                isAmount: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCardInt({
    required String title,
    required RxInt value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Obx(
            () => Text(
              '${value.value}',
              style: titleTextStyle.copyWith(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: regularBodyTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardDouble({
    required String title,
    required RxDouble value,
    required IconData icon,
    required Color color,
    bool isAmount = false,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Obx(
            () => Text(
              isAmount
                  ? '\$${value.value.toStringAsFixed(2)}'
                  : '${value.value}',
              style: titleTextStyle.copyWith(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: regularBodyTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referral Code',
          style: titleTextStyle.copyWith(fontSize: 18),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.colorPrimary,
                AppColors.colorPrimary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(Icons.card_giftcard, size: 48, color: Colors.white),
              SizedBox(height: 12),
              Text(
                'Invite Friends & Earn Rewards',
                style: titleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => Text(
                    controller.referralCode.value,
                    style: titleTextStyle.copyWith(
                      fontSize: 24,
                      letterSpacing: 2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.copyReferralCode,
                      icon: Icon(Icons.copy, size: 18),
                      label: Text('Copy Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.shareReferralCode,
                      icon: Icon(Icons.share, size: 18),
                      label: Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How it Works', style: titleTextStyle.copyWith(fontSize: 18)),
        SizedBox(height: 16),
        _buildHowItWorksItem(
          number: 1,
          icon: Icons.person_add,
          title: 'Invite Friends',
          description: 'Share your referral code with friends and family',
        ),
        SizedBox(height: 16),
        _buildHowItWorksItem(
          number: 2,
          icon: Icons.app_registration,
          title: 'They Sign Up',
          description: 'Your friends register using your referral code',
        ),
        SizedBox(height: 16),
        _buildHowItWorksItem(
          number: 3,
          icon: Icons.card_giftcard,
          title: 'Earn Rewards',
          description:
              'Both of you get \$25 bonus when they complete first transaction',
        ),
      ],
    );
  }

  Widget _buildHowItWorksItem({
    required int number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.colorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(icon, color: AppColors.colorPrimary, size: 24),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildReferralHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Referrals', style: titleTextStyle.copyWith(fontSize: 18)),
        SizedBox(height: 16),
        Obx(
          () => controller.referralHistory.isEmpty
              ? _buildEmptyReferrals()
              : Column(
                  children: controller.referralHistory
                      .take(5) // Show only first 5
                      .map((referral) => _buildReferralItem(referral))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyReferrals() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'No referrals yet',
            style: titleTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start inviting friends to see your referral history here',
            style: regularBodyTextStyle.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralItem(Map<String, dynamic> referral) {
    final status = referral['status'] as String;
    final isActive = status == 'Active';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isActive
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            child: Icon(
              isActive ? Icons.check_circle : Icons.pending,
              color: isActive ? Colors.green : Colors.orange,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral['name'] as String,
                  style: regularBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Joined ${referral['date']}',
                  style: smallBodyTextStyle.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: smallBodyTextStyle.copyWith(
                    color: isActive ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isActive) ...[
                SizedBox(height: 4),
                Text(
                  '\$${(referral['earnings'] as double).toStringAsFixed(0)}',
                  style: regularBodyTextStyle.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: regularBodyTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            '• Both you and your friend get \$25 when they complete their first transaction\n'
            '• Rewards are processed within 24-48 hours\n'
            '• Maximum 50 referrals per month\n'
            '• Referral must be a new user to Exachanger\n'
            '• Terms subject to change without notice',
            style: smallBodyTextStyle.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
