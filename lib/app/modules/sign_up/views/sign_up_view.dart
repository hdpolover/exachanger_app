import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_loading_dialog.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controllers/sign_up_controller.dart';
import '../../../core/values/app_values.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_outlined_button.dart';
import '../../../core/widgets/cutom_text_form_field.dart';

class SignUpView extends BaseView<SignUpController> {
  // Use reactive variables
  final RxBool agreeToTerms = false.obs;
  final RxString phoneNumber = ''.obs;

  // Text controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    referralCodeController.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textColorPrimary),
        onPressed: () => Get.back(),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.colorWhite,
      surfaceTintColor: AppColors.colorWhite,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      color: AppColors.colorWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.margin_20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppValues.halfPadding),
              Text('Sign Up', style: titleTextStyle),
              SizedBox(height: AppValues.halfPadding),
              Text(
                'Create account and happy transaction!',
                style: regularBodyTextStyle.copyWith(
                  color: AppColors.textColorSecondary,
                ),
              ),
              SizedBox(height: AppValues.largePadding),
              _signUpForm(context),
              SizedBox(height: AppValues.margin_20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have account? ', style: regularBodyTextStyle),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.SIGN_IN),
                    child: Text(
                      'Sign in',
                      style: regularBodyTextStyle.copyWith(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppValues.largePadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpForm(BuildContext context) {
    // Use controller's formKey but ensure we're using a local key to avoid duplicates
    return Form(
      // Create a key on demand to avoid duplicate key issues
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: fullNameController,
            labelText: 'Full Name',
            hintText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
            validator: controller.validateFullName,
          ),
          SizedBox(height: AppValues.padding),
          CustomTextFormField(
            controller: emailController,
            labelText: 'Email',
            hintText: 'Type your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.mail_outline),
            validator: controller.validateEmail,
          ),
          SizedBox(height: AppValues.padding),
          Text(
            'Phone Number',
            style: regularBodyTextStyle.copyWith(
              color: AppColors.textColorPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppValues.halfPadding),
          IntlPhoneField(
            controller: phoneController,
            decoration: InputDecoration(
              hintText: '+1 2345 678 4321',
              hintStyle: regularBodyTextStyle.copyWith(
                color: AppColors.textColorSecondary,
              ),
              filled: true,
              fillColor: AppColors.pageBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius_12),
                borderSide: BorderSide(color: AppColors.lightGreyColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius_12),
                borderSide: BorderSide(color: AppColors.lightGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radius_12),
                borderSide: BorderSide(color: AppColors.colorPrimary),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppValues.radius_12,
                vertical: AppValues.radius_12,
              ),
            ),
            initialCountryCode: 'US',
            onChanged: (phone) {
              phoneNumber.value = phone.completeNumber;
            },
          ),
          SizedBox(height: AppValues.padding),
          CustomTextFormField(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Type your password',
            isObscure: true,
            prefixIcon: Icon(Icons.lock_outline),
            validator: controller.validatePassword,
          ),
          SizedBox(height: AppValues.padding),
          CustomTextFormField(
            controller: referralCodeController,
            labelText: 'Referral Code (Optional)',
            hintText: 'Enter referral code',
            prefixIcon: Icon(Icons.card_giftcard_outlined),
            validator: null, // Optional field
          ),
          SizedBox(height: AppValues.padding),
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: agreeToTerms.value,
                  activeColor: AppColors.colorPrimary,
                  onChanged: (value) {
                    agreeToTerms.value = value ?? false;
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: regularBodyTextStyle.copyWith(
                        color: AppColors.textColorSecondary,
                      ),
                      children: [
                        TextSpan(text: 'I agree to the company '),
                        TextSpan(
                          text: 'Term of Service',
                          style: regularBodyTextStyle.copyWith(
                            color: AppColors.textColorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: regularBodyTextStyle.copyWith(
                            color: AppColors.textColorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppValues.largePadding),
          CustomButton(label: "Sign Up", onPressed: () => _submit(context)),
          SizedBox(height: AppValues.padding),
          Center(
            child: Text(
              'or',
              style: regularBodyTextStyle.copyWith(
                color: AppColors.textColorSecondary,
              ),
            ),
          ),
          SizedBox(height: AppValues.padding),
          CustomOutlinedButton(
            label: "Sign up with Google",
            icon: Image.asset(
              AppImages.googleLogo,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            onPressed: () async {
              // Show loading with custom animated dialog for Google sign up
              Get.dialog(
                CustomLoadingDialog(
                  message:
                      'Signing up with Google...\nCreating your account...',
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                ),
                barrierDismissible: false,
              );

              // Prepare Google sign-up data
              Map<String, dynamic> data = {
                'email': '', // Will be filled by Firebase
                'phone': phoneController.text.isNotEmpty
                    ? phoneNumber.value
                    : '',
                'password': '', // Not needed for Google sign-up
                'referral_code': referralCodeController.text.trim(),
                'device_token': 'device_token_google',
                'type': 1, // 1 for Google sign-up
              };

              // Call the controller to handle Google sign-up
              controller.doSignUp(data);
            },
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    if (controller.formKey.currentState!.validate() && agreeToTerms.value) {
      // Show loading with custom animated dialog
      Get.dialog(
        CustomLoadingDialog(
          message: 'Creating your account...',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
        ),
        barrierDismissible: false,
      );

      final Map<String, dynamic> data = {
        'email': emailController.text.trim(),
        'phone': phoneNumber.value.isNotEmpty
            ? phoneNumber.value
            : phoneController.text.trim(),
        'password': passwordController.text,
        'referral_code': referralCodeController.text.trim(),
        'device_token': 'device_token_regular',
        'type': 0, // 0 for regular email sign-up
      };

      // Pass the data to controller
      controller.doSignUp(data);
    } else if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms of Service',
        'Please agree to our Terms of Service and Privacy Policy',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(
          seconds: 4,
        ), // Longer duration for this important message
        icon: Icon(Icons.warning, color: Colors.white),
        margin: EdgeInsets.all(16), // Add margins for better spacing
        borderRadius: 8, // Add border radius for better appearance
        isDismissible: true, // Allow manual dismissal
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }
}
