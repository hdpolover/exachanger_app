import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';

class FaqsView extends BaseView<ProfileController> {
  final List<Map<String, String>> faqData = [
    {
      'question': 'How do I create an account?',
      'answer':
          'To create an account, tap on "Sign Up" from the welcome screen, fill in your details including name, email, and phone number, then verify your email address to complete the registration process.',
    },
    {
      'question': 'How long does it take to process an exchange?',
      'answer':
          'Most exchanges are processed within 15-30 minutes. However, processing times may vary depending on network congestion and the specific cryptocurrencies involved in the transaction.',
    },
    {
      'question': 'What are the fees for exchanges?',
      'answer':
          'Our exchange fees are competitive and vary depending on the currency pair and transaction amount. You can view the exact fees before confirming any transaction on the exchange confirmation screen.',
    },
    {
      'question': 'Is my personal information secure?',
      'answer':
          'Yes, we use bank-level security measures including end-to-end encryption, secure servers, and comply with industry security standards to protect your personal and financial information.',
    },
    {
      'question': 'How can I track my transaction?',
      'answer':
          'You can track all your transactions in the "History" tab. Each transaction has a unique ID and shows the current status, from pending to completed.',
    },
    {
      'question': 'What should I do if my transaction is delayed?',
      'answer':
          'If your transaction is taking longer than expected, please check the transaction status in your history. If the issue persists, contact our support team with your transaction ID.',
    },
    {
      'question': 'How do I use a referral code?',
      'answer':
          'During sign-up, enter the referral code in the "Referral Code" field. Both you and the person who referred you will receive special bonuses once your account is verified.',
    },
    {
      'question': 'Can I cancel a transaction?',
      'answer':
          'Transactions can only be cancelled within a specific time window before processing begins. Once processing starts, transactions cannot be cancelled for security reasons.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We support various payment methods including bank transfers, cryptocurrency wallets, and digital payment platforms. Available methods may vary by region.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can contact our 24/7 customer support through the app by going to Profile > About Exachanger, or email us at support@exachanger.com for assistance.',
    },
  ];

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Frequently Asked Questions',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search FAQs...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              border: InputBorder.none,
              hintStyle: regularBodyTextStyle.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            onChanged: (value) {
              // TODO: Implement search functionality
            },
          ),
        ),

        // Header Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Find answers to commonly asked questions about Exachanger. If you can\'t find what you\'re looking for, feel free to contact our support team.',
            style: regularBodyTextStyle.copyWith(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 20),

        // FAQ List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: faqData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _buildFaqItem(
                  question: faqData[index]['question']!,
                  answer: faqData[index]['answer']!,
                ),
              );
            },
          ),
        ),

        // Contact Support Section
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.colorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.colorPrimary.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.support_agent,
                color: AppColors.colorPrimary,
                size: 32,
              ),
              SizedBox(height: 12),
              Text(
                'Still have questions?',
                style: titleTextStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.colorPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Our support team is here to help you 24/7',
                style: regularBodyTextStyle.copyWith(
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Contact Support',
                    'Support chat will be available soon. Email us at support@exachanger.com',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.colorPrimary,
                    colorText: Colors.white,
                    duration: Duration(seconds: 4),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Contact Support'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: regularBodyTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: regularBodyTextStyle.copyWith(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
        iconColor: AppColors.colorPrimary,
        collapsedIconColor: Colors.grey.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
