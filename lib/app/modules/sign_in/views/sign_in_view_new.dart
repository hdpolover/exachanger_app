import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_loading_dialog.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/values/app_values.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_outlined_button.dart';
import '../../../core/widgets/cutom_text_form_field.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends BaseView<SignInController> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _submit() async {
    // // set email form
    // emailController.text = "mahendradwipurwanto@gmail.com";
    // // set password form
    // passwordController.text = "Qawsedrf123!@#";

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show loading with custom animated dialog
      Get.dialog(
        CustomLoadingDialog(
          message: 'Signing you in...',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
        ),
        barrierDismissible: false,
      );

      // Add a small delay to show the beautiful loading animation
      await Future.delayed(Duration(milliseconds: 500));

      Map<String, dynamic> data = {
        'email': emailController.text,
        'password': passwordController.text,
        'device_token': 'device',
        'type': 0,
      };

      controller.doSignIn(data);
    }
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppValues.padding),
                    Text('Welcome Back!', style: titleTextStyle),
                    SizedBox(height: 8),
                    Text('Sign in to continue', style: regularBodyTextStyle),
                    SizedBox(height: 16),
                    _signInForm(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppValues.largePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? ', style: regularBodyTextStyle),
                  InkWell(
                    onTap: () {
                      Get.offAndToNamed(Routes.SIGN_UP);
                    },
                    child: Text(
                      'Sign Up',
                      style: regularBodyTextStyle.copyWith(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppValues.halfPadding),
          CustomTextFormField(
            controller: emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
            onChanged: (value) {}, // Email validation handled by validator
          ),
          SizedBox(height: 16),
          CustomTextFormField(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock_outline),
            isObscure: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onChanged: (value) {}, // Password validation handled by validator
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.FORGOT_PASSWORD);
              },
              child: Text(
                'Forgot Password?',
                style: regularBodyTextStyle.copyWith(color: Colors.red),
              ),
            ),
          ),
          SizedBox(height: 24),
          CustomButton(label: "Sign In", onPressed: _submit),
          SizedBox(height: 16),
          Center(
            child: Text(
              'or',
              style: regularBodyTextStyle.copyWith(color: Colors.grey),
            ),
          ),
          SizedBox(height: 16),
          CustomOutlinedButton(
            label: "Sign in with Google",
            icon: Image.asset(
              AppImages.googleLogo,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            onPressed: () async {
              // Show loading with custom animated dialog for Google sign in
              Get.dialog(
                CustomLoadingDialog(
                  message: 'Connecting with Google...',
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                ),
                barrierDismissible: false,
              );

              // Prepare Google sign-in data - this will use Firebase + API /auth/sign-up endpoint
              Map<String, dynamic> data = {
                'email': '', // Will be filled by Firebase
                'password': '', // Not needed for Google sign-in
                'device_token': 'device_token_google',
                'type': 1, // 1 for Google sign-in
              };

              // Call the controller to handle Google sign-in
              controller.doSignIn(data);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
